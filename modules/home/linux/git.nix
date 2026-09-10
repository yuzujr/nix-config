{ vars, ... }:
{
    programs.git = {
        settings = {
            user = {
                name = vars.git.personal.name;
                email = vars.git.personal.email;
            };
        };
    };
}
