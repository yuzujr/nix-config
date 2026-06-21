{
    pkgs,
    sops-nix,
    secrets,
    vars,
    ...
}:
let
    secretLib = import ../../../lib/secrets.nix { inherit secrets vars; };
in
{
    imports = [
        sops-nix.darwinModules.sops
    ];

    environment.systemPackages = [
        pkgs.sops
    ];

    sops = {
        age.keyFile = "${vars.homeDirectory}/.config/sops/age/keys.txt";

        secrets = secretLib.common;
    };
}
