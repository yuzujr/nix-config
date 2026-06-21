{ secrets, vars }:
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

    rootSecret = {
        mode = "0400";
        owner = "root";
    };
in
{
    inherit mkSecret userSecret rootSecret;

    common = {
        "ssh/github" = mkSecret "ssh.yaml" "github" userSecret;
        "ssh/gitee" = mkSecret "ssh.yaml" "gitee" userSecret;
        "ssh/vm" = mkSecret "ssh.yaml" "vm" userSecret;
        "ssh/aur" = mkSecret "ssh.yaml" "aur" userSecret;

        "network/drcom-jlu" = mkSecret "network.yaml" "drcom-jlu" userSecret;

        "nix/user-conf" = mkSecret "nix.yaml" "user-conf" userSecret;
    };
}
