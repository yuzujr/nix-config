{
    description = "yuzujr's NixOS and macOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        darwin = {
            url = "github:LnL7/nix-darwin";
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

        rose-pine-doom-emacs = {
            url = "github:donniebreve/rose-pine-doom-emacs";
            flake = false;
        };
    };

    outputs =
        inputs@{ self, nixpkgs, darwin, home-manager, sops-nix, secrets, coomer, drcom-client-cpp, ani2xcursor, noctalia, rose-pine-doom-emacs, ... }:
        let
            supportedSystems = [
                "x86_64-linux"
                "aarch64-darwin"
            ];
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

            vars = import ./vars;

            mkNixosHost = { hostname, system ? "x86_64-linux" }:
                let
                    homeDirectory = "/home/${vars.username}";
                    hostVars = vars // {
                        inherit homeDirectory;
                        repoRoot = "${homeDirectory}/nix-config";
                    };
                in nixpkgs.lib.nixosSystem {
                    inherit system;
                    specialArgs = {
                        inherit inputs home-manager hostname sops-nix secrets;
                        vars = hostVars;
                        coomerPkg = coomer.packages.${system}.default;
                        drcomClientPkg = drcom-client-cpp.packages.${system}.default;
                        ani2xcursorPkg = ani2xcursor.packages.${system}.default;
                        noctaliaPkg = noctalia.packages.${system}.default;
                        rosePineDoomEmacsSrc = rose-pine-doom-emacs;
                    };
                    modules = [
                        ./hosts/nixos-laptop/default.nix
                    ];
                };

            mkDarwinHost = { hostname, system ? "aarch64-darwin" }:
                let
                    homeDirectory = "/Users/${vars.username}";
                    hostVars = vars // {
                        inherit homeDirectory;
                        repoRoot = "${homeDirectory}/Documents/nix-config";
                    };
                in darwin.lib.darwinSystem {
                    inherit system;
                    specialArgs = {
                        inherit inputs home-manager hostname sops-nix secrets;
                        vars = hostVars;
                        # Linux-only packages (coomerPkg, drcomClientPkg, ani2xcursorPkg, noctaliaPkg)
                        # are not passed here; modules/home/packages/linux.nix uses ? null defaults.
                        rosePineDoomEmacsSrc = rose-pine-doom-emacs;
                    };
                    modules = [
                        ./hosts/macbook/default.nix
                    ];
                };

            mkDevShells = import ./devshells { inherit nixpkgs; };
        in
        {
            formatter = forAllSystems (system: (mkDevShells system).formatter);

            devShells = forAllSystems (system: (mkDevShells system).devShells);

            nixosConfigurations = {
                nixos-laptop = mkNixosHost { hostname = vars.hostname; };
            };

            darwinConfigurations = {
                macbook = mkDarwinHost { hostname = "macbook"; };
            };
        };
}
