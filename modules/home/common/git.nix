{
    config,
    ...
}:
{
    programs.git = {
        enable = true;

        settings = {
            core = {
                quotepath = false;
            };
            init.defaultBranch = "main";
        };
    };
}
