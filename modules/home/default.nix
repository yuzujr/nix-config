{ vars, ... }:
{
    imports = [
        ./common
    ]
    ++ (if vars.isDarwin then [ ./darwin ] else [ ]);

    home = {
        inherit (vars) username;
    };
}
