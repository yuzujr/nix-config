{
    inputs,
    ...
}:
{
    imports = [ inputs.nixloom.homeManagerModules.default ];

    services.nixloom = {
        enable = true;
        acceleration = "cuda";
        cudaCapabilities = [ "12.0" ];
        images.enable = true;
        openclaw.enable = true;
        sillytavern.enable = true;
        autoStart = false;
    };
}
