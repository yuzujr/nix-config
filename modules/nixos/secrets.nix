{
    inputs,
    vars,
    secretsLib,
    ...
}:
let
    inherit (secretsLib) mkSecret rootSecret;
in
{
    imports = [
        inputs.sops-nix.nixosModules.sops
        ../shared/secrets.nix
    ];

    sops.secrets = {
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
