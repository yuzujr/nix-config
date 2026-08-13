{
    imports = [
        ../../modules/darwin
    ];

    nixpkgs.hostPlatform = "aarch64-darwin";

    # Adopted verbatim from the IT-assigned values (this is a company machine
    # with iOA): declaring the same names changes nothing at activation, it
    # only prevents drift. If IT ever renames the device, update these to
    # match rather than letting a rebuild fight the rename.
    networking = {
        hostName = "JASONXZHAI-MB0";
        localHostName = "JASONXZHAI-MB0";
        computerName = "JASONXZHAI-MB0";
    };

    system.stateVersion = 4;
}
