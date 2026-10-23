{
    inputs,
    secretsLib,
    ...
}:
let
    inherit (secretsLib) mkSecret userSecret;
in
{
    imports = [
        inputs.sops-nix.darwinModules.sops
        ../shared/secrets.nix
    ];

    sops.secrets = {
        "ssh/nixos" = mkSecret "ssh.yaml" "home" userSecret;
    };
}
