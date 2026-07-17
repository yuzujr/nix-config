# ============================================================
#  Environment
# ============================================================
# All PATH prepends are guarded by `contains` so this file is
# idempotent (safe to re-source, no duplicates). Effective
# priority on macOS:
#   ~/.local/bin > rustup (brew) > Homebrew > Nix/nix-darwin > system

# sops-nix: tell sops CLI where the age key is (fish doesn't read hm-session-vars.sh)
set -gx SOPS_AGE_KEY_FILE $HOME/.config/sops/age/keys.txt

# Default editor (used by sops, git, crontab, etc.)
set -gx EDITOR nvim
set -gx VISUAL nvim

# User-local binaries
if test -d $HOME/.local/bin
    if not contains -- $HOME/.local/bin $PATH
        set -gx PATH $HOME/.local/bin $PATH
    end
end

# rustup (Homebrew): proxies live in opt/rustup/bin, not /opt/homebrew/bin
if test -d /opt/homebrew/opt/rustup/bin
    if not contains -- /opt/homebrew/opt/rustup/bin $PATH
        set -gx PATH /opt/homebrew/opt/rustup/bin $PATH
    end
end

# Homebrew (Apple Silicon macOS)
if test -d /opt/homebrew/bin
    if not contains -- /opt/homebrew/bin $PATH
        set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
    end
end

# Nix and nix-darwin (usually injected by path_helper; ensure presence as fallback)
if not contains -- /run/current-system/sw/bin $PATH
    set -gx PATH /run/current-system/sw/bin /nix/var/nix/profiles/default/bin $HOME/.nix-profile/bin $PATH
end

# background_agent_cli
if not contains -- /Users/yuzujr/background_agent_cli/bin $PATH
    set -gx PATH /Users/yuzujr/background_agent_cli/bin $PATH
end

if status is-interactive
    # Init
    set fish_greeting
    starship init fish | source
    zoxide init fish --cmd cd | source

    # Alias
    alias vim="nvim"
    alias cls="clear && printf '\e[3J'"
    alias ls="eza --icons -F -H --group-directories-first --git -1"
    alias ll="eza --icons -F -H --group-directories-first --git -1 -l"
    alias du="dust"
    alias df="duf -only local"
    alias diff="delta"

    # Nix rebuild helper (works on Linux with NixOS and macOS with nix-darwin)
    function nhs --description "nh with secret inputs: nhs [switch|build|test|boot]"
        set -l mode switch
        switch $argv[1]
            case switch build test boot
                set mode $argv[1]
                set -e argv[1]
        end

        if test (uname) = Darwin
            nh darwin $mode --show-activation-logs $argv /Users/yuzujr/Documents/nix-config#macbook \
                -- --override-input secrets path:$HOME/Documents/nix-secret
        else
            nh os $mode $argv /home/yuzujr/nix-config#laptop-nixos \
                -- --override-input secrets path:/home/yuzujr/nix-secret
        end
    end

    # Functions
    if test (uname) = Linux
        function ff --wraps fastfetch --description "fastfetch with GNOME light/dark config"
            set -l light ~/.config/fastfetch/config-light.jsonc
            set -l dark ~/.config/fastfetch/config-dark.jsonc

            set -l cs (dconf read /org/gnome/desktop/interface/color-scheme 2>/dev/null)

            if string match -q "*prefer-dark*" -- $cs
                command fastfetch --config $dark
            else
                command fastfetch --config $light
            end
        end

        bind \ec 'commandline | wl-copy --trim-newline'
    else if test (uname) = Darwin
        alias ff="fastfetch"

    end

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # Keybindings
    bind \cs 'for cmd in sudo doas please; if command -q $cmd; fish_commandline_prepend $cmd; break; end; end'
end
