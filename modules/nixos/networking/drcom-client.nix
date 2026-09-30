{
    config,
    inputs,
    vars,
    ...
}:
{
    imports = [ inputs.drcom-client-cpp.nixosModules.default ];

    services.drcom-client-cpp = {
        enable = true;
        configFile = config.sops.secrets."network/drcom-jlu".path;
    };

    systemd.services.drcom-client-cpp.serviceConfig.User = vars.username;
}
