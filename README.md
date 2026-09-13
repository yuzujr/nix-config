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
- `formatter.{x86_64-linux,aarch64-darwin}` (nixfmt --indent 4, used by `nix fmt`)

## Layout

```text
.
├── devshells/               # Flake dev shells and the nixfmt formatter
├── dotfiles/                # Files linked by Home Manager
├── hosts/
│   ├── laptop-nixos/        # NixOS host entrypoint and hardware config
│   └── macbook/             # Darwin host entrypoint
├── lib/                     # Shared helper functions (sops secret helpers)
├── modules/
│   ├── darwin/              # nix-darwin modules
│   ├── home/
│   │   ├── common/          # Home Manager modules for both platforms
│   │   ├── darwin/          # Home Manager modules for macOS
│   │   └── linux/           # Home Manager modules for NixOS
│   ├── nixos/               # NixOS modules
│   └── shared/              # Modules shared by NixOS and nix-darwin
├── secrets/placeholder/     # Public placeholder for the private secrets input
├── vars/                    # Shared user identity variables
├── flake.lock
└── flake.nix
```

Each platform wires its own Home Manager entrypoint in
`modules/{nixos,darwin}/home.nix`; user-level modules live under
`modules/home/` split by platform.

## Secrets

Private secrets are provided through the `secrets` flake input. Local rebuilds
usually override it:

```bash
--override-input secrets path:/path/to/nix-secret
```

The public placeholder at `secrets/placeholder` only keeps the flake evaluable
without the private repo. Secrets shared by both platforms are declared in
`modules/shared/secrets.nix`; platform-specific ones in
`modules/{nixos,darwin}/secrets.nix`.

## Package Policy

- NixOS: system and user packages are managed with Nix/Home Manager.
- macOS: applications and CLI tools are managed with Homebrew where practical.
- Home Manager is shared across platforms for dotfiles and user configuration such as Git and SSH.
- Emacs on macOS remains managed by Nix/Home Manager so its plugin set stays declarative.

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

# The rest of CI: dev shells and, through `checks`, both host evaluations above.
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
