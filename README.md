# nix-config

NixOS, nix-darwin, Home Manager, dotfiles, and development shells.

## Outputs

- `nixosConfigurations.nixos-laptop`
- `darwinConfigurations.macbook`
- `devShells.{x86_64-linux,aarch64-darwin}.*`

## Layout

```text
.
├── devshells/               # Flake dev shells
├── dotfiles/                # Files linked by Home Manager
├── hosts/
│   ├── macbook/             # Darwin host entrypoint
│   └── nixos-laptop/        # NixOS host entrypoint and hardware config
├── lib/                     # Shared helper functions
├── modules/
│   ├── darwin/              # nix-darwin modules
│   ├── home/                # Shared Home Manager modules
│   └── nixos/               # NixOS modules
├── secrets/placeholder/     # Public placeholder for the private secrets input
├── vars/                    # Shared user and host variables
├── flake.lock
└── flake.nix
```

## Secrets

Private secrets are provided through the `secrets` flake input. Local rebuilds usually override it:

```bash
--override-input secrets path:/Users/yuzujr/Documents/nix-secret
```

The public placeholder at `secrets/placeholder` only keeps the flake evaluable without the private repo.

## Package Policy

- NixOS: system and user packages are managed with Nix/Home Manager.
- macOS: applications and CLI tools are managed with Homebrew where practical.
- Home Manager is shared across platforms for dotfiles and user configuration such as Git and SSH.
- Emacs on macOS remains managed by Nix/Home Manager so its plugin set stays declarative.

## Rebuild

macOS:

```bash
sudo darwin-rebuild switch \
  --flake .#macbook \
  --override-input secrets path:/Users/yuzujr/Documents/nix-secret
```

NixOS:

```bash
sudo nixos-rebuild switch \
  --flake .#nixos-laptop \
  --override-input secrets path:/path/to/nix-secret
```

## Development Shells

```bash
nix develop .#gcc-cpp-env
nix develop .#clang-cpp-env
nix develop .#qt-env
nix develop .#python-env
nix develop .#android-studio-env
nix develop .#rust-env
```
