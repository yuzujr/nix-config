{
    coreutils,
    curl,
    gawk,
    jq,
    libnotify,
    symlinkJoin,
    systemd,
    writeShellApplication,
}:
let
    mkTool =
        name: dependencies:
        writeShellApplication {
            inherit name;
            runtimeInputs = [
                coreutils
                gawk
            ]
            ++ dependencies;
            text = builtins.readFile ../../dotfiles/local/bin/${name};
        };
in
symlinkJoin {
    name = "gold-price";
    paths = [
        (mkTool "gold-price-watch" [
            curl
            jq
            libnotify
        ])
        (mkTool "gold-price-history-daily" [
            curl
            jq
        ])
        (mkTool "gold-price-health" [ systemd ])
    ];
}
