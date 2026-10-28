# nix-config

[![CI](https://github.com/yuzujr/nix-config/actions/workflows/ci.yml/badge.svg)](https://github.com/yuzujr/nix-config/actions/workflows/ci.yml)

NixOS, nix-darwin, Home Manager, dotfiles, and development shells. CI runs the
repository lint and `nix flake check`; placeholder secrets keep the flake
evaluable without the private secrets repo.

## Outputs

- `nixosConfigurations.laptop-nixos`
- `darwinConfigurations.macbook`
- `checks.<system>.{nixos,darwin}` (evaluation checks for both hosts, run by `nix flake check`)
- `devShells.<system>.default` (cross-platform: nixd + nixfmt wrapper)
- `devShells.x86_64-linux.{android-studio,clang-cpp,gcc-cpp,python,qt,rust}`
- `packages.x86_64-linux.{baidunetdisk,gold-price,wechat}`
- `formatter.{x86_64-linux,aarch64-darwin}` (nixfmt --indent 4, used by `nix fmt`)

## Layout

```text
.
├── devshells/               # Flake dev shells and the nixfmt formatter
├── dotfiles/                # Files linked by Home Manager
├── hosts/
│   ├── laptop-nixos/        # Feature selection, host data, hardware, and home
│   └── macbook/             # Feature selection, host data, and home
├── lib/                     # Shared helper functions (sops secret helpers)
├── modules/
│   ├── darwin/              # nix-darwin modules
│   ├── home/
│   │   ├── common/          # Home Manager modules for both platforms
│   │   ├── darwin/          # Home Manager modules for macOS
│   │   └── linux/           # Home Manager modules for NixOS
│   ├── nixos/               # NixOS modules
│   └── shared/              # Modules shared by NixOS and nix-darwin
├── packages/                # Local package definitions and dependency assembly
├── scripts/                 # Repository maintenance tools
├── secrets/placeholder/     # Public placeholder for the private secrets input
├── vars/                    # Shared user identity variables
├── flake.lock
└── flake.nix
```

Each `hosts/<name>/default.nix` selects feature groups and keeps host and Home
Manager settings together; hardware details live in `hardware.nix`. Host data
such as paths and Git identity lives in `vars.nix`. The flake passes it to both
module layers and adds `flakeHost`, the output name, which may differ from the
system hostname.

Features own their packages, config links, and services. Keep small platform
differences in the feature, and use platform directories for substantial or
platform-only settings. Imports are explicit: a file is enabled only when its
owning module or host imports it. `default.nix` may hold both imports and
settings; split files when a feature has an independent responsibility.

## Editable files and runtime state

The Home Manager `dot` helper links editable desktop and editor files into the
working checkout, so changes apply without rebuilding. Generation rollbacks do
not restore their contents. Runtime files such as Emacs caches and Rime
databases are ignored by Git; use `tree --gitignore` to omit them from listings.

Background services use Nix store executables. Gold Price packages the scripts
in `dotfiles/local/bin/` with their runtime dependencies, so direct checkout
invocations see edits immediately and the service picks them up on rebuild.

## Secrets

Private secrets are provided through the `secrets` flake input. Local rebuilds
usually override it:

```bash
--override-input secrets path:/path/to/nix-secret
```

The public placeholder at `secrets/placeholder` only keeps the flake evaluable
without the private repo. Secrets shared by both platforms are declared in
`modules/shared/secrets.nix`; platform baseline secrets live in
`modules/{nixos,darwin}/secrets.nix`. Optional network and service integrations
declare their own secrets alongside the feature.

## Package Policy

- NixOS: system and user packages are managed with Nix/Home Manager.
- macOS: applications and CLI tools are managed with Homebrew where practical.
- Home Manager is shared across platforms for dotfiles and user configuration such as Git and SSH.
- Emacs on macOS remains managed by Nix/Home Manager so its plugin set stays declarative.

`packages/default.nix` assembles local packages, including the stable-library
compatibility inputs for Baidu Netdisk. Home Manager and flake package outputs
use the same definitions.

## Verification

Run the repository lint and flake checks before rebuilding. The lint script
accepts file paths for a quick check of edited files. `nix flake check` also
evaluates both host configurations.

```bash
# Check the whole repository, or pass file paths to check only those files.
bash scripts/lint.sh

# Format Nix files.
nix fmt

# Validate flake outputs and evaluate both hosts.
nix flake check
```

For a refactor intended to preserve behavior, compare system derivations before
and after. Evaluate the baseline from a clean worktree because dirty `git+file:`
flake refs use the working copy:

```bash
git worktree add /tmp/nix-config-baseline HEAD
nix eval \
  --override-input secrets path:/path/to/nix-secret \
  /tmp/nix-config-baseline#nixosConfigurations.laptop-nixos.config.system.build.toplevel.drvPath
```

Real rebuilds need `--override-input secrets path:/path/to/nix-secret` to use
the private secrets repo; the placeholder under `secrets/placeholder` keeps the
flake evaluable (and CI green) without it.

## Rebuild

macOS:

```bash
sudo darwin-rebuild switch \
  --flake .#macbook \
  --override-input secrets path:/path/to/nix-secret
```

NixOS:

```bash
sudo nixos-rebuild switch \
  --flake .#laptop-nixos \
  --override-input secrets path:/path/to/nix-secret
```

## Development Shells

The default shell works on both platforms; named shells are Linux-only
(`x86_64-linux`).

```bash
nix develop                  # nixd, nixfmt, and the scripts/lint.sh tools
nix develop .#gcc-cpp
nix develop .#clang-cpp
nix develop .#qt
nix develop .#python
nix develop .#android-studio
nix develop .#rust
```

Build a local package with `nix build .#gold-price` (or `.#wechat` /
`.#baidunetdisk`).
