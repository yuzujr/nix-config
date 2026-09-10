{
    config,
    pkgs,
    vars,
    ...
}:
let
    isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    rebuild =
        if isDarwin then
            "nh darwin $mode --show-activation-logs $argv ${vars.repoRoot}#macbook -o ${vars.homeDirectory}/.cache/nh/result -- --override-input secrets path:${vars.homeDirectory}/Documents/nix-secret"
        else
            "nh os $mode $argv ${vars.repoRoot}#laptop-nixos -o ${vars.homeDirectory}/.cache/nh/result -- --override-input secrets path:${vars.homeDirectory}/nix-secret";
in
{
    home = {
        sessionPath = [
            "${vars.homeDirectory}/.local/bin"
        ]
        ++ (
            if isDarwin then
                [
                    "/opt/homebrew/opt/rustup/bin"
                    "/opt/homebrew/bin"
                    "/opt/homebrew/sbin"
                    "${vars.homeDirectory}/background_agent_cli/bin"
                ]
            else
                [ ]
        );
        sessionVariables.SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys.txt";
    };

    programs.fish = {
        enable = true;
        shellAliases = {
            cls = "clear && printf '\\e[3J'";
            ls = "eza --icons -F -H --group-directories-first --git -1";
            ll = "eza --icons -F -H --group-directories-first --git -1 -l";
            du = "dust";
            df = "duf -only local";
            diff = "delta";
            ff = "fastfetch";
        };
        functions.nhs = {
            description = "Rebuild the current NixOS or nix-darwin host";
            body = ''
                set -l mode switch
                switch $argv[1]
                    case switch build test boot
                        set mode $argv[1]
                        set -e argv[1]
                end
                ${rebuild}
            '';
        };
        functions.v = {
            description = "Open a project file in Neovim";
            body = ''
                argparse i/interactive -- $argv
                or return

                set -l interactive false
                if set -q _flag_i
                    set interactive true
                end

                if test (count $argv) -eq 0; and test $interactive = false
                    command nvim
                    return
                end

                if test $interactive = false; and test (count $argv) -eq 1; and test -f $argv[1]
                    command nvim $argv[1]
                    return
                end

                set -l root $PWD
                if set -l git_root (command git rev-parse --show-toplevel 2>/dev/null)
                    set root $git_root
                end

                set -l query (string join " " -- $argv)
                set -l selection
                if test $interactive = true
                    set selection (
                        cd -- $root
                        and fd --type f --hidden --exclude .git --strip-cwd-prefix | fzf --scheme=path --query=$query --select-1 --exit-0
                    )
                else
                    set selection (
                        cd -- $root
                        and fd --type f --hidden --exclude .git --strip-cwd-prefix | fzf --scheme=path --filter=$query | head -n 1
                    )
                end

                if test -z "$selection"
                    printf 'v: no matching file\n' >&2
                    return 1
                end
                command nvim "$root/$selection"
            '';
        };
        interactiveShellInit = ''
            set fish_greeting
            ${
                if isDarwin then
                    "bind \\ec 'printf %s \"$(commandline)\" | pbcopy'"
                else
                    "bind \\ec 'commandline | wl-copy --trim-newline'"
            }
        '';
    };
}
