#!/usr/bin/env bash
#
# The CI lint steps, runnable locally. `.github/workflows/ci.yml` runs this same
# script, so green here is green there; `nix flake check` (host evaluation) is
# the one CI step it does not cover.
#
#   bash scripts/lint.sh [files...]
#
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

# Written by nixos-generate-config, so every tool skips it.
readonly EXCLUDED='hosts/laptop-nixos/hardware-configuration.nix'

failures=()
repo_mode=true

run_tool() {
    local name="$1"
    shift
    if command -v "$name" >/dev/null 2>&1; then
        "$name" "$@"
    else
        nix run "nixpkgs#$name" -- "$@"
    fi
}

# The dev shell's `nixfmt` is a wrapper that already forces `--indent 4`, and the
# flake's `formatter` output is that same wrapper, so neither wants the flag.
check_format() {
    if command -v nixfmt >/dev/null 2>&1; then
        nixfmt --check "$@"
    else
        local system
        system="$(nix eval --impure --raw --expr builtins.currentSystem)"
        nix run ".#formatter.$system" -- --check "$@"
    fi
}

report() {
    local name="$1"
    shift
    printf '\n==> %s\n' "$name"
    "$@" || failures+=("$name")
}

nix_files=()
shell_files=()
workflow_files=()

if (($# == 0)); then
    while IFS= read -r file; do nix_files+=("$file"); done < <(
        find . -name '*.nix' -not -path './.git/*' -not -path './.direnv/*' \
            -not -path "./$EXCLUDED" | sort
    )
    while IFS= read -r file; do shell_files+=("$file"); done < <(
        find . -type f \( -name '*.sh' -o -path './dotfiles/local/bin/*' \) \
            -not -path './.git/*' -not -path './.direnv/*' -not -name '.*' | sort
    )
    while IFS= read -r file; do workflow_files+=("$file"); done < <(
        find .github/workflows -type f \( -name '*.yml' -o -name '*.yaml' \) | sort
    )
else
    repo_mode=false
    for path in "$@"; do
        if [[ ! -e "$path" ]]; then
            printf 'no such file: %s\n' "$path" >&2
            exit 2
        fi
        case "${path#./}" in
            "$EXCLUDED") ;;
            *.nix) nix_files+=("$path") ;;
            *.sh) shell_files+=("$path") ;;
            *.yml | *.yaml) workflow_files+=("$path") ;;
            *) ;;
        esac
    done
fi

# `statix` takes one target per run, so repo mode passes the root as CI does
# while file mode loops.
check_statix() {
    if $repo_mode; then
        run_tool statix check --ignore "$EXCLUDED" .
        return
    fi
    local file status=0
    for file in "${nix_files[@]}"; do
        run_tool statix check "$file" || status=1
    done
    return "$status"
}

if ((${#nix_files[@]} > 0)); then
    report "nixfmt --check (${#nix_files[@]} files)" check_format "${nix_files[@]}"
    report "statix (${#nix_files[@]} files)" check_statix
    report "deadnix (${#nix_files[@]} files)" run_tool deadnix --fail -- "${nix_files[@]}"
fi

if ((${#shell_files[@]} > 0)); then
    report "shellcheck (${#shell_files[@]} files)" run_tool shellcheck "${shell_files[@]}"
fi

if ((${#workflow_files[@]} > 0)); then
    report "actionlint (${#workflow_files[@]} files)" run_tool actionlint "${workflow_files[@]}"
fi

if ((${#failures[@]} > 0)); then
    printf '\nFAILED: %s\n' "${failures[*]}" >&2
    exit 1
fi

printf '\nAll lint checks passed.\n'
