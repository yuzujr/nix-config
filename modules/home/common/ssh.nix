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

            "vps" = {
                User = "yuzujr";
                HostName = "106.53.172.179";
                IdentityFile = secretPath "ssh/vps";
                IdentitiesOnly = true;
            };
        };
    };

    home.file.".ssh/config".force = true;
}
