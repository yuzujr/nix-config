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
        dsh.tailnet.enable = true;
        images.enable = true;
        sillytavern.enable = true;
        autoStart = false;
    };
}
