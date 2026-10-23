# Work hosts and the way back home; their secrets are only declared on darwin.
{ secretPath, ... }:
{
    programs.ssh.settings = {
        "nixos" = {
            HostName = "laptop-nixos";
            User = "yuzujr";
            IdentityFile = secretPath "ssh/nixos";
            IdentitiesOnly = true;
        };
    };
}
