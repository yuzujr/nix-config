{
    nix = {
        settings = {
            experimental-features = [
                "nix-command"
                "flakes"
            ];
            substituters = [
                "https://cache.nixos.org?priority=10"
                "https://unicom.mirrors.ustc.edu.cn/nix-channels/store?priority=30"
                "https://noctalia.cachix.org"
            ];
            extra-trusted-public-keys = [
                "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            ];
        };

        channel.enable = false;

        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
        };

        optimise.automatic = true;
    };

    boot.tmp.cleanOnBoot = true;
}
