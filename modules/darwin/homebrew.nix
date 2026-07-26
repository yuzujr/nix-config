{
    homebrew = {
        enable = true;
        onActivation = {
            autoUpdate = true;
            cleanup = "zap";
        };
        brews = [
            "aria2"
            "btop"
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
            "xcodegen"

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
            "codex-app"
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
    };
}
