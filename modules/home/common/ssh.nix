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

            "aur.archlinux.org" = {
                User = "aur";
                IdentityFile = "/run/secrets/ssh/aur";
                IdentitiesOnly = true;
            };

            "git.woa.com" = {
                User = "git";
                IdentityFile = "/run/secrets/ssh/gongfeng";
                IdentitiesOnly = true;
            };

            "gitee.com" = {
                User = "git";
                IdentityFile = "/run/secrets/ssh/gitee";
                IdentitiesOnly = true;
            };

            "github.com" = {
                User = "git";
                IdentityFile = "/run/secrets/ssh/github";
                IdentitiesOnly = true;
            };

            vm = {
                HostName = "192.168.166.128";
                User = "yuzujr";
                IdentityFile = "/run/secrets/ssh/vm";
                IdentitiesOnly = true;
            };
        };
    };
}
