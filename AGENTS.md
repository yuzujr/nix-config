# nix-config

NixOS, nix-darwin, and Home Manager flake. `README.md` covers layout, secrets,
and rebuild commands.

## Done

A change is done when the CI lint is green:

```bash
bash scripts/lint.sh            # whole repo, ~1s
bash scripts/lint.sh <files...> # only the files you touched, ms
```

CI runs this same script, so green here is green there. It does not cover host
evaluation; `nix flake check` (~30s) does, and it is the check that sees both
hosts.

## The checks

`nixfmt --indent 4` (run `nix fmt`) · `statix` · `deadnix --fail` · `shellcheck` · `actionlint`.

`statix` W20 `repeated_keys` is the failure this repo hits most: one attribute
path assigned twice in a set. Write `programs = { git = ...; delta = ...; }`
rather than three `programs.<name> = ...;` lines. Any option taking several
children wants one set, `home.file` and `home.activation` included.

## Conventions

- Prefer fewer file jumps when changing a feature. `default.nix` can contain
  both imports and settings; split a file when its contents have a useful
  independent responsibility, not just to keep an entrypoint empty.
- Hosts select complete groups such as the base system, desktop, and networking,
  plus optional services. Host settings and Home Manager choices live together
  in `hosts/<name>/default.nix`; hardware details stay in `hardware.nix`.
  Imports are explicit: adding a file to a directory does not enable it.
- Keep a feature's package, file links, and service together within its module
  layer. NixOS integration modules can declare secrets and import the matching
  Home Manager feature. `packages/default.nix` owns local package assembly;
  install-only applications belong in a platform's `packages.nix`.
- Keep NixOS, nix-darwin, and Home Manager at their respective module layers.
  Small platform differences belong in the same feature file with a simple
  condition. Use platform directories for substantial or platform-only config.
  Add abstractions for actual reuse, not hypothetical future hosts.
- A module signature lists the arguments it uses and no others; `deadnix` fails
  on the rest.
- `vars/default.nix` holds shared identity data; `hosts/<name>/vars.nix` selects
  the Git identity and declares `homeDirectory`, `repoRoot`, and `secretsRoot`.
  The flake adds `flakeHost`, which is the output name, not the OS hostname.
  Reach for these values or `config.home.homeDirectory` rather than embedding
  host names and paths in shared modules.
- `dot` links editable files into the working checkout; their contents do not
  roll back with a generation. Background services should use store executables
  with declared dependencies. Gold Price packages the existing script sources
  under `dotfiles/local/bin`; changing them requires rebuilding the service's
  package, while direct invocations of the checkout scripts remain live.
- `hosts/laptop-nixos/hardware-configuration.nix` comes from
  `nixos-generate-config` and every tool skips it.
- `secrets/placeholder` exists only so the flake evaluates without the private
  secrets repo; real rebuilds pass `--override-input secrets path:...`.

## Writing

Code blends into the file it joins, same structure and same density. A comment
carries what the code cannot say, which means temporary work and non-obvious
reasons, not a caption on every new block. When a change removes a comment's
reason, the comment goes with it.

## Boundaries

`main` is the deployed branch, so commit and push only when asked. CI builds
small evaluation checks, not complete host systems: a green run does not mean
a machine boots.
