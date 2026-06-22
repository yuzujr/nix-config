# Note: This is an exception to the "macOS apps via Homebrew" policy.
# Emacs is built and managed via Nix on macOS to keep configuration integrated.
{ pkgs, ... }:
{
    programs.emacs.package = pkgs.emacs;
}
