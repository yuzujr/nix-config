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
        duf
        dust
        nyancat
    ];

    custom = [
        inputs.coomer.packages.${system}.default
        inputs.drcom-client-cpp.packages.${system}.default
        inputs.ani2xcursor.packages.${system}.default
        inputs.termway.packages.${system}.default
    ];

    development = with pkgs; [
        binutils
        cc-switch
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
        google-chrome
        localPackages.baidunetdisk
        gparted
        kdePackages.ark
        kdePackages.dolphin
        kdePackages.kate
        libnotify
        networkmanagerapplet
        pavucontrol
        qq
        seahorse
        splayer-next
        typora
        localPackages.wechat
        zathura
        zathuraPkgs.zathura_pdf_poppler
    ];

    media = with pkgs; [
        ffmpeg
        gpu-screen-recorder
        (obs-studio.override { browserSupport = false; })
        playerctl
    ];

    theming = with pkgs; [
        adw-gtk3
        bibata-cursors
        kdePackages.breeze
        kdePackages.qt6ct
        rose-pine-cursor
        nwg-look
        tela-circle-icon-theme
    ];

    utilities = with pkgs; [
        appimage-run
        cliphist
        file
        poppler-utils
        typst
        unrar
        wev
        wl-clipboard
    ];

in
{
    home.packages = terminal ++ custom ++ development ++ desktop ++ media ++ theming ++ utilities;
}
