{
    config,
    lib,
    pkgs,
    vars,
    ...
}:
let
    sessionsDir = "${config.services.displayManager.sessionData.desktops}/share";
in
{
    services.greetd = {
        enable = true;
        settings = {
            terminal.vt = 1;

            initial_session = {
                command = lib.getExe' config.programs.niri.package "niri-session";
                user = vars.username;
            };

            default_session = {
                command = lib.concatStringsSep " " [
                    (lib.getExe pkgs.tuigreet)
                    "--time --remember --remember-session"
                    "--sessions ${sessionsDir}/wayland-sessions"
                    "--xsessions ${sessionsDir}/xsessions"
                ];
                user = "greeter";
            };
        };
    };
}
