{
    autoCmd = [
        {
            event = "CmdwinEnter";
            pattern = ":";
            command = "quit | call feedkeys(':', 'n')";
        }
        {
            event = "TextYankPost";
            callback.__raw = "function() vim.highlight.on_yank({ timeout = 180 }) end";
        }
        {
            event = [
                "FocusGained"
                "TermClose"
                "TermLeave"
            ];
            command = "checktime";
        }
    ];
}
