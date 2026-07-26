# sops scaffolding and the secrets shared by both platforms. Platform-specific
# secrets (and the sops-nix module import) live in modules/{nixos,darwin}/secrets.nix.
{
    pkgs,
    vars,
    secretsLib,
    ...
}:
let
    inherit (secretsLib) mkSecret userSecret;
in
{
    environment.systemPackages = [
        pkgs.sops
    ];

    sops = {
        age.keyFile = "${vars.homeDirectory}/.config/sops/age/keys.txt";

        secrets = {
            "ssh/github" = mkSecret "ssh.yaml" "github" userSecret;

            "ssh/vps" = mkSecret "ssh.yaml" "vps" userSecret;

            "network/drcom-jlu" = mkSecret "network.yaml" "drcom-jlu" userSecret;

            "nix/user-conf" = mkSecret "nix.yaml" "user-conf" userSecret;
        };
    };
}
