{
    config,
    inputs,
    lib,
    pkgs,
    vars,
    ...
}:
{
    imports = [ inputs.noctalia-greeter.nixosModules.default ];

    programs.noctalia-greeter = {
        enable = true;
        package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
        passwordless-sync-users = [ vars.username ];

        settings = {
            session.default = "Niri";
            user.default = vars.username;

            appearance = {
                scheme = "Synced";
                password_style = "default";
                hide_logo = true;
                power_buttons_position = "bottom-right";
                scheme_selector_position = "top-right";
            };

            output = {
                name = "eDP-1";
                scale = 2;
            };

            idle.timeout = 300;

            cursor = {
                theme = "BreezeX-RosePine-Linux";
                size = 20;
                path = "${pkgs.rose-pine-cursor}/share/icons";
            };

            keyboard.layout = "us";
        };
    };

    services.greetd = {
        enable = true;
        settings = {
            terminal.vt = 1;

            initial_session = {
                command = lib.getExe' config.programs.niri.package "niri-session";
                user = vars.username;
            };
        };
    };
}
