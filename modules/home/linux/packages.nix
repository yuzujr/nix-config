{
    inputs,
    pkgs,
    ...
}:
let
    system = pkgs.stdenv.hostPlatform.system;

    terminal = with pkgs; [
        btop
        cmatrix
        csvlens
        duf
        dust
        eza
        fastfetch
        fd
        fzf
        nyancat
        ripgrep
        starship
        yazi
        zoxide
    ];

    custom = [
        inputs.coomer.packages.${system}.default
        inputs.drcom-client-cpp.packages.${system}.default
        inputs.ani2xcursor.packages.${system}.default
        inputs.noctalia.packages.${system}.default
    ];

    development = with pkgs; [
        binutils
        cc-switch
        codex
        antigravity-cli
        claude-code
        gcc
        gnumake
        neovim
        nodejs
        python3
        vscode
    ];

    desktop = with pkgs; [
        bluetui
        feh
        google-chrome
        gparted
        kitty
        libnotify
        libreoffice-fresh
        networkmanagerapplet
        pavucontrol
        qq
        seahorse
        splayer
        sunshine
        typora
        wechat
        xwayland-satellite
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
        rose-pine-cursor
        kdePackages.qt6ct
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
        wl-clip-persist
    ];

    windows = with pkgs; [
        wine-staging
        winetricks
    ];
in
{
    home.packages =
        terminal ++ custom ++ development ++ desktop ++ media ++ theming ++ utilities ++ windows;
}
