{
    programs.tmux = {
        enable = true;

        baseIndex = 1;
        clock24 = true;
        customPaneNavigationAndResize = true;
        escapeTime = 0;
        focusEvents = true;
        historyLimit = 100000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-b";
        sensibleOnTop = false;
        terminal = "tmux-256color";

        extraConfig = ''
            set -g renumber-windows on

            set -g set-clipboard on
            set -g allow-passthrough on
            set -as terminal-features ",xterm*:RGB"

            unbind '"'
            unbind %
            bind - split-window -v -c "#{pane_current_path}"
            bind | split-window -h -c "#{pane_current_path}"
            bind c new-window -c "#{pane_current_path}"

            bind r source-file ~/.config/tmux/tmux.conf \; \
                display-message "tmux config reloaded"

            bind -T copy-mode-vi v send-keys -X begin-selection
            bind -T copy-mode-vi C-v send-keys -X rectangle-toggle

            set -g status-interval 5
            set -g status-left-length 30
            set -g status-right-length 40
            set -g status-left "#[bold] #S "
            set -g status-right "%Y-%m-%d %H:%M "
            setw -g window-status-current-format \
                "#[bold] #I:#W#{?window_zoomed_flag, [Z],} "
        '';
    };
}
