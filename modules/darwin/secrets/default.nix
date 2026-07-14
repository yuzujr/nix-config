{
    pkgs,
    sops-nix,
    secrets,
    vars,
    ...
}:
let
    secretLib = import ../../../lib/secrets.nix { inherit secrets vars; };
    inherit (secretLib) mkSecret userSecret;
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

        secrets = {
            "ssh/github" = mkSecret "ssh.yaml" "github" userSecret;
            "ssh/gongfeng" = mkSecret "ssh.yaml" "gongfeng" userSecret;
            "ssh/dtm" = mkSecret "ssh.yaml" "dtm" userSecret;
            "ssh/vps" = mkSecret "ssh.yaml" "vps" userSecret;

            "network/drcom-jlu" = mkSecret "network.yaml" "drcom-jlu" userSecret;

            "nix/user-conf" = mkSecret "nix.yaml" "user-conf" userSecret;
        };
    };
}
