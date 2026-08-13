# Work hosts and the way back home; their secrets are only declared on darwin.
{ secretPath, ... }:
{
    programs.ssh.settings = {
        # devcloud (managed by Tencent devcloud tooling, see ~/.ssh/devcloud_config)
        "*.devcloud.woa.com" = {
            Include = "~/.ssh/devcloud_config";
        };

        "git.woa.com" = {
            User = "git";
            IdentityFile = secretPath "ssh/gongfeng";
            IdentitiesOnly = true;
        };

        "dtm" = {
            User = "jasonxzhai";
            HostName = "21.214.137.243";
            Port = 36000;
            IdentityFile = secretPath "ssh/dtm";
            IdentitiesOnly = true;
        };

        "home" = {
            HostName = "laptop-nixos";
            ProxyJump = "vps";
            User = "yuzujr";
            IdentityFile = secretPath "ssh/home";
            IdentitiesOnly = true;
        };
    };
}
