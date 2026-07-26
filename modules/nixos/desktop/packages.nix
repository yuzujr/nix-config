{ pkgs, ... }:
let
    audio = with pkgs; [
        alsa-firmware
        alsa-ucm-conf
    ];

    hardware = with pkgs; [
        brightnessctl
        dconf
        ddcutil
        pciutils
    ];

    storage = with pkgs; [
        efibootmgr
        exfatprogs
        parted
    ];

    network = with pkgs; [
        curl
        inetutils
        openssh
        wget
    ];

    nixTools = with pkgs; [
        nh
        nix-tree
    ];

    utility = with pkgs; [
        git
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
