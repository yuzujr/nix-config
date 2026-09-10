{ vars, ... }:
{
    programs.git = {
        # macOS uses system git instead of Nix-managed git to avoid duplicated packaging
        package = null;
        lfs.enable = true;

        settings = {
            user = {
                name = vars.git.work.name;
                email = vars.git.work.email;
            };
        };
    };
}
