local mp = require("mp")
local msg = require("mp.msg")
local utils = require("mp.utils")

local current = nil
local info_visible = false
local info_timer = nil

local function hide_info()
    if not info_visible then
        return
    end
    if info_timer then
        info_timer:kill()
        info_timer = nil
    end
    info_visible = false
    mp.osd_message("", 0)
end

local function trim(value)
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function decode_xml(value)
    local cdata = value:match("^%s*<!%[CDATA%[(.*)%]%]>%s*$")
    value = cdata or value
    value = value:gsub("<br%s*/?>", "\n"):gsub("<.->", "")
    value = value:gsub("&quot;", '"'):gsub("&apos;", "'")
    value = value:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&")
    return trim(value:gsub("[ \t]+", " "):gsub("%s*\n%s*", "\n"))
end

local function first_tag(xml, tag)
    local value = xml:match("<" .. tag .. "[^>]*>(.-)</" .. tag .. ">")
    return value and decode_xml(value) or nil
end

local function all_tags(xml, tag)
    local values = {}
    local seen = {}
    for value in xml:gmatch("<" .. tag .. "[^>]*>(.-)</" .. tag .. ">") do
        value = decode_xml(value)
        if value ~= "" and not seen[value] then
            seen[value] = true
            values[#values + 1] = value
        end
    end
    return values
end

local function read_file(path)
    local file = io.open(path, "rb")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return content
end

local function file_exists(path)
    local info = utils.file_info(path)
    return info and info.is_file
end

local function strip_extension(name)
    return (name:gsub("%.[^./]+$", ""))
end

local function normalized_stem(name)
    name = strip_extension(name)
    name = name:gsub("[%s%._%-]+[Cc][Dd]%s*%d+", " ")
    name = name:gsub("[%s%._%-]+", " ")
    return trim(name):lower()
end

local function find_nfo(video_path)
    local directory, filename = utils.split_path(video_path)
    local stem = strip_extension(filename)
    local exact = utils.join_path(directory, stem .. ".nfo")
    if file_exists(exact) then
        return exact
    end

    local movie = utils.join_path(directory, "movie.nfo")
    if file_exists(movie) then
        return movie
    end

    local files = utils.readdir(directory, "files") or {}
    local candidates = {}
    local wanted = normalized_stem(filename)
    for _, name in ipairs(files) do
        if name:lower():match("%.nfo$") then
            local path = utils.join_path(directory, name)
            candidates[#candidates + 1] = path
            if normalized_stem(name) == wanted then
                return path
            end
        end
    end

    if #candidates == 1 then
        return candidates[1]
    end
    return nil
end

local function disc_label(filename)
    local disc = filename:match("[%s%._%-]([Cc][Dd]%s*%d+)")
    return disc and disc:upper():gsub("%s+", "") or nil
end

local function parse_nfo(path)
    local xml = read_file(path)
    if not xml then
        return nil
    end

    local actors = {}
    for block in xml:gmatch("<actor[^>]*>(.-)</actor>") do
        local name = first_tag(block, "name")
        if name and name ~= "" then
            actors[#actors + 1] = name
        end
    end

    return {
        title = first_tag(xml, "title"),
        original_title = first_tag(xml, "originaltitle"),
        year = first_tag(xml, "year"),
        premiered = first_tag(xml, "premiered"),
        rating = first_tag(xml, "rating"),
        mpaa = first_tag(xml, "mpaa"),
        plot = first_tag(xml, "plot"),
        imdb_id = first_tag(xml, "imdbid"),
        tmdb_id = first_tag(xml, "tmdbid"),
        genres = all_tags(xml, "genre"),
        directors = all_tags(xml, "director"),
        actors = actors,
        path = path,
    }
end

local function join_nonempty(values, separator)
    local result = {}
    for _, value in ipairs(values) do
        if value and value ~= "" then
            result[#result + 1] = value
        end
    end
    return table.concat(result, separator)
end

local function load_nfo()
    hide_info()
    current = nil
    local path = mp.get_property("path")
    if not path or path:match("^%a[%w+.-]*://") then
        return
    end
    local extension = path:lower():match("%.([^./]+)$")
    if extension and ({
        avif = true,
        bmp = true,
        gif = true,
        jpeg = true,
        jpg = true,
        png = true,
        webp = true,
    })[extension] then
        return
    end
    if path:sub(1, 1) ~= "/" then
        path = utils.join_path(mp.get_property("working-directory", ""), path)
    end

    local nfo_path = find_nfo(path)
    if not nfo_path then
        return
    end
    current = parse_nfo(nfo_path)
    if not current or not current.title or current.title == "" then
        current = nil
        return
    end

    local _, filename = utils.split_path(path)
    local title = current.title
    local disc = disc_label(filename)
    if disc then
        title = title .. " · " .. disc
    end
    mp.set_property("file-local-options/force-media-title", title)
    msg.info("Loaded NFO metadata: " .. nfo_path)
end

local function show_info()
    if info_visible then
        hide_info()
        return
    end
    if not current then
        mp.osd_message("当前影片没有找到可用的 NFO 信息", 3)
        return
    end

    local lines = { current.title }
    if current.original_title and current.original_title ~= current.title then
        lines[#lines + 1] = current.original_title
    end
    lines[#lines + 1] = join_nonempty({ current.year, current.rating and "评分 " .. current.rating, current.mpaa }, "  ·  ")
    if #current.genres > 0 then
        lines[#lines + 1] = "类型：" .. table.concat(current.genres, " / ")
    end
    if #current.directors > 0 then
        lines[#lines + 1] = "导演：" .. table.concat(current.directors, " / ")
    end
    if #current.actors > 0 then
        local cast = {}
        for index = 1, math.min(6, #current.actors) do
            cast[#cast + 1] = current.actors[index]
        end
        lines[#lines + 1] = "主演：" .. table.concat(cast, " / ")
    end
    if current.plot and current.plot ~= "" then
        lines[#lines + 1] = "\n" .. current.plot
    end
    local ids = join_nonempty({
        current.imdb_id and "IMDb " .. current.imdb_id,
        current.tmdb_id and "TMDB " .. current.tmdb_id,
    }, "  ·  ")
    if ids ~= "" then
        lines[#lines + 1] = "\n" .. ids
    end
    mp.osd_message(table.concat(lines, "\n"), 12)
    info_visible = true
    info_timer = mp.add_timeout(12, function()
        info_visible = false
        info_timer = nil
    end)
end

mp.add_hook("on_load", 50, load_nfo)
mp.add_key_binding("Ctrl+i", "nfo-info", show_info)
mp.register_script_message("show-info", show_info)
