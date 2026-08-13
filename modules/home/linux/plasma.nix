# Declarative KDE config via plasma-manager (merge semantics: declared keys
# are enforced on each activation, everything else in the files is left alone).
# Nested kconfig groups like [Colors:Header][Inactive] are written "A/B".
{ inputs, ... }:
let
    colors = {
        base = "25,23,36";
        surface = "38,35,58";
        overlay = "31,29,47";
        muted = "144,140,170";
        text = "224,222,244";
        highlight = "249,235,233";
        rose = "235,188,186";
        love = "235,111,146";
        foam = "156,207,216";
        pine = "49,116,143";
        dark = "9,20,23";
        darkLove = "160,8,51";
        darkPine = "14,49,63";
    };
    commonColors = {
        DecorationFocus = colors.rose;
        DecorationHover = colors.rose;
        ForegroundActive = colors.rose;
        ForegroundInactive = colors.muted;
        ForegroundLink = colors.foam;
        ForegroundNegative = colors.love;
        ForegroundNeutral = colors.pine;
        ForegroundNormal = colors.text;
        ForegroundPositive = colors.pine;
        ForegroundVisited = colors.dark;
    };
in
{
    imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

    programs.plasma = {
        enable = true;

        configFile = {
            kdeglobals = {
                "ColorEffects:Disabled" = {
                    ChangeSelectionColor = "";
                    Color = "27,25,40";
                    ColorAmount = 0;
                    ColorEffect = 0;
                    ContrastAmount = "0.65";
                    ContrastEffect = 1;
                    Enable = "";
                    IntensityAmount = "0.1";
                    IntensityEffect = 2;
                };

                "ColorEffects:Inactive" = {
                    ChangeSelectionColor = true;
                    Color = "38,35,58";
                    ColorAmount = "0.025";
                    ColorEffect = 2;
                    ContrastAmount = "0.1";
                    ContrastEffect = 2;
                    Enable = false;
                    IntensityAmount = 0;
                    IntensityEffect = 0;
                };

                "Colors:Button" = commonColors // {
                    BackgroundAlternate = colors.overlay;
                    BackgroundNormal = "46,43,71";
                };

                "Colors:Complementary" = commonColors // {
                    BackgroundAlternate = colors.overlay;
                    BackgroundNormal = colors.base;
                    ForegroundNormal = colors.highlight;
                };

                "Colors:Header" = commonColors // {
                    BackgroundAlternate = colors.base;
                    BackgroundNormal = colors.surface;
                };

                "Colors:Header/Inactive" = commonColors // {
                    BackgroundAlternate = colors.surface;
                    BackgroundNormal = colors.base;
                };

                "Colors:Selection" = commonColors // {
                    BackgroundAlternate = colors.overlay;
                    BackgroundNormal = colors.rose;
                    ForegroundActive = colors.base;
                    ForegroundNegative = colors.darkLove;
                    ForegroundNeutral = colors.darkPine;
                    ForegroundNormal = colors.base;
                    ForegroundPositive = colors.darkPine;
                };

                "Colors:Tooltip" = commonColors // {
                    BackgroundAlternate = colors.base;
                    BackgroundNormal = colors.surface;
                };

                "Colors:View" = commonColors // {
                    BackgroundAlternate = colors.surface;
                    BackgroundNormal = colors.base;
                    DecorationFocus = colors.highlight;
                    DecorationHover = colors.base;
                };

                "Colors:Window" = commonColors // {
                    BackgroundAlternate = "206,43,36";
                    BackgroundNormal = colors.surface;
                };

                General = {
                    ColorScheme = "Noctalia";
                    Name = "noctalia";
                    XftAntialias = true;
                    XftHintStyle = "hintslight";
                    XftSubPixel = "vbgr";
                    fixed = "Hack,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
                    font = "Noto Sans CJK SC,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
                    menuFont = "Noto Sans CJK SC,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
                    smallestReadableFont = "Noto Sans CJK SC,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
                    toolBarFont = "Noto Sans CJK SC,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
                };

                Icons.Theme = "Tela-circle";

                KDE = {
                    contrast = 4;
                    frameContrast = "0.2";
                };

                "KFileDialog Settings" = {
                    "Allow Expansion" = false;
                    "Automatically select filename extension" = true;
                    "Breadcrumb Navigation" = false;
                    "Decoration position" = 2;
                    "Show Full Path" = false;
                    "Show Inline Previews" = true;
                    "Show Preview" = false;
                    "Show Speedbar" = true;
                    "Show hidden files" = false;
                    "Sort by" = "Name";
                    "Sort directories first" = true;
                    "Sort hidden files last" = false;
                    "Sort reversed" = false;
                    "Speedbar Width" = 130;
                    "View Style" = "DetailTree";
                };

                WM = {
                    activeBackground = "206,43,36";
                    activeBlend = "249,235,233";
                    activeFont = "Noto Sans CJK SC,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
                    activeForeground = "249,235,233";
                    inactiveBackground = "25,23,36";
                    inactiveBlend = "144,140,170";
                    inactiveForeground = "144,140,170";
                };
            };

            kcminputrc = {
                "Libinput/1133/16543/Logitech G502 X LS".PointerAcceleration = "-0.600";
                "Libinput/2362/597/UNIW0001:00 093A:0255 Touchpad".NaturalScroll = true;
                Mouse = {
                    cursorSize = 32;
                    cursorTheme = "BreezeX-RosePineDawn-Linux";
                };
            };

            kxkbrc.Layout = {
                DisplayNames = "";
                LayoutList = "us";
                Options = "ctrl:nocaps";
                Use = true;
                VariantList = "";
            };
        };
    };
}
