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
                "https://cache.nixos-cuda.org"
                "https://nix-community.cachix.org"
                "https://comfyui.cachix.org"
            ];
            extra-trusted-public-keys = [
                "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
                "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
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
