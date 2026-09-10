# Noctalia-owned runtime state.
{
    config,
    lib,
    vars,
    ...
}:
{
    # These two files are intentionally mutable: Noctalia adds/removes its
    # integration lines when templates are toggled.
    home.file."${config.home.homeDirectory}/.config/kitty/kitty.conf".force = lib.mkForce true;
    home.file."${config.home.homeDirectory}/.config/btop/btop.conf".force = lib.mkForce true;

    home.activation.noctaliaWritableConfigs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        detach_store_path() {
          local path="$1" target resolved tmp
          [ -L "$path" ] || return 0

          target="$(readlink "$path")"
          case "$target" in
            /nix/store/*)
              resolved="$(readlink -f "$path")"
              if [ -d "$path" ]; then
                tmp="$(mktemp -d "''${path}.tmp.XXXXXX")"
                run cp -a -- "$resolved/." "$tmp/"
              else
                tmp="$(mktemp "''${path}.tmp.XXXXXX")"
                run cp -L -- "$path" "$tmp"
              fi
              run rm -- "$path"
              run mv -- "$tmp" "$path"
              ;;
          esac
        }

        detach_store_path "$HOME/.config/kitty"
        detach_store_path "$HOME/.config/btop"
        detach_store_path "$HOME/.config/kitty/kitty.conf"
        detach_store_path "$HOME/.config/btop/btop.conf"
        run mkdir -p $VERBOSE_ARG \
            "$HOME/.config/kitty/themes" \
            "$HOME/.config/btop/themes"
    '';

    home.activation.noctaliaKeybindCheatsheet = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
        preferences_dir="$state_home/noctalia/plugins/data/kenn/keybind-cheatsheet"
        run mkdir -p $VERBOSE_ARG "$preferences_dir"
        run install $VERBOSE_ARG -m 0644 \
            "${vars.repoRoot}/dotfiles/niri/cheatsheet-preferences.json" \
            "$preferences_dir/preferences.json"
    '';
}
