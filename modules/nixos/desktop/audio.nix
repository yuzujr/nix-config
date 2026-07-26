{
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    # Realtime scheduling for PipeWire.
    security.rtkit.enable = true;
}
