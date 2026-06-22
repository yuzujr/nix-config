{ secrets, vars }:
rec {
    mkSecret =
        file: key: attrs:
        {
            sopsFile = "${secrets}/secrets/${file}";
            inherit key;
        }
        // attrs;

    userSecret = {
        mode = "0400";
        owner = vars.username;
    };

    rootSecret = {
        mode = "0400";
        owner = "root";
    };
}
