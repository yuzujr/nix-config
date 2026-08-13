{ lib, ... }:
{
    # Plasma and Niri both contribute the GTK portal. De-duplicate the merged
    # list while continuing to inherit each desktop module's backend choices.
    options.xdg.portal.extraPortals = lib.mkOption {
        apply = lib.unique;
    };

    config = {
        programs.niri = {
            enable = true;
            useNautilus = false;
        };

        services = {
            # Both Plasma and Niri provide a default; prefer Niri for this host.
            displayManager.defaultSession = "niri";

            # Leave these events for the wm to handle.
            logind.settings.Login = {
                HandlePowerKey = "ignore";
                HandleLidSwitch = "ignore";
                HandleLidSwitchExternalPower = "ignore";
                HandleLidSwitchDocked = "ignore";
            };
        };
    };
}
