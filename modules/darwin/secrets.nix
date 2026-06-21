{
    pkgs,
    sops-nix,
    secrets,
    vars,
    ...
}:
let
    mkSecret =
        file: key: attrs:
        {
            sopsFile = "${secrets}/secrets/${file}";
            inherit key;
        }
        // attrs;

    userSecret = {
        mode = "0400";
        owner = vars.username;
    };
in
{
    imports = [
        sops-nix.darwinModules.sops
    ];

    environment.systemPackages = [
        pkgs.sops
    ];

    sops = {
        age.keyFile = "/Users/${vars.username}/.config/sops/age/keys.txt";

        secrets = {
            "ssh/github" = mkSecret "ssh.yaml" "github" userSecret;
            "ssh/gitee"  = mkSecret "ssh.yaml" "gitee"  userSecret;
            "ssh/vm"     = mkSecret "ssh.yaml" "vm"     userSecret;
            "ssh/aur"    = mkSecret "ssh.yaml" "aur"    userSecret;

            "network/drcom-jlu" = mkSecret "network.yaml" "drcom-jlu" userSecret;

            "nix/user-conf" = mkSecret "nix.yaml" "user-conf" userSecret;
        };
    };
}
