{ vars, ... }:
{
    programs.git = {
        # macOS uses system git instead of Nix-managed git to avoid duplicated packaging
        package = null;
        lfs.enable = true;

        settings = {
            user = {
                name = vars.gitTencent.name;
                email = vars.gitTencent.email;
            };
            interactive.diffFilter = "delta --color-only";
            pager = {
                blame = "delta";
                diff = "delta";
                log = "delta";
                show = "delta";
            };
        };
    };
}
