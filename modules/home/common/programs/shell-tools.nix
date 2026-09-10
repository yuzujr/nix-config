{
    programs = {
        eza.enable = true;
        fd.enable = true;
        fzf = {
            enable = true;
            defaultCommand = "fd --type f --hidden --exclude .git";
            fileWidget.options = [
                "--walker-skip .git,node_modules,.direnv,result,.cache,.venv,__pycache__,.pytest_cache,.mypy_cache,.ruff_cache,target,build,dist"
            ];
        };
        ripgrep.enable = true;
        zoxide = {
            enable = true;
            options = [
                "--cmd"
                "cd"
            ];
        };
    };
}
