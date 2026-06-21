{
    pkgs,
    lib,
    # Linux-only custom packages; use ? null so Darwin doesn't need to pass them
    coomerPkg ? null,
    drcomClientPkg ? null,
    ani2xcursorPkg ? null,
    noctaliaPkg ? null,
    ...
}:
let
    # Custom packages only built for Linux
    linuxCustom = lib.optionals pkgs.stdenv.isLinux (
        lib.optional (coomerPkg != null) coomerPkg
        ++ lib.optional (drcomClientPkg != null) drcomClientPkg
        ++ lib.optional (ani2xcursorPkg != null) ani2xcursorPkg
        ++ lib.optional (noctaliaPkg != null) noctaliaPkg
    );

    # Development tools installed via Nix on Linux;
    # on macOS these come from Homebrew casks/brews (see modules/darwin/homebrew.nix)
    linuxDevelopment = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
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
    ]);

    # Linux-only desktop apps; macOS equivalents are in Homebrew casks
    linuxDesktop = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
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
    ]);

    linuxMedia = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
        ffmpeg
        gpu-screen-recorder
        (obs-studio.override { browserSupport = false; })
        playerctl
    ]);

    linuxTheming = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
        adw-gtk3
        bibata-cursors
        rose-pine-cursor
        kdePackages.qt6ct
        nwg-look
        tela-circle-icon-theme
    ]);

    # Terminal tools available on both platforms via Nix
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

    linuxUtilities = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
        appimage-run
        cliphist
        file
        poppler-utils
        typst
        unrar
        wev
        wl-clipboard
        wl-clip-persist
    ]);

    darwinUtilities = lib.optionals pkgs.stdenv.isDarwin (with pkgs; [
        typst
    ]);

    linuxWindows = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
        wine-staging
        winetricks
    ]);
in
{
    home.packages =
        linuxCustom
        ++ linuxDevelopment
        ++ linuxDesktop
        ++ linuxMedia
        ++ linuxTheming
        ++ terminal
        ++ linuxUtilities
        ++ darwinUtilities
        ++ linuxWindows;
}
