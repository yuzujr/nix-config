{
    description = "yuzujr's NixOS and macOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        darwin = {
            url = "github:nix-darwin/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        plasma-manager = {
            url = "github:nix-community/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        secrets = {
            url = "path:./secrets/placeholder";
            flake = false;
        };

        coomer = {
            url = "github:yuzujr/coomer";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        drcom-client-cpp = {
            url = "github:yuzujr/drcom-client-cpp";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ani2xcursor = {
            url = "github:yuzujr/ani2xcursor";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        noctalia = {
            url = "github:noctalia-dev/noctalia";
        };

        nixloom.url = "github:yuzujr/nixloom";

        rose-pine-doom-emacs = {
            url = "github:donniebreve/rose-pine-doom-emacs";
            flake = false;
        };
    };

    outputs =
        inputs@{
            self,
            nixpkgs,
            darwin,
            ...
        }:
        let
            supportedSystems = [
                "x86_64-linux"
                "aarch64-darwin"
            ];
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

            vars = import ./vars;

            # Each host declares its platform via nixpkgs.hostPlatform in its own
            # module tree, so no system argument is passed to the builders here.
            mkHost =
                {
                    hostname,
                    repoSubdir,
                    isDarwin ? false,
                }:
                let
                    builder = if isDarwin then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
                    homeDirectory = "${if isDarwin then "/Users" else "/home"}/${vars.username}";
                    hostVars = vars // {
                        inherit homeDirectory;
                        repoRoot = "${homeDirectory}/${repoSubdir}";
                    };
                in
                builder {
                    specialArgs = {
                        inherit inputs;
                        vars = hostVars;
                        secretsLib = import ./lib/secrets.nix {
                            inherit (inputs) secrets;
                            vars = hostVars;
                        };
                    };
                    modules = [ ./hosts/${hostname} ];
                };

            devshellsFor = forAllSystems (system: import ./devshells { inherit nixpkgs system; });
        in
        {
            formatter = forAllSystems (system: devshellsFor.${system}.formatter);

            devShells = forAllSystems (system: devshellsFor.${system}.devShells);

            # Evaluation checks for both hosts. Discarding the string context
            # keeps the systems out of the build graph while forcing their
            # complete derivation paths to evaluate.
            checks = forAllSystems (
                system:
                let
                    pkgs = nixpkgs.legacyPackages.${system};
                    mkEvalCheck =
                        name: drv:
                        let
                            drvPath = builtins.unsafeDiscardStringContext drv.drvPath;
                        in
                        pkgs.runCommand "eval-check-${name}" { } ''
                            echo "evaluated: ${drvPath}" > $out
                        '';
                in
                {
                    nixos = mkEvalCheck "nixos" self.outputs.nixosConfigurations.laptop-nixos.config.system.build.toplevel;
                    darwin = mkEvalCheck "darwin" self.outputs.darwinConfigurations.macbook.system;
                }
            );

            nixosConfigurations.laptop-nixos = mkHost {
                hostname = "laptop-nixos";
                repoSubdir = "nix-config";
            };

            darwinConfigurations.macbook = mkHost {
                hostname = "macbook";
                repoSubdir = "Documents/nix-config";
                isDarwin = true;
            };
        };
}
