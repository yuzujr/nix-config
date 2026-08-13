# macOS-only config files.
{ dot, ... }:
{
    xdg.configFile.kitty = dot "kitty-darwin";

    home.file = {
        "Library/Rime/squirrel.custom.yaml" = dot "squirrel/squirrel.custom.yaml";
        "Library/Rime/default.custom.yaml" = dot "squirrel/default.custom.yaml";
        "Library/Rime/double_pinyin_flypy.custom.yaml" = dot "squirrel/double_pinyin_flypy.custom.yaml";
    };
}
