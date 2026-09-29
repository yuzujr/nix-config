{
    stdenv,
    lib,
    fetchurl,
    dpkg,
    buildFHSEnv,
    alsa-lib,
    at-spi2-atk,
    atk,
    atkmm,
    cairo,
    cairomm,
    cups,
    dbus,
    expat,
    fontconfig,
    freetype,
    gdk-pixbuf,
    glib,
    glibmm,
    gtk2,
    gtk3,
    libappindicator-gtk3,
    libdbusmenu,
    libdrm,
    libgbm,
    gtkmm2,
    libnotify,
    libpulseaudio,
    libudev0-shim,
    libx11,
    libxcomposite,
    libxdamage,
    libxext,
    libxfixes,
    libxrandr,
    libxcb,
    libxt,
    libxtst,
    libxkbcommon,
    mesa,
    nspr,
    nss,
    pango,
    pangomm,
    libsigcxx,
    zlib,
}:
let
    version = "8.7.0";

    src = fetchurl {
        url = "https://wppkg.baidupcs.com/issue/netdisk/Linuxguanjia/${version}/baidunetdisk_${version}_amd64.deb";
        hash = "sha256-7HHCrRFRYJ/Q2LhtlRhMC0V9bbWqGIYeCxX8I8z+Afc=";
    };

    dist = stdenv.mkDerivation {
        pname = "baidunetdisk-dist";
        inherit version src;
        dontFixup = true;
        nativeBuildInputs = [ dpkg ];

        unpackPhase = ''
            dpkg -x $src .
        '';

        installPhase = ''
            mkdir -p $out/opt
            cp -r opt/baidunetdisk $out/opt/
        '';
    };

    runtimeLibraries = [
        alsa-lib
        at-spi2-atk
        atk
        atkmm
        cairo
        cairomm
        cups
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        glibmm
        gtk2
        gtk3
        gtkmm2
        libappindicator-gtk3
        libdbusmenu
        libdrm
        libgbm
        libnotify
        libpulseaudio
        libudev0-shim
        libxkbcommon
        mesa
        nspr
        nss
        pango
        pangomm
        libsigcxx
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
        libxcb
        libxt
        libxtst
        zlib
    ];
in
buildFHSEnv {
    name = "baidunetdisk";
    targetPkgs = _: runtimeLibraries;
    runScript = "${dist}/opt/baidunetdisk/baidunetdisk --no-sandbox";

    extraInstallCommands = ''
        mkdir -p $out/share/applications
        install -Dm644 ${dist}/opt/baidunetdisk/baidunetdisk.desktop \
            $out/share/applications/baidunetdisk.desktop
        substituteInPlace $out/share/applications/baidunetdisk.desktop \
            --replace-fail /opt/baidunetdisk/baidunetdisk $out/bin/baidunetdisk
        mkdir -p $out/share/icons/hicolor/scalable/apps
        install -Dm644 ${dist}/opt/baidunetdisk/baidunetdisk.svg \
            $out/share/icons/hicolor/scalable/apps/baidunetdisk.svg
    '';

    meta = {
        description = "Baidu Netdisk desktop client";
        homepage = "https://pan.baidu.com/";
        license = lib.licenses.unfreeRedistributable;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        mainProgram = "baidunetdisk";
        platforms = [ "x86_64-linux" ];
    };
}
