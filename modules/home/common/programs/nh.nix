{ vars, ... }:
{
    programs.nh = {
        enable = true;
        flake = vars.repoRoot;
    };
}
