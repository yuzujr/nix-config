{
    appimageTools,
    fetchurl,
    lib,
    makeWrapper,
    scaleFactor ? "1.5",
}:
let
    pname = "wechat";
    version = "4.1.1.8";

    src = fetchurl {
        url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
        hash = "sha256-RX26ArkbAxzdRBLu4HT7v/udnQax5Q/Bgi00hw4RSZA=";
    };

    appimageContents = appimageTools.extract {
        inherit pname version src;
        postExtract = ''
            patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/wechat/wechat
        '';
    };
in
appimageTools.wrapAppImage {
    inherit pname version;

    src = appimageContents;

    extraInstallCommands = ''
        mkdir -p $out/share/applications
        cp ${appimageContents}/wechat.desktop $out/share/applications/
        mkdir -p $out/share/icons/hicolor/256x256/apps
        cp ${appimageContents}/wechat.png $out/share/icons/hicolor/256x256/apps/

        substituteInPlace $out/share/applications/wechat.desktop --replace-fail AppRun wechat

        # WeChat 4.1.1.8 still creates X11/XCB windows.  When WAYLAND_DISPLAY is
        # visible it nevertheless tries the Wayland input-method path, which is
        # broken under niri/xwayland-satellite.  Keep this application entirely
        # on XWayland so Fcitx can use XIM, and set its scale explicitly because
        # the proprietary UI does not consume xwayland-satellite's XSettings.
        wechatRunner="$(readlink -f $out/bin/wechat)"
        rm $out/bin/wechat
        source ${makeWrapper}/nix-support/setup-hook
        makeWrapper "$wechatRunner" $out/bin/wechat \
            --unset WAYLAND_DISPLAY \
            --set XMODIFIERS @im=fcitx \
            --set GTK_IM_MODULE fcitx \
            --set QT_IM_MODULE fcitx \
            --set QT_QPA_PLATFORM xcb \
            --set QT_AUTO_SCREEN_SCALE_FACTOR 0 \
            --set QT_ENABLE_HIGHDPI_SCALING 0 \
            --set QT_SCALE_FACTOR ${lib.escapeShellArg scaleFactor}
    '';

    meta = {
        description = "Messaging and calling app";
        homepage = "https://www.wechat.com/en/";
        downloadPage = "https://linux.weixin.qq.com/en";
        license = lib.licenses.unfree;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        mainProgram = "wechat";
        platforms = [ "x86_64-linux" ];
    };
}
