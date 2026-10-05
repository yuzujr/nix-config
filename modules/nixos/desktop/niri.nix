{
    programs.niri = {
        enable = true;
        useNautilus = false;
    };

    services = {
        displayManager.defaultSession = "niri";

        # Leave these events for the wm to handle.
        logind.settings.Login = {
            HandlePowerKey = "ignore";
            HandleLidSwitch = "ignore";
            HandleLidSwitchExternalPower = "ignore";
            HandleLidSwitchDocked = "ignore";
        };
    };
}
