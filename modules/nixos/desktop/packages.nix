{ pkgs, ... }:
let
    audio = with pkgs; [
        alsa-firmware
        alsa-ucm-conf
    ];

    hardware = with pkgs; [
        brightnessctl
        ddcutil
        pciutils
    ];

    storage = with pkgs; [
        efibootmgr
        exfatprogs
        parted
    ];

    network = with pkgs; [
        inetutils
        wget
    ];

    nixTools = with pkgs; [
        nh
        nix-tree
    ];

    utility = with pkgs; [
        glib
        jq
        tree
        unzip
        vim
        zip
    ];
in
{
    environment.systemPackages = audio ++ hardware ++ storage ++ network ++ nixTools ++ utility;
}
