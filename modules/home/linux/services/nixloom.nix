{
    inputs,
    ...
}:
{
    imports = [ inputs.nixloom.homeManagerModules.default ];

    services.nixloom = {
        enable = true;
        dsh.tailnet.enable = true;
        images.enable = true;
        sillytavern.enable = true;
        autoStart = false;
    };
}
