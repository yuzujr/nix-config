{
    config,
    vars,
    ...
}:
{
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = vars.git.name;
                email = vars.git.email;
            };
            core = {
                hooksPath = "${config.home.homeDirectory}/.git-hooks";
                quotepath = false;
            };
            init.defaultBranch = "main";
        };
    };
}
