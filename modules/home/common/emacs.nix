{
    pkgs,
    vars,
    rosePineDoomEmacsSrc,
    ...
}:

let
    emacsPkg = if vars.isDarwin then pkgs.emacs else pkgs.emacs-pgtk;
in

{
    home.packages = [ pkgs.cmark-gfm ];

    xdg.dataFile."emacs/themes/rose-pine-doom-emacs".source = rosePineDoomEmacsSrc;

    programs.emacs = {
        enable = true;
        package = emacsPkg;
        extraPackages =
            epkgs: with epkgs; [
                ace-window
                avy
                benchmark-init
                consult
                corfu
                cape
                corfu-prescient
                direnv
                diff-hl
                doom-themes
                eat
                expand-region
                glsl-mode
                helpful
                kdl-mode
                magit
                marginalia
                markdown-mode
                move-text
                multiple-cursors
                nix-ts-mode
                olivetti
                orderless
                prescient
                projectile
                rust-mode
                sideline
                sideline-flymake
                kind-icon
                treesit-auto
                vertico
                vertico-prescient
                which-key
                yasnippet
            ];
    };
}
