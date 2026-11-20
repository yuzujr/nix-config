# Noctalia-owned runtime state.
{
    lib,
    dot,
    pkgs,
    inputs,
    ...
}:
{
    xdg = {
        configFile.noctalia = dot "noctalia";
        stateFile."noctalia/plugins/data/kenn/keybind-cheatsheet/preferences.json" =
            dot "niri/cheatsheet-preferences.json";
    };

    home = {
        packages = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

        activation = {
            kdeTextEditorTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
                for config in kwriterc katerc; do
                    run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
                        --file "$config" \
                        --group "KTextEditor Renderer" \
                        --key "Auto Color Theme Selection" \
                        --type bool false
                    run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
                        --file "$config" \
                        --group "KTextEditor Renderer" \
                        --key "Color Theme" Noctalia
                done
            '';
        };
    };
}
