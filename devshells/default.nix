{ nixpkgs, system }:
let
    pkgs = nixpkgs.legacyPackages.${system};

    nixfmt = pkgs.writeShellScriptBin "nixfmt" ''
        if [ "$#" -gt 0 ]; then
          exec ${pkgs.nixfmt}/bin/nixfmt --indent 4 "$@"
        fi

        root="''${PRJ_ROOT:-$PWD}"

        exec ${pkgs.fd}/bin/fd \
          --type f \
          --extension nix \
          --hidden \
          --exclude .git \
          --exclude .direnv \
          . "$root" \
          -X ${pkgs.nixfmt}/bin/nixfmt --indent 4
    '';

    # android-studio is the only unfree package used by the dev shells; the
    # unfree policy lives here instead of inside the shell definition.
    unfreePkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
                "android-studio"
            ];
    };

    linuxDevShells = {
        android-studio = import ./android-studio.nix { pkgs = unfreePkgs; };
        clang-cpp = import ./clang-cpp.nix { inherit pkgs; };
        gcc-cpp = import ./gcc-cpp.nix { inherit pkgs; };
        python = import ./python.nix { inherit pkgs; };
        qt = import ./qt.nix { inherit pkgs; };
        rust = import ./rust.nix { inherit pkgs; };
    };
in
{
    formatter = nixfmt;

    devShells = {
        default = pkgs.mkShellNoCC {
            packages = [
                pkgs.nixd
                nixfmt
            ];
        };
    }
    // nixpkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux linuxDevShells;
}
