{ vars }:
let
    homeDirectory = "/home/${vars.username}";
in
{
    inherit homeDirectory;
    repoRoot = "${homeDirectory}/nix-config";
    secretsRoot = "${homeDirectory}/nix-secret";
    gitIdentity = vars.git.personal;
}
