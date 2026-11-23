{
    inputs,
    pkgs,
    vars,
    ...
}:
{
    home.packages = [
        inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.comma-with-db
        pkgs.duf
        pkgs.dust
    ];

    programs = {
        direnv = {
            enable = true;
            nix-direnv.enable = true;
        };
        eza = {
            enable = true;
            git = true;
            icons = "auto";
            extraOptions = [
                "--group-directories-first"
                "--classify=auto"
            ];
        };
        fd.enable = true;
        fzf = {
            enable = true;
            enableFishIntegration = false;
            defaultCommand = "fd --type f --hidden --exclude .git";
        };
        nh = {
            enable = true;
            flake = vars.repoRoot;
        };
        ripgrep.enable = true;
        yazi = {
            enable = true;
            enableFishIntegration = true;
        };
        zoxide = {
            enable = true;
            options = [
                "--cmd"
                "cd"
            ];
        };
    };
}
