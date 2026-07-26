{
    inputs,
    vars,
    secretsLib,
    ...
}:
let
    inherit (secretsLib) mkSecret userSecret rootSecret;
in
{
    imports = [
        inputs.sops-nix.nixosModules.sops
        ../shared/secrets.nix
    ];

    sops.secrets = {
        "network/mihomo" = mkSecret "network.yaml" "mihomo" (
            rootSecret
            // {
                restartUnits = [ "mihomo.service" ];
            }
        );

        "apps/gold-price-history" = mkSecret "apps.yaml" "gold-price-history" userSecret;

        "users/${vars.username}/password-hash" = mkSecret "users.yaml" "${vars.username}-password-hash" (
            rootSecret
            // {
                neededForUsers = true;
            }
        );

        "users/root/password-hash" = mkSecret "users.yaml" "root-password-hash" (
            rootSecret
            // {
                neededForUsers = true;
            }
        );
    };
}
