{
    homebrew = {
        enable = true;
        onActivation = {
            autoUpdate = true;
            cleanup = "zap";
        };
        brews = [
            "aria2"
            "cmake"
            "duf"
            "dust"
            "rustup"
            "tree"
            "prettier"
            "node"
            "xcodes"
            "xcodegen"

            # tencent
            "xcode-build-server"
            "clang-format"
            "ruby@3.4"
            "libyaml"
        ];
        casks = [
            "adrive"
            "font-maple-mono-nf-cn"
            "font-lxgw-wenkai"
            "squirrel-app"
            "google-chrome"
            "clash-verge-rev"
            "cc-switch"
            "codex"
            "chatgpt"
            "codebuddy-cn"
            "claude-code"
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
