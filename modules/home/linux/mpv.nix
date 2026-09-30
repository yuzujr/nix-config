{ pkgs, ... }:
{
    programs.mpv = {
        enable = true;

        scripts = with pkgs.mpvScripts; [
            autoload
            modernz
            quality-menu
            sponsorblock
            thumbfast
            mpris
        ];

        config = {
            hwdec = "auto";
            osc = false;
            osd-bar = false;
            save-position-on-quit = true;
            slang = "zh-CN,zh-Hans,zh";
            sub-auto = "fuzzy";
            watch-later-options-remove = "sub-pos,osd-margin-y";
            ytdl-format = "bestvideo[height<=2160]+bestaudio/best[height<=2160]";
        };

        scriptOpts = {
            autoload = {
                audio = false;
                images = false;
            };

            modernz = {
                button_held_size = 94;
                chapter_title_font_size = 13;
                fade_blur_strength = 55;
                hover_effect = "color,box";
                hover_effect_color = "#72A7E8";
                icon_theme = "material";
                icon_style = "outline";
                midbuttons_size = 21;
                nibble_color = "#555555";
                nibble_current_color = "#72A7E8";
                nibbles_bottom = false;
                nibbles_style = "single-bar";
                ontop_button = false;
                screenshot_button = false;
                loop_button = false;
                osc_fade_strength = 72;
                osc_height = 52;
                playpause_size = 26;
                seek_handle_border_color = "disable";
                seek_handle_color = "#72A7E8";
                seek_handle_size = 0.65;
                seekbar_height = "small";
                seekbarbg_color = "#555555";
                seekbarfg_color = "#72A7E8";
                sidebuttons_size = 20;
                time_font_size = 14;
                title_font_size = 20;
                truncate_title = true;
                volumebar_match_seek_color = true;
            };

            thumbfast = {
                hwdec = true;
                network = true;
                quit_after_inactivity = 30;
            };
        };
    };
}
