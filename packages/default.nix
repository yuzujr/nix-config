{ inputs, pkgs }:
let
    legacyPkgs = import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
    };
in
{
    baidunetdisk = pkgs.callPackage ./baidunetdisk {
        inherit (legacyPkgs)
            atkmm
            cairomm
            glibmm
            gtk2
            gtkmm2
            libsigcxx
            pangomm
            ;
    };
    gold-price = pkgs.callPackage ./gold-price { };
    wechat = pkgs.callPackage ./wechat { };
}
