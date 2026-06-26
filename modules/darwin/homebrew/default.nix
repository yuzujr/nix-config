{ ... }:
{
    homebrew = {
        enable = true;
        onActivation = {
            autoUpdate = true;
            cleanup = "zap";
        };
        taps = [ ];
        brews = [
            "cmake"
            "duf"
            "dust"
            "fd"
            "ripgrep"
            "rustup"
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
            "xcodes"

            # tencent
            "xcode-build-server"
            "clang-format"
            "ruby@3.4"
            "libyaml"
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
            "codebuddy-cn"
            "cursor"
            "claude-code"
            "linearmouse"
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
