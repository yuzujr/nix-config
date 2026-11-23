{
    lib,
    pkgs,
    vars,
    ...
}:
let
    isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    lazygitDeltaBase = ''delta --{{colorScheme}} --paging=never --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"'';
in
{
    programs = {
        git = {
            enable = true;
            settings = {
                core.quotepath = false;
                diff = {
                    algorithm = "histogram";
                    colorMoved = "default";
                };
                init.defaultBranch = "main";
                merge.conflictStyle = "zdiff3";
                user = vars.gitIdentity;
            };
        }
        // lib.optionalAttrs isDarwin {
            # Use system Git on macOS.
            package = null;
            lfs.enable = true;
        };

        delta = {
            enable = true;
            enableGitIntegration = true;
            options = {
                detect-dark-light = "always";
                navigate = true;
                hyperlinks = true;
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

        lazygit = {
            enable = true;
            settings = {
                git.diffRenderers = [
                    {
                        type = "stdinFilter";
                        name = "delta";
                        colorArg = "always";
                        command = lazygitDeltaBase;
                    }
                    {
                        type = "stdinFilter";
                        name = "delta (side-by-side)";
                        colorArg = "always";
                        command = "${lazygitDeltaBase} --side-by-side";
                    }
                ];
                promptToReturnFromSubprocess = false;
            };
        };
    };
}
