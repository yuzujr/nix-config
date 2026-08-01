{
    osConfig ? { },
    ...
}:
let
    # Resolve identity files from the OS sops declarations, falling back to the
    # sops-nix default layout when evaluated without an OS config.
    secretPath = name: osConfig.sops.secrets.${name}.path or "/run/secrets/${name}";
in
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
