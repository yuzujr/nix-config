{ vars, secretsLib, ... }:
{
    sops.secrets."nixloom/config" = secretsLib.mkSecret "nixloom.yaml" "config" (
        secretsLib.userSecret
        // {
            path = "${vars.homeDirectory}/.config/nixloom/config.yaml";
            mode = "0600";
        }
    );

    home-manager.users.${vars.username}.imports = [ ../../home/linux/services/nixloom.nix ];
}
