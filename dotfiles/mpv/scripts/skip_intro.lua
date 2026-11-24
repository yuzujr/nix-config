local mp = require("mp")
local msg = require("mp.msg")
local utils = require("mp.utils")
local input = require("mp.input")

local IMAGE_EXTENSIONS = {
    avif = true,
    bmp = true,
    gif = true,
    jpeg = true,
    jpg = true,
    png = true,
    webp = true,
}

local function get_state_dir()
    local state_dir = mp.command_native({ "expand-path", "~~state/" })
    if state_dir and state_dir ~= "" then
        return state_dir:gsub("/+$", "")
    end
    local xdg_state = os.getenv("XDG_STATE_HOME")
    if xdg_state and xdg_state ~= "" then
        return utils.join_path(xdg_state:gsub("/+$", ""), "mpv")
    end
    local home = os.getenv("HOME")
    if home and home ~= "" then
        return utils.join_path(home:gsub("/+$", ""), ".local/state/mpv")
    end
    return "/tmp/mpv-state"
end

local state_dir = get_state_dir()
local state_file = utils.join_path(state_dir, "skip-intro.json")

local current_dir = nil
local current_entry = nil
local intro_done = false
local outro_done = false
local last_time_pos = nil
local observing = false
local cached_duration = nil
local cached_seeking = false
local outro_trigger = nil

local function round_tenth(value)
    return math.floor(value * 10 + 0.5) / 10
end

local function format_time(seconds)
    local total = math.max(0, math.floor((seconds or 0) + 0.5))
    local hours = math.floor(total / 3600)
    local minutes = math.floor((total % 3600) / 60)
    local secs = total % 60
    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, minutes, secs)
    end
    return string.format("%02d:%02d", minutes, secs)
end

local function ensure_state_dir()
    local info = utils.file_info(state_dir)
    if info and info.is_dir then
        return true
    end
    local res = mp.command_native({
        name = "subprocess",
        playback_only = false,
        args = { "mkdir", "-p", state_dir },
    })
    return res and res.status == 0
end

local function normalize_entry(raw)
    if type(raw) ~= "table" then
        return nil
    end
    local intro = tonumber(raw.intro)
    local outro = tonumber(raw.outro_remaining)
    if intro and intro <= 0 then
        intro = nil
    end
    if outro and outro <= 0 then
        outro = nil
    end
    if not intro and not outro then
        return nil
    end
    local entry = {
        intro = intro,
        outro_remaining = outro,
    }
    if raw.enabled == false then
        entry.enabled = false
    end
    return entry
end

local function read_db()
    local file = io.open(state_file, "rb")
    if not file then
        return {}
    end
    local content = file:read("*a")
    file:close()
    if not content or content == "" then
        return {}
    end
    local data, err = utils.parse_json(content)
    if type(data) ~= "table" then
        msg.warn("Failed to parse skip-intro state JSON: " .. tostring(err))
        return {}
    end
    return data
end

local function write_db(db)
    if not ensure_state_dir() then
        msg.error("Failed to create state directory: " .. state_dir)
        return false
    end
    local encoded
    if next(db) == nil then
        encoded = "{}"
    else
        local ok, formatted = pcall(utils.format_json, db)
        if not ok or not formatted then
            msg.error("Failed to encode skip-intro state JSON")
            return false
        end
        encoded = formatted
    end

    local tmp_file = state_file .. ".tmp"
    local file = io.open(tmp_file, "wb")
    if file then
        local ok_write = file:write(encoded .. "\n")
        file:close()
        if ok_write then
            local ok_rename = os.rename(tmp_file, state_file)
            if ok_rename then
                return true
            end
        end
        os.remove(tmp_file)
    end

    local direct = io.open(state_file, "wb")
    if not direct then
        msg.error("Failed to write skip-intro state file: " .. state_file)
        return false
    end
    local ok_direct = direct:write(encoded .. "\n")
    direct:close()
    return ok_direct == true
end

local function mutate_entry(dir, mutator)
    local db = read_db()
    local entry = normalize_entry(db[dir]) or {}
    mutator(entry)
    local cleaned = normalize_entry(entry)
    db[dir] = cleaned
    if write_db(db) then
        return cleaned
    end
    return cleaned
end

local function get_video_dir()
    local path = mp.get_property("path")
    if not path or path == "" or path:match("^%a[%w+.-]*://") then
        return nil
    end
    local extension = path:lower():match("%.([^./]+)$")
    if extension and IMAGE_EXTENSIONS[extension] then
        return nil
    end
    if path:sub(1, 1) ~= "/" then
        local workdir = mp.get_property("working-directory", "")
        if workdir == "" then
            return nil
        end
        path = utils.join_path(workdir, path)
    end
    local directory = utils.split_path(path)
    if not directory or directory == "" then
        return nil
    end
    if directory ~= "/" then
        directory = directory:gsub("/+$", "")
    end
    return directory
end

local function recompute_outro_trigger()
    outro_trigger = nil
    if not current_entry or current_entry.enabled == false then
        return
    end
    local outro = current_entry.outro_remaining
    if not outro or outro <= 0 then
        return
    end
    local dur = cached_duration
    if not dur or dur <= 0 then
        return
    end
    local trigger = dur - outro
    local min_trigger = (current_entry.intro or 0) + 10
    if trigger > min_trigger and trigger < dur - 1 then
        outro_trigger = trigger
    end
end

local function needs_watchers()
    if not current_entry or current_entry.enabled == false then
        return false
    end
    if not intro_done and current_entry.intro and current_entry.intro > 0 then
        return true
    end
    if not outro_done and current_entry.outro_remaining and current_entry.outro_remaining > 0 then
        return true
    end
    return false
end

local sync_watchers

local function try_skip_intro(pos)
    if intro_done or not current_entry or current_entry.enabled == false then
        return false
    end
    local intro = current_entry.intro
    if not intro or intro <= 0 then
        return false
    end
    if pos == nil then
        pos = mp.get_property_number("time-pos")
    end
    if pos == nil then
        return false
    end
    local dur = cached_duration or mp.get_property_number("duration")
    if dur and intro >= dur - 5 then
        intro_done = true
        sync_watchers()
        return false
    end
    if pos < intro - 1 then
        intro_done = true
        last_time_pos = intro
        sync_watchers()
        mp.commandv("seek", intro, "absolute+exact")
        mp.osd_message("已自动跳过片头 → " .. format_time(intro), 3)
        return true
    end
    intro_done = true
    sync_watchers()
    return false
end

local function on_duration(_, dur)
    cached_duration = dur
    recompute_outro_trigger()
end

local function on_seeking(_, seeking)
    cached_seeking = (seeking == true)
end

local function on_time_pos(_, pos)
    if pos == nil then
        return
    end
    if not intro_done and try_skip_intro(pos) then
        return
    end
    if not outro_done and outro_trigger and not cached_seeking then
        local trigger = outro_trigger
        local crossed = last_time_pos ~= nil and last_time_pos < trigger and pos >= trigger
        local in_window = pos >= trigger and pos <= trigger + 2.5
        if crossed or in_window then
            outro_done = true
            sync_watchers()
            local pl_pos = mp.get_property_number("playlist-pos", -1)
            local pl_count = mp.get_property_number("playlist-count", 0)
            if pl_pos >= 0 and pl_pos + 1 < pl_count then
                mp.osd_message("已跳过片尾，进入下一集", 3)
                mp.commandv("playlist-next", "force")
            else
                mp.osd_message("已到设定片尾点（当前已是最后一集）", 3)
            end
        end
    end
    last_time_pos = pos
end

sync_watchers = function()
    local want = needs_watchers()
    if want and not observing then
        observing = true
        cached_duration = mp.get_property_number("duration")
        cached_seeking = mp.get_property_bool("seeking", false)
        last_time_pos = mp.get_property_number("time-pos")
        recompute_outro_trigger()
        mp.observe_property("duration", "number", on_duration)
        mp.observe_property("seeking", "bool", on_seeking)
        mp.observe_property("time-pos", "number", on_time_pos)
    elseif not want and observing then
        observing = false
        outro_trigger = nil
        mp.unobserve_property(on_time_pos)
        mp.unobserve_property(on_seeking)
        mp.unobserve_property(on_duration)
    elseif observing then
        recompute_outro_trigger()
    end
end

local function on_file_loaded()
    last_time_pos = nil
    current_dir = get_video_dir()
    if current_dir then
        local db = read_db()
        current_entry = normalize_entry(db[current_dir])
    else
        current_entry = nil
    end
    cached_duration = mp.get_property_number("duration")
    cached_seeking = mp.get_property_bool("seeking", false)
    intro_done = not (current_entry and current_entry.intro)
    outro_done = not (current_entry and current_entry.outro_remaining)
    try_skip_intro()
    recompute_outro_trigger()
    sync_watchers()
end

local function on_seek()
    if observing then
        last_time_pos = mp.get_property_number("time-pos")
    end
end

local function on_end_file()
    current_dir = nil
    current_entry = nil
    intro_done = false
    outro_done = false
    last_time_pos = nil
    cached_duration = nil
    cached_seeking = false
    recompute_outro_trigger()
    sync_watchers()
end

local function set_intro()
    if not current_dir then
        mp.osd_message("仅支持为本地视频目录设置跳过片头", 3)
        return
    end
    local pos = mp.get_property_number("time-pos")
    if not pos or pos <= 0.5 then
        mp.osd_message("当前播放时间太靠前，无法设为片头结束点", 3)
        return
    end
    local dur = mp.get_property_number("duration")
    if dur and pos >= dur - 5 then
        mp.osd_message("当前时间过于接近结尾，无法设为片头结束点", 3)
        return
    end
    local intro = round_tenth(pos)
    current_entry = mutate_entry(current_dir, function(entry)
        entry.intro = intro
        entry.enabled = nil
    end)
    intro_done = true
    outro_done = not (current_entry and current_entry.outro_remaining)
    recompute_outro_trigger()
    sync_watchers()
    mp.osd_message("已设本目录片头结束点：" .. format_time(intro) .. "（下集自动跳过）", 3)
end

local function set_outro()
    if not current_dir then
        mp.osd_message("仅支持为本地视频目录设置跳过片尾", 3)
        return
    end
    local pos = mp.get_property_number("time-pos")
    local dur = mp.get_property_number("duration")
    if not pos or not dur or dur <= 0 then
        mp.osd_message("无法获取当前时间或视频总时长", 3)
        return
    end
    local remaining = dur - pos
    if remaining <= 1 then
        mp.osd_message("当前时间过于接近结尾，无法设为片尾开始点", 3)
        return
    end
    local intro = (current_entry and current_entry.intro) or 0
    if pos <= intro + 5 then
        mp.osd_message("片尾点必须晚于片头结束点至少 5 秒", 3)
        return
    end
    remaining = round_tenth(remaining)
    current_entry = mutate_entry(current_dir, function(entry)
        entry.outro_remaining = remaining
        entry.enabled = nil
    end)
    outro_done = true
    recompute_outro_trigger()
    sync_watchers()
    mp.osd_message(
        "已设本目录片尾：最后 " .. format_time(remaining) .. "（本集 " .. format_time(pos) .. "，下集自动跳过）",
        3
    )
end

local function clear_intro()
    if not current_dir or not current_entry or not current_entry.intro then
        mp.osd_message("当前目录未设置片头结束点", 3)
        return
    end
    current_entry = mutate_entry(current_dir, function(entry)
        entry.intro = nil
    end)
    intro_done = true
    recompute_outro_trigger()
    sync_watchers()
    mp.osd_message("已清除本目录片头设置", 3)
end

local function clear_outro()
    if not current_dir or not current_entry or not current_entry.outro_remaining then
        mp.osd_message("当前目录未设置片尾开始点", 3)
        return
    end
    current_entry = mutate_entry(current_dir, function(entry)
        entry.outro_remaining = nil
    end)
    outro_done = true
    recompute_outro_trigger()
    sync_watchers()
    mp.osd_message("已清除本目录片尾设置", 3)
end

local function clear_all()
    if not current_dir or not current_entry then
        mp.osd_message("当前目录未设置片头/片尾", 3)
        return
    end
    current_entry = mutate_entry(current_dir, function(entry)
        entry.intro = nil
        entry.outro_remaining = nil
        entry.enabled = nil
    end)
    intro_done = true
    outro_done = true
    recompute_outro_trigger()
    sync_watchers()
    mp.osd_message("已清除本目录片头/片尾设置", 3)
end

local function toggle_enabled()
    if not current_dir or not current_entry then
        mp.osd_message("当前目录未设置片头/片尾", 3)
        return
    end
    local next_enabled = (current_entry.enabled == false)
    current_entry = mutate_entry(current_dir, function(entry)
        if next_enabled then
            entry.enabled = nil
        else
            entry.enabled = false
        end
    end)
    recompute_outro_trigger()
    sync_watchers()
    mp.osd_message(next_enabled and "已恢复本目录自动跳过" or "已暂停本目录自动跳过", 3)
end

local function jump_to_intro()
    if not current_entry or not current_entry.intro then
        return
    end
    local intro = current_entry.intro
    local dur = mp.get_property_number("duration")
    if dur and intro >= dur - 5 then
        mp.osd_message("设定的片头时间超过本集时长", 3)
        return
    end
    intro_done = true
    last_time_pos = intro
    recompute_outro_trigger()
    sync_watchers()
    mp.commandv("seek", intro, "absolute+exact")
    mp.osd_message("已跳至片头结束点 → " .. format_time(intro), 3)
end

local function skip_to_next_episode()
    local pl_pos = mp.get_property_number("playlist-pos", -1)
    local pl_count = mp.get_property_number("playlist-count", 0)
    if pl_pos >= 0 and pl_pos + 1 < pl_count then
        outro_done = true
        recompute_outro_trigger()
        sync_watchers()
        mp.osd_message("跳过片尾，进入下一集", 3)
        mp.commandv("playlist-next", "force")
    end
end

local function open_menu()
    if not current_dir then
        mp.osd_message("仅支持为本地视频目录设置片头/片尾跳过", 3)
        return
    end
    local pos = mp.get_property_number("time-pos")
    local dur = mp.get_property_number("duration")
    local has_intro = current_entry and current_entry.intro ~= nil
    local has_outro = current_entry and current_entry.outro_remaining ~= nil

    local labels = {}
    local actions = {}
    local function add_item(label, fn)
        labels[#labels + 1] = label
        actions[#actions + 1] = fn
    end

    local intro_suffix = has_intro and ("（当前：" .. format_time(current_entry.intro) .. "）") or ""
    local pos_label = pos and format_time(pos) or "--:--"
    add_item("将当前时间 (" .. pos_label .. ") 设为片头结束点" .. intro_suffix, set_intro)

    local outro_suffix = has_outro and ("（当前：-" .. format_time(current_entry.outro_remaining) .. "）") or ""
    local rem_label = (pos and dur and dur > pos) and ("-" .. format_time(dur - pos)) or "--:--"
    add_item("将当前时间 (" .. pos_label .. " / 剩余 " .. rem_label .. ") 设为片尾开始点" .. outro_suffix, set_outro)

    if has_intro and pos and pos < current_entry.intro - 1 then
        add_item("立即跳至片头结束点 (" .. format_time(current_entry.intro) .. ")", jump_to_intro)
    end

    local pl_pos = mp.get_property_number("playlist-pos", -1)
    local pl_count = mp.get_property_number("playlist-count", 0)
    if has_outro and pl_pos >= 0 and pl_pos + 1 < pl_count then
        add_item("立即跳过片尾进入下一集", skip_to_next_episode)
    end

    if has_intro or has_outro then
        if current_entry.enabled == false then
            add_item("恢复本目录自动跳过", toggle_enabled)
        else
            add_item("暂停本目录自动跳过", toggle_enabled)
        end
    end

    if has_intro then
        add_item("清除片头设置 (" .. format_time(current_entry.intro) .. ")", clear_intro)
    end
    if has_outro then
        add_item("清除片尾设置 (-" .. format_time(current_entry.outro_remaining) .. ")", clear_outro)
    end
    if has_intro and has_outro then
        add_item("清除本目录全部设置", clear_all)
    end

    input.select({
        prompt = "片头/片尾跳过：",
        items = labels,
        submit = function(index)
            if index and actions[index] then
                actions[index]()
            end
        end,
    })
end

mp.register_event("file-loaded", on_file_loaded)
mp.register_event("seek", on_seek)
mp.register_event("end-file", on_end_file)

mp.add_key_binding("Alt+[", "set-intro", set_intro)
mp.add_key_binding("Alt+]", "set-outro", set_outro)
mp.add_key_binding("Alt+\\", "clear-all", clear_all)
mp.add_key_binding("Alt+k", "menu", open_menu)

mp.register_script_message("menu", open_menu)
mp.register_script_message("set-intro", set_intro)
mp.register_script_message("set-outro", set_outro)
mp.register_script_message("clear-all", clear_all)
mp.register_script_message("toggle", toggle_enabled)
