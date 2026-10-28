# Nix configuration

This flake configures a NixOS laptop and an Apple Silicon Mac with
NixOS, nix-darwin, and Home Manager. The Linux desktop combines Niri and
Noctalia, with a shared Home Manager setup for shell, editor, and dotfile
configuration across Linux and macOS.

## Hosts

| Flake host | Platform | Configuration |
| --- | --- | --- |
| `laptop-nixos` | `x86_64-linux` | NixOS laptop with Niri, networking, and selected user services |
| `macbook` | `aarch64-darwin` | macOS managed with nix-darwin and Home Manager |

## Desktop experience

The Linux desktop is organized around Niri's scrollable tiling and Noctalia's
shell. Noctalia generates a coordinated theme for Niri, Kitty, btop, GTK, Qt,
and KDE color schemes, tying the window manager and desktop applications
together. The setup pairs Fcitx5 with Rime Ice for Chinese input, and uses KDE
apps such as Dolphin and Kate alongside the Wayland desktop.

Fish, Starship, Kitty, Neovim, and Emacs are configured through shared Home
Manager modules, with platform-specific details where needed. Linux also has
development shells for C/C++, Qt, Python, Rust, and Android Studio.

The host configurations contain machine-specific hardware, networking, and
application choices. Review these before using the flake on another computer;
the macOS host includes selected Homebrew packages.

## Adapting it

Start with `hosts/<name>/default.nix` and `hosts/<name>/vars.nix`. The host
variables select the Git identity and set the home directory, checkout path,
and private secrets checkout path. Shared identity defaults are in
`vars/default.nix`. For a new NixOS machine, replace or regenerate its hardware
configuration in `hosts/<name>/` and review the imported hardware modules.

Dotfiles are linked from this checkout, so edits to files under `dotfiles/`
take effect through the links and remain edits to the checkout itself.

## Secrets

Encrypted secrets are supplied by a separate private repository through the
flake input named `secrets`. The checked-in `secrets/placeholder` only allows
the flake to evaluate without that repository; it does not contain usable
credentials. Set each host's `secretsRoot` to your private checkout. It should
contain the encrypted files expected by the features you keep, including
`secrets/ssh.yaml`, `secrets/nix.yaml`, and (for NixOS) `secrets/network.yaml`,
`secrets/users.yaml`, and `secrets/apps.yaml` for the configured Gold Price
service. Remove or replace that service if it is not useful to your setup. SOPS
age keys are expected at
`~/.config/sops/age/keys.txt`.

The configured host uses an `nhs` Fish function to rebuild the current host and
pass its secrets checkout to Nix. Once the shell configuration is active, run
`nhs` to switch, or pass a mode supported by `nh os` or `nh darwin`, such as
`nhs build` or `nhs test`. On a fresh setup, the function is not available
until Home Manager has been activated; invoke `nh os` for NixOS or `nh darwin`
for macOS with the appropriate flake host and secrets input override, or adapt
the command to your bootstrap method.

## Checks

Run the repository lint locally with:

```sh
bash scripts/lint.sh
```

It checks Nix formatting, Nix lint and unused code, shell scripts, and GitHub
workflow files. To evaluate both host configurations, run:

```sh
nix flake check
```

The flake checks evaluate the NixOS and macOS system derivations; they do not
build complete operating systems or verify hardware boot.
