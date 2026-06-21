{
    config,
    pkgs,
    lib,
    vars,
    osConfig ? { },
    ...
}:
let
    repoRoot = if pkgs.stdenv.isDarwin then "${config.home.homeDirectory}/Documents/nixos-config" else vars.repoRoot;
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    hasSecret =
        name:
        lib.hasAttrByPath [
            "sops"
            "secrets"
            name
        ] osConfig;

    # 通用的跨平台配置
    commonConfigFiles = {
        "fish".source = mkSymlink "${repoRoot}/dotfiles/fish";
        "nvim".source = mkSymlink "${repoRoot}/dotfiles/nvim";
        "emacs".source = mkSymlink "${repoRoot}/dotfiles/emacs";
        "starship.toml".source = mkSymlink "${repoRoot}/dotfiles/starship.toml";
        "fastfetch".source = mkSymlink "${repoRoot}/dotfiles/fastfetch";
        "btop".source = mkSymlink "${repoRoot}/dotfiles/btop";
    } // (if pkgs.stdenv.isDarwin then {
        "kitty".source = mkSymlink "${repoRoot}/dotfiles/kitty-darwin";
    } else {
        "kitty".source = mkSymlink "${repoRoot}/dotfiles/kitty";
    });

    # Linux (NixOS) 专有配置
    linuxConfigFiles = {
        "niri".source = mkSymlink "${repoRoot}/dotfiles/niri/";
        "noctalia".source = mkSymlink "${repoRoot}/dotfiles/noctalia";
        "cava".source = mkSymlink "${repoRoot}/dotfiles/cava";
        "chrome-flags.conf".source = mkSymlink "${repoRoot}/dotfiles/chrome-flags.conf";
        "feh".source = mkSymlink "${repoRoot}/dotfiles/feh";
        "gold-price/gold-price-watch.conf".source =
            mkSymlink "${repoRoot}/dotfiles/gold-price/gold-price-watch.conf";
        "kdeglobals".source = mkSymlink "${repoRoot}/dotfiles/kdeglobals";
        "kcminputrc".source = mkSymlink "${repoRoot}/dotfiles/kcminputrc";
        "kxkbrc".source = mkSymlink "${repoRoot}/dotfiles/kxkbrc";
        "nwg-look".source = mkSymlink "${repoRoot}/dotfiles/nwg-look";
        "plasma-workspace/env/10-unset-qt-platformtheme.sh".source =
            mkSymlink "${repoRoot}/dotfiles/plasma-workspace/env/10-unset-qt-platformtheme.sh";
        "qt6ct".source = mkSymlink "${repoRoot}/dotfiles/qt6ct";
        "zathura".source = mkSymlink "${repoRoot}/dotfiles/zathura";

        "fcitx5/config".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/config";
        "fcitx5/profile".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/profile";
        "fcitx5/conf/clipboard.conf".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/clipboard.conf";
        "fcitx5/conf/quickphrase.conf".source =
            mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/quickphrase.conf";
        "fcitx5/conf/classicui.conf".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/classicui.conf";
        "fcitx5/conf/notifications.conf".source =
            mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/notifications.conf";
        "fcitx5/conf/rime.conf".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/rime.conf";
    };
in
{
    home.file = {
        ".local/bin".source = mkSymlink "${repoRoot}/dotfiles/local/bin";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
        "Library/Rime/squirrel.custom.yaml".source = mkSymlink "${repoRoot}/dotfiles/squirrel/squirrel.custom.yaml";
        "Library/Rime/default.custom.yaml".source = mkSymlink "${repoRoot}/dotfiles/squirrel/default.custom.yaml";
        "Library/Rime/double_pinyin_flypy.custom.yaml".source = mkSymlink "${repoRoot}/dotfiles/squirrel/double_pinyin_flypy.custom.yaml";
    };

    xdg.configFile = commonConfigFiles
        // lib.optionalAttrs pkgs.stdenv.isLinux linuxConfigFiles
        // lib.optionalAttrs (hasSecret "apps/gold-price-history") {
            "gold-price/gold-price-history.conf" = {
                source = mkSymlink osConfig.sops.secrets."apps/gold-price-history".path;
            };
        }
        // lib.optionalAttrs (hasSecret "nix/user-conf") {
            "nix/nix.conf" = {
                source = mkSymlink osConfig.sops.secrets."nix/user-conf".path;
            };
        }
        // lib.optionalAttrs (hasSecret "network/drcom-jlu") {
            "drcom-client-cpp/drcom-jlu.conf" = {
                source = mkSymlink osConfig.sops.secrets."network/drcom-jlu".path;
            };
        };

    xdg.dataFile = lib.optionalAttrs pkgs.stdenv.isLinux {
        "konsole".source = mkSymlink "${repoRoot}/dotfiles/konsole";
        "fcitx5/rime".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/rime";
    };

    home.activation.niriProfileLinks = lib.mkIf pkgs.stdenv.isLinux (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
    '');
}
