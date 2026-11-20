# System-level packages: hardware control/firmware, storage/EFI, and TTY/root rescue tools.
{ pkgs, ... }:
let
    hardware = with pkgs; [
        alsa-firmware
        brightnessctl
        ddcutil
        pciutils
    ];

    storage = with pkgs; [
        efibootmgr
        exfatprogs
        parted
    ];

    rescue = with pkgs; [
        inetutils
        vim
        wget
    ];
in
{
    environment.systemPackages = hardware ++ storage ++ rescue;
}
