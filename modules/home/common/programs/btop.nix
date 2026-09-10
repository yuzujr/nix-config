{
    programs.btop = {
        enable = true;
        settings = {
            color_theme = "noctalia";
            theme_background = false;
            shown_boxes = "net mem proc cpu";
            proc_sorting = "cpu direct";
            show_cpu_watts = true;
            update_ms = 2000;
        };
    };
}
