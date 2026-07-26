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
            # delta comes from homebrew (git-delta); enabling programs.delta here
            # would install a second (nix) copy, so its git integration is
            # replicated by hand. Keep in sync with programs.delta in
            # ../linux/git.nix.
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
