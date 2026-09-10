# nix-config

[![CI](https://github.com/yuzujr/nix-config/actions/workflows/ci.yml/badge.svg)](https://github.com/yuzujr/nix-config/actions/workflows/ci.yml)

NixOS, nix-darwin, Home Manager, dotfiles, and development shells.

CI checks formatting, workflow/Nix/shell style, dead code, and that both host
configurations evaluate (now via the flake's `checks` output, so
`nix flake check` covers the host evaluations locally). The placeholder secrets
under `secrets/placeholder` keep the flake fully evaluable without the private
repo, so CI needs no secrets.

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

# Run the same checks as CI. The flake check covers dev shells and, through
# `checks`, evaluates both hosts above.
nix fmt
git diff --exit-code
nix run nixpkgs#actionlint -- .github/workflows/ci.yml
nix run nixpkgs#statix -- check --ignore hosts/laptop-nixos/hardware-configuration.nix .
nix run nixpkgs#deadnix -- --fail --exclude hosts/laptop-nixos/hardware-configuration.nix -- .
nix run nixpkgs#shellcheck -- dotfiles/local/bin/*
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

## Umbriel trial session (NixOS)

Umbriel is installed alongside Niri and Plasma using its upstream flake module.
Niri remains the boot auto-login session. After rebuilding with the private
secrets override above, log out of Niri and select **Umbriel** in tuigreet's
session selector (F2), then log in.

The Home Manager configuration in `modules/home/linux/umbriel.nix` includes the
pinned package's example configuration, starts Noctalia, and uses scrolling.
Useful native-session bindings:

- Super: Noctalia launcher; Super+Enter: Kitty.
- Super+Q: close window; Super+F: fullscreen; Super+O: overview.
- Super+arrow keys: focus; Super+Shift+arrow keys: move windows/columns.
- Super+1–9: workspace; Super+R: cycle width.
- Super+Ctrl+T: cycle scrolling/dwindle/master.
- Super+Alt+L: lock; Super+Escape: exit back to the login screen.

Choose Niri at the login screen to return. Run `umbriel outputs` inside Umbriel
to inspect display names before adding output scaling/mode settings. Validate
configuration changes with `umbriel validate`.

## Development Shells

The named shells are Linux-only (`x86_64-linux`); the default shell works on
both platforms.

```bash
nix develop                  # nixd + nixfmt
nix develop .#gcc-cpp
nix develop .#clang-cpp
nix develop .#qt
nix develop .#python
nix develop .#android-studio
nix develop .#rust
```
