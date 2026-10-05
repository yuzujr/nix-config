# nix-config

[![CI](https://github.com/yuzujr/nix-config/actions/workflows/ci.yml/badge.svg)](https://github.com/yuzujr/nix-config/actions/workflows/ci.yml)

NixOS, nix-darwin, Home Manager, dotfiles, and development shells.

CI runs `scripts/lint.sh` (formatting, workflow/Nix/shell style, dead code) and
then `nix flake check`, which covers the dev shells and — via the flake's
`checks` output — the evaluation of both host configurations. Those are the
same two commands you run locally, so there is nothing to reproduce by hand;
`scripts/lint.sh` also takes file arguments for a millisecond check while
editing. The placeholder secrets under `secrets/placeholder` keep the flake
fully evaluable without the private repo, so CI needs no secrets.

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

`hosts/<name>/default.nix` holds host settings and selects complete groups:
the base system, desktop, networking, and optional personal services. Home
Manager choices are in that same file; hardware details live in `hardware.nix`.
The networking group includes the laptop's campus login, proxy, and Tailscale
integration, which are used together on this machine.

Host data lives in `hosts/<name>/vars.nix`: home and repository paths, the
private secrets checkout, and the selected Git identity. The flake passes this
data to both module layers and adds `flakeHost`, the flake output name. This
can differ from the system hostname, as it does on the MacBook.

Within each layer, a feature owns its package, config links, and service or
activation logic. For example, the NixOS Gold Price integration declares its
secret and imports the Home Manager service; that service installs its local
package and config links. `packages.nix` lists applications that only need
installation. Small platform differences, such as the Emacs package or Kitty
font size, stay in the program's own file. Platform directories hold substantial
or platform-only settings, such as the Linux desktop and macOS SSH integration.

`default.nix` can contain both imports and settings. Split files when that
makes a feature easier to maintain independently, rather than adding layers
for directory symmetry. There is no automatic directory discovery: import a
feature from its owning module or host to enable it.

## Editable files and runtime state

The Home Manager `dot` helper links into the working checkout so desktop and
editor changes apply without rebuilding. These files are not snapshots of a
Nix generation: rolling back a generation does not restore their contents.
Runtime files created alongside them, such as Emacs caches, Rime databases,
and Niri's current-profile links, are ignored by Git. Use `tree --gitignore`
to inspect the source layout without this local state.

Background services use executables from the Nix store. Gold Price packages
the existing sources in `dotfiles/local/bin/` with their runtime dependencies;
editing a script updates direct checkout invocations immediately, while the
service receives the change on rebuild. Its configuration and data paths stay
the same. Noctalia's writable theme integration remains in its own module.

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
compatibility inputs for Baidu Netdisk. Home Manager and the flake's package
outputs use the same definitions. Build a package independently with
`nix build .#gold-price` (or `.#wechat` / `.#baidunetdisk`).

## Verification

Both configurations should evaluate before a rebuild, and a refactor that is
meant to be a no-op should produce the same system derivation.

```bash
# Evaluate both hosts (pure eval: proves the config is consistent, builds nothing).
nix eval .#nixosConfigurations.laptop-nixos.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.macbook.system.drvPath

# The lint half of CI: nixfmt, statix, deadnix, shellcheck, actionlint. Pass
# file paths to check only those, or nothing to check the whole repo.
bash scripts/lint.sh

# Rewrite the files the lint would reject.
nix fmt

# The rest of CI: validate outputs and build the small host evaluation checks.
nix flake check
```

For a no-op refactor, diff the system derivation hashes before and after.
Because `git+file:` flake refs use the working copy when the tree is dirty,
evaluate a baseline from a clean worktree:

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

The named shells are Linux-only (`x86_64-linux`); the default shell works on
both platforms.

```bash
nix develop                  # nixd, nixfmt, and the scripts/lint.sh tools
nix develop .#gcc-cpp
nix develop .#clang-cpp
nix develop .#qt
nix develop .#python
nix develop .#android-studio
nix develop .#rust
```
