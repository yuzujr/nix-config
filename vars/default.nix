let
    username = "yuzujr";
in
{
    inherit username;

    git = {
        personal = {
            name = username;
            email = "15568103056@163.com";
        };
        work = {
            name = "jasonxzhai";
            email = "jasonxzhai@tencent.com";
        };
    };
}
