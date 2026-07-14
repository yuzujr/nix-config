{ ... }:
{
    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
            # devcloud (managed by Tencent devcloud tooling, see ~/.ssh/devcloud_config)
            "*.devcloud.woa.com" = {
                Include = "~/.ssh/devcloud_config";
            };

            "git.woa.com" = {
                User = "git";
                IdentityFile = "/run/secrets/ssh/gongfeng";
                IdentitiesOnly = true;
            };

            "dtm" = {
                User = "jasonxzhai";
                HostName = "21.214.137.243";
                Port = 36000;
                IdentityFile = "/run/secrets/ssh/dtm";
                IdentitiesOnly = true;
            };

            "github.com" = {
                User = "git";
                IdentityFile = "/run/secrets/ssh/github";
                IdentitiesOnly = true;
            };

            "vps" = {
                User = "ubuntu";
                HostName = "123.207.16.35";
                IdentityFile = "/run/secrets/ssh/vps";
                IdentitiesOnly = true;
            };

            "home" = {
                HostName = "laptop-nixos";
                User = "yuzujr";
                ProxyJump = "ubuntu@123.207.16.35";
            };
        };
    };

    home.file.".ssh/config".force = true;
}
