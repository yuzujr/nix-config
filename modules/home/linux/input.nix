{ lib, dot, ... }:
{
    xdg = {
        configFile = lib.genAttrs [
            "fcitx5/config"
            "fcitx5/profile"
            "fcitx5/conf/clipboard.conf"
            "fcitx5/conf/quickphrase.conf"
            "fcitx5/conf/classicui.conf"
            "fcitx5/conf/notifications.conf"
            "fcitx5/conf/rime.conf"
        ] dot;
        dataFile."fcitx5/rime" = dot "fcitx5/rime";
    };
}
