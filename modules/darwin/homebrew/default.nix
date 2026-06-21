{ ... }:
{
    homebrew = {
        enable = true;
        onActivation = {
            autoUpdate = true;
            cleanup = "zap";
        };
        taps = [];
        brews = [
            "fish"
            "duf"
            "dust"
            "fd"
            "ripgrep"
            "starship"
            "zoxide"
            "eza"
            "git-delta"
            "yazi"
            "fastfetch"
            "tree"
            "prettier"
            "node"
            "neovim"
        ];
        casks = [
            "kitty"
            "font-maple-mono-nf-cn"
            "font-lxgw-wenkai"
            "squirrel-app"
            "google-chrome"
            "clash-verge-rev"
            "cc-switch"
            "codex"
            "visual-studio-code"
            "antigravity-cli"
            "wechat"
            "qq"
            "wechatwork"
            "tencent-meeting"
            "neteasemusic"
        ];
        masApps = {
            # "App Name" = 123456;
        };
    };
}
