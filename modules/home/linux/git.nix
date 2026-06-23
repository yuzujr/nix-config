{ vars, ... }:
{
    programs.git = {
        settings = {
            user = {
                name = vars.git.name;
                email = vars.git.email;
            };
        };
    };

    programs.delta = {
        enable = true;
        enableGitIntegration = true;
    };
}
