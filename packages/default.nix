{ pkgs, ... }:
{
    gold-price = pkgs.callPackage ./gold-price { };
    wechat = pkgs.callPackage ./wechat { };
}
