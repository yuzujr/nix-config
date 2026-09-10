{ lib, ... }:
let
    map = mode: key: action: desc:
        {
            inherit mode key action;
        }
        // lib.optionalAttrs (desc != null) {
            options.desc = desc;
        };
    lua = mode: key: body: desc: map mode key { __raw = "function() ${body} end"; } desc;
    normal = map "n";
    normalLua = lua "n";
in
{
    keymaps = [
        (normal "<Esc>" "<cmd>nohlsearch<cr>" "Clear search highlight")
        (normal "<leader>fn" "<cmd>Noice history<cr>" "Notification history")
        (normal "<leader>un" "<cmd>Noice dismiss<cr>" "Dismiss notifications")
        (normal "Q" "<nop>" null)
        (normal "q:" ":" "Open command line")
        (map "v" ">" ">gv" null)
        (map "v" "<" "<gv" null)
        (map [ "n" "x" ] "<leader>y" ''"+y'' "Yank to system clipboard")
        (map "x" "<leader>p" ''"_dP'' "Paste without replacing yank")

        (normal "<C-h>" "<C-w>h" null)
        (normal "<C-j>" "<C-w>j" null)
        (normal "<C-k>" "<C-w>k" null)
        (normal "<C-l>" "<C-w>l" null)
        (normal "]b" "<cmd>bnext<cr>" "Next buffer")
        (normal "[b" "<cmd>bprevious<cr>" "Previous buffer")
        (map "t" "<Esc><Esc>" "<C-\\><C-n>" null)
        (map [ "n" "t" ] "]]" { __raw = "function() Snacks.words.jump(vim.v.count1) end"; } "Next reference")
        (map [ "n" "t" ] "[[" { __raw = "function() Snacks.words.jump(-vim.v.count1) end"; } "Previous reference")

        (normalLua "<leader><space>" "Snacks.picker.smart()" "Smart find")
        (normalLua "<leader>ff" "Snacks.picker.files()" "Find files")
        (normalLua "<leader>fg" "Snacks.picker.grep()" "Grep")
        (normalLua "<leader>fr" "Snacks.picker.recent()" "Recent files")
        (normalLua "<leader>fb" "Snacks.picker.buffers()" "Buffers")
        (normalLua "<leader>fe" "Snacks.explorer()" "File explorer")
        (normalLua "<C-n>" "Snacks.explorer()" "File explorer")

        (normalLua "<leader>jj" ''require("flash").jump()'' "Jump")
        (normalLua "<leader>jt" ''require("flash").treesitter()'' "Treesitter jump")
        (normalLua "<leader>jr" ''require("flash").remote()'' "Remote jump")
        (normalLua "<leader>js" ''require("flash").treesitter_search()'' "Treesitter search jump")

        (normalLua "<leader>cf" ''require("conform").format({ async = true })'' "Format buffer")

        (normalLua "<leader>gg" "Snacks.picker.git_status()" "Git status")
        (normalLua "<leader>gb" "Snacks.git.blame_line()" "Git blame line")
        (lua [ "n" "x" ] "<leader>gB" "Snacks.gitbrowse()" "Git browse")

        (normalLua "<leader>bd" "Snacks.bufdelete()" "Delete buffer")
        (normalLua "<leader>cR" "Snacks.rename.rename_file()" "Rename file")

        (normalLua "<leader>us" ''Snacks.toggle.option("spell", { name = "Spelling" }):toggle()'' "Toggle spelling")
        (normalLua "<leader>uw" ''Snacks.toggle.option("wrap", { name = "Wrap" }):toggle()'' "Toggle wrap")
        (normalLua "<leader>uL" ''Snacks.toggle.option("relativenumber", { name = "Relative number" }):toggle()'' "Toggle relative number")
        (normalLua "<leader>ul" "Snacks.toggle.line_number():toggle()" "Toggle line numbers")
        (normalLua "<leader>ud" "Snacks.toggle.diagnostics():toggle()" "Toggle diagnostics")
        (normalLua "<leader>uh" "Snacks.toggle.inlay_hints():toggle()" "Toggle inlay hints")
        (normalLua "<leader>uT" "Snacks.toggle.treesitter():toggle()" "Toggle Treesitter")
        (normalLua "<leader>ug" "Snacks.toggle.indent():toggle()" "Toggle indent guides")
    ];
}
