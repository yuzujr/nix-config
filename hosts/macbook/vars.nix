{ vars }:
let
    homeDirectory = "/Users/${vars.username}";
in
{
    inherit homeDirectory;
    repoRoot = "${homeDirectory}/Documents/nix-config";
    secretsRoot = "${homeDirectory}/Documents/nix-secret";
    gitIdentity = vars.git.work;
}
