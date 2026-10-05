{
    dot,
    lib,
    pkgs,
    ...
}:
{
    home = {
        packages = [ pkgs.xwayland-satellite ];
        activation = {
            # These mutable profile links live in the out-of-store Niri directory and
            # are ignored by Git.
            niriProfileLinks = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
                profiles_dir="$HOME/.config/niri/profiles"
                run mkdir -p $VERBOSE_ARG "$profiles_dir"

                create_if_missing() {
                  local target="$1"
                  local link="$2"
                  if [ -e "$link" ] || [ -L "$link" ]; then
                    return 0
                  fi
                  run ln -s $VERBOSE_ARG "$target" "$link"
                }

                create_if_missing "normal/config.kdl" "$profiles_dir/current-config.kdl"
                create_if_missing "normal/outputs.kdl" "$profiles_dir/current-outputs.kdl"
                create_if_missing "normal/startup.kdl" "$profiles_dir/current-startup.kdl"
            '';
        };
    };

    xdg.configFile.niri = dot "niri";
}
