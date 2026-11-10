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
        # codex # Broken in nixpkgs 0.167.0
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
        # splayer-next # Broken by nixpkgs cargoSetupHook AWS_LC_SYS_USE_SYSTEM=1
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
