{
    config,
    inputs,
    vars,
    secretsLib,
    ...
}:
{
    imports = [ inputs.drcom-client-cpp.nixosModules.default ];

    sops.secrets."network/drcom-jlu" =
        secretsLib.mkSecret "network.yaml" "drcom-jlu"
            secretsLib.userSecret;

    home-manager.users.${vars.username} = { mkSymlink, secretPath, ... }: {
        xdg.configFile."drcom-client-cpp/drcom-jlu.conf".source = mkSymlink (
            secretPath "network/drcom-jlu"
        );
    };

    services.drcom-client-cpp = {
        enable = true;
        configFile = config.sops.secrets."network/drcom-jlu".path;
    };

    systemd.services.drcom-client-cpp.serviceConfig.User = vars.username;
}
