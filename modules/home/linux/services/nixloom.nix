{
    inputs,
    ...
}:
{
    imports = [ inputs.nixloom.homeManagerModules.default ];

    services.nixloom = {
        enable = true;
        # The module defaults the four writable locations to the XDG base
        # directories (config/state/data/cache), so no location override is
        # needed here.
        autoStart = false; # Loading a 20 GiB model is an intentional action, not a login side effect.
    };
}
