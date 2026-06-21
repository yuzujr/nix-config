{
    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
            "github.com" = {
                User = "git";
                IdentityFile = "/run/secrets/ssh/github";
                IdentitiesOnly = true;
            };

            "gitee.com" = {
                User = "git";
                IdentityFile = "/run/secrets/ssh/gitee";
                IdentitiesOnly = true;
            };

            vm = {
                HostName = "192.168.166.128";
                User = "yuzujr";
                IdentityFile = "/run/secrets/ssh/vm";
                IdentitiesOnly = true;
            };

            "aur.archlinux.org" = {
                User = "aur";
                IdentityFile = "/run/secrets/ssh/aur";
                IdentitiesOnly = true;
            };
        };
    };
}
