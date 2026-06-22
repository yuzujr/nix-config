{ ... }:
{
    programs.git = {
        # macOS uses system git instead of Nix-managed git to avoid duplicated packaging
        package = null;

        settings = {
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
