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

        "network/drcom-jlu" = mkSecret "network.yaml" "drcom-jlu" userSecret;

        "apps/gold-price-history" = mkSecret "apps.yaml" "gold-price-history" userSecret;

        # The whole NixLoom runtime config (credentials included) is encrypted
        # and decrypted directly into the config path the service reads.
        "nixloom/config" = mkSecret "nixloom.yaml" "config" (
            userSecret
            // {
                path = "${vars.homeDirectory}/.config/nixloom/config.yaml";
                mode = "0600";
            }
        );

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
