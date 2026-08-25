{
    appimageTools,
    fetchurl,
    lib,
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
