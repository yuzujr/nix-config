{
    pkgs,
    vars,
    ...
}:
{
    # Primary user is required by nix-darwin for some features like homebrew
    system.primaryUser = vars.username;

    # Let nix-darwin own the account record so the login shell tracks the
    # current fish package; a manual chsh to a bare store path goes stale
    # (and breaks entirely once that path is garbage-collected).
    users.knownUsers = [ vars.username ];

    users.users.${vars.username} = {
        # Must match the existing account's uid or activation refuses to adopt it.
        uid = 501;
        home = vars.homeDirectory;
        shell = pkgs.fish;
    };
}
