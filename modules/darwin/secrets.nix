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
        "ssh/gongfeng" = mkSecret "ssh.yaml" "gongfeng" userSecret;
        "ssh/dtm" = mkSecret "ssh.yaml" "dtm" userSecret;
        "ssh/home" = mkSecret "ssh.yaml" "home" userSecret;
    };
}
