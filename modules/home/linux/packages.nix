# User-level Linux packages: everyday CLI tools, desktop apps, theming, and development tools.
{
    inputs,
    pkgs,
    localPackages,
    ...
}:
let
    system = pkgs.stdenv.hostPlatform.system;

    terminal = with pkgs; [
        cmatrix
        csvlens
        jq
        nix-tree
        nyancat
        tree
    ];

    custom = [
        inputs.coomer.packages.${system}.default
        inputs.drcom-client-cpp.packages.${system}.default
        inputs.ani2xcursor.packages.${system}.default
        inputs.termway.packages.${system}.default
    ];

    development = with pkgs; [
        binutils
        codex
        antigravity-cli
        claude-code
        gcc
        gnumake
        nodejs
        python3
    ];

    desktop = with pkgs; [
        bluetui
        feh
        fuzzel
        google-chrome
        baidupcs-go
        gparted
        kdePackages.ark
        kdePackages.dolphin
        kdePackages.kate
        libnotify
        libreoffice
        networkmanagerapplet
        pavucontrol
        qq
        seahorse
        splayer-next
        typora
        localPackages.wechat
        zathura
    ];

    media = with pkgs; [
        ffmpeg
        gpu-screen-recorder
        (obs-studio.override { browserSupport = false; })
        playerctl
    ];

    theming = with pkgs; [
        adw-gtk3
        kdePackages.breeze
        kdePackages.qt6ct
        rose-pine-cursor
        nwg-look
        tela-circle-icon-theme
    ];

    utilities = with pkgs; [
        appimage-run
        file
        glib
        poppler-utils
        unrar
        unzip
        wl-clipboard
        zip
    ];

in
{
    home.packages = terminal ++ custom ++ development ++ desktop ++ media ++ theming ++ utilities;
}
