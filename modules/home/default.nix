{ vars, ... }:
{
    imports = [
        ./common
    ]
    ++ (if vars.isDarwin then [ ./darwin ] else [ ./linux ]);

    home = {
        inherit (vars) username;
    };
}
