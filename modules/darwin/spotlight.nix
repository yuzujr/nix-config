{
    system.defaults.CustomUserPreferences."com.apple.Spotlight" = {
        # Keep Spotlight focused on app launching and clipboard history. App
        # discovery is independent of these content-provider integrations.
        EnabledPreferenceRules = [
            "com.apple.systempreferences"
        ];

        PasteboardHistoryEnabled = true;
        PasteboardHistoryTimeout = 2592000;
    };
}
