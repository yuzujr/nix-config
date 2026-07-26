# Linux (NixOS)-only config files.
{
    config,
    lib,
    vars,
    osConfig ? { },
    ...
}:
let
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    dot = path: {
        source = mkSymlink "${vars.repoRoot}/dotfiles/${path}";
    };
    hasSecret =
        name:
        lib.hasAttrByPath [
            "sops"
            "secrets"
            name
        ] osConfig;
in
{
    xdg.configFile =
        lib.genAttrs [
            "kitty"
            "niri"
            "noctalia"
            "chrome-flags.conf"
            "feh"
            "gold-price/gold-price-watch.conf"
            "nwg-look"
            "plasma-workspace/env/10-unset-qt-platformtheme.sh"
            "qt6ct"
            "zathura"
            "fcitx5/config"
            "fcitx5/profile"
            "fcitx5/conf/clipboard.conf"
            "fcitx5/conf/quickphrase.conf"
            "fcitx5/conf/classicui.conf"
            "fcitx5/conf/notifications.conf"
            "fcitx5/conf/rime.conf"
        ] dot
        // lib.optionalAttrs (hasSecret "apps/gold-price-history") {
            "gold-price/gold-price-history.conf".source =
                mkSymlink
                    osConfig.sops.secrets."apps/gold-price-history".path;
        };

    xdg.dataFile = lib.genAttrs [
        "konsole"
        "fcitx5/rime"
    ] dot;

    home.activation.niriProfileLinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        profiles_dir="$HOME/.config/niri/profiles"
        mkdir -p "$profiles_dir"

        create_if_missing() {
          local target="$1"
          local link="$2"
          if [ -e "$link" ] || [ -L "$link" ]; then
            return 0
          fi
          ln -s "$target" "$link"
        }

        create_if_missing "normal/config.kdl" "$profiles_dir/current-config.kdl"
        create_if_missing "normal/outputs.kdl" "$profiles_dir/current-outputs.kdl"
        create_if_missing "normal/startup.kdl" "$profiles_dir/current-startup.kdl"
    '';
}
