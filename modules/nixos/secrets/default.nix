{
    pkgs,
    inputs,
    vars,
    ...
}:
let
    secretLib = import ../../../lib/secrets.nix {
        inherit (inputs) secrets;
        inherit vars;
    };
    inherit (secretLib) mkSecret userSecret rootSecret;
in
{
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];

    environment.systemPackages = [
        pkgs.sops
    ];

    sops = {
        age.keyFile = "${vars.homeDirectory}/.config/sops/age/keys.txt";

        secrets = {
            # Common secrets
            "ssh/github" = mkSecret "ssh.yaml" "github" userSecret;

            "network/drcom-jlu" = mkSecret "network.yaml" "drcom-jlu" userSecret;

            "nix/user-conf" = mkSecret "nix.yaml" "user-conf" userSecret;

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
