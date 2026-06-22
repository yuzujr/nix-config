{
    lib,
    pkgs,
    # Linux-only custom packages; use ? null so Darwin doesn't need to pass them.
    coomerPkg ? null,
    drcomClientPkg ? null,
    ani2xcursorPkg ? null,
    noctaliaPkg ? null,
    ...
}:
let
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

    custom =
        lib.optional (coomerPkg != null) coomerPkg
        ++ lib.optional (drcomClientPkg != null) drcomClientPkg
        ++ lib.optional (ani2xcursorPkg != null) ani2xcursorPkg
        ++ lib.optional (noctaliaPkg != null) noctaliaPkg;

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
