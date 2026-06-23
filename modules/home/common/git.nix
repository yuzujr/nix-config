{
    config,
    ...
}:
{
    programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
            core = {
                hooksPath = "${config.home.homeDirectory}/.git-hooks";
                quotepath = false;
            };
            init.defaultBranch = "main";
        };
    };
}
