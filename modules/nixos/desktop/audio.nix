{
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
    };

    # Realtime scheduling for PipeWire.
    security.rtkit.enable = true;
}
