{ inputs, ... }:
{
    imports = [ inputs.umbriel.nixosModules.default ];

    # Additional session for trials; greetd still auto-starts Niri.
    programs.umbriel.enable = true;
}
