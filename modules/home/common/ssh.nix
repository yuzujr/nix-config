{ secretPath, ... }:
{
    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
            "github.com" = {
                User = "git";
                IdentityFile = secretPath "ssh/github";
                IdentitiesOnly = true;
            };
            "aur.archlinux.org" = {
                User = "aur";
                IdentityFile = secretPath "ssh/aur";
                IdentitiesOnly = true;
            };
        };
    };

    home.file.".ssh/config".force = true;
}
