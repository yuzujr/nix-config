{
    programs.git = {
        enable = true;
        settings = {
            core.quotepath = false;
            init.defaultBranch = "main";
        };
    };

    programs.delta = {
        enable = true;
        enableGitIntegration = true;
    };

    programs.lazygit = {
        enable = true;
        settings = {
            git.diffRenderers = [
                {
                    type = "stdinFilter";
                    name = "delta";
                    colorArg = "always";
                    command = "delta --paging=never";
                }
            ];
            promptToReturnFromSubprocess = false;
        };
    };
}
