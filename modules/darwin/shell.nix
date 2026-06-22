{ pkgs, vars, ... }:
{
    # Ensure the declaratively-configured user shell is registered with macOS
    system.activationScripts.postActivation.text = ''
        # Ensure the Nix-managed shell is in /etc/shells
        fishPath="${pkgs.fish}/bin/fish"
        if ! grep -qxF "$fishPath" /etc/shells 2>/dev/null; then
          printf >&2 'adding %s to /etc/shells...\n' "$fishPath"
          echo "$fishPath" >> /etc/shells
        fi

        # Set the user's login shell via dscl (macOS Directory Service)
        targetShell="$fishPath"
        currentShell=$(dscl . -read "/Users/${vars.username}" UserShell 2>/dev/null | awk '{print $NF}')
        if [[ "$currentShell" != "$targetShell" ]]; then
          printf >&2 'setting %s login shell to %s...\n' "${vars.username}" "$targetShell"
          if [[ -n "$currentShell" ]]; then
            dscl . -change "/Users/${vars.username}" UserShell "$currentShell" "$targetShell"
          else
            dscl . -create "/Users/${vars.username}" UserShell "$targetShell"
          fi
        fi
    '';
}
