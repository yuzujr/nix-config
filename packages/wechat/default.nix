{
    appimageTools,
    fetchurl,
    lib,
    makeWrapper,
    scaleFactor ? "1.5",
}:
let
    pname = "wechat";
    version = "4.1.13.23";

    src = fetchurl {
        url = "https://github.com/trouter-ai/wechat-linux-versions/releases/download/v4.1.13.23/WeChatLinux_4.1.13.23_x86_64.AppImage";
        hash = "sha256-T1StKQLs1vb9xWgLc1R/gNVCO/RwsBI3pXmi5bPK7us=";
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

        # WeChat 4.1.13.23 still creates X11/XCB windows.  When WAYLAND_DISPLAY is
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
