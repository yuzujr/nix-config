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

- `default.nix` files are pure `imports` lists. A new module loads only once it
  is listed in the nearest one, and forgetting fails silently.
- Platform differences are directory splits (`modules/{nixos,darwin,shared}`,
  `modules/home/{common,linux,darwin}`), never conditionals. `lib.mkIf` and
  `mkEnableOption` have no presence in this repo.
- A module signature lists the arguments it uses and no others; `deadnix` fails
  on the rest.
- `vars` is host-specific: `repoRoot` is `~/nix-config` on one host and
  `~/Documents/nix-config` on the other. Reach for `config.home.homeDirectory`
  or `vars.repoRoot`; `modules/home/linux/noctalia.nix` is the reference.
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
nothing: a green run does not mean a machine boots.
