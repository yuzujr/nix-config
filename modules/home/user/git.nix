{ config, lib, pkgs, vars, ... }:
{
    programs.git = {
        enable = true;
        package = lib.mkIf pkgs.stdenv.isDarwin null;
        settings = {
            user = {
                name = vars.git.name;
                email = vars.git.email;
            };
            core = {
                hooksPath = "${config.home.homeDirectory}/.git-hooks";
                quotepath = false;
            };
            init.defaultBranch = "main";
        } // lib.optionalAttrs pkgs.stdenv.isDarwin {
            interactive.diffFilter = "delta --color-only";
            pager = {
                blame = "delta";
                diff = "delta";
                log = "delta";
                show = "delta";
            };
        };
    };

    programs.delta = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        enableGitIntegration = true;
    };
}
