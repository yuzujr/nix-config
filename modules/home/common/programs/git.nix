{ lib, pkgs, ... }:
let
    useThemeAwareDelta = pkgs.stdenv.hostPlatform.isLinux;
    deltaCommand = if useThemeAwareDelta then "delta-auto-theme" else "delta";
in
{
    programs.git = {
        enable = true;
        settings = {
            core.quotepath = false;
            init.defaultBranch = "main";
        }
        // lib.optionalAttrs useThemeAwareDelta {
            pager = lib.genAttrs [
                "blame"
                "diff"
                "log"
                "show"
            ] (_: deltaCommand);
        };
    };

    programs.delta = {
        enable = true;
        enableGitIntegration = !useThemeAwareDelta;
        options = {
            detect-dark-light = "always";
            syntax-theme = "ansi";
            file-style = "bold magenta";
            hunk-header-style = "bold cyan";
            minus-style = "syntax auto";
            minus-emph-style = "syntax auto";
            minus-empty-line-marker-style = "normal auto";
            plus-style = "syntax auto";
            plus-emph-style = "syntax auto";
            plus-empty-line-marker-style = "normal auto";
            zero-style = "syntax";
        };
    };

    programs.lazygit = {
        enable = true;
        settings = {
            git.diffRenderers = [
                {
                    type = "stdinFilter";
                    name = "delta";
                    colorArg = "always";
                    command = "${deltaCommand} --paging=never";
                }
            ];
            promptToReturnFromSubprocess = false;
        };
    };
}
