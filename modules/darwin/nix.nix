{
    # Do not manage nix daemon as we are using Determinate Systems installer.
    nix.enable = false;

    # Determinate Nix includes this user-managed file from /etc/nix/nix.conf.
    environment.etc."nix/nix.custom.conf" = {
        text = ''
            extra-substituters = https://mirror.sjtu.edu.cn/nix-channels/store?priority=10
            extra-trusted-substituters = https://mirror.sjtu.edu.cn/nix-channels/store
        '';

        # Permit nix-darwin to take over Determinate's current empty custom file.
        knownSha256Hashes = [
            "3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa"
        ];
    };
}
