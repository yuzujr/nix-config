{
    pkgs,
    sops-nix,
    secrets,
    vars,
    ...
}:
let
    secretLib = import ../../../lib/secrets.nix { inherit secrets vars; };
    inherit (secretLib) mkSecret userSecret rootSecret;
in
{
    imports = [
        sops-nix.nixosModules.sops
    ];

    environment.systemPackages = [
        pkgs.sops
    ];

    sops = {
        age.keyFile = "${vars.homeDirectory}/.config/sops/age/keys.txt";

        secrets = secretLib.common // {
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
    };
}
