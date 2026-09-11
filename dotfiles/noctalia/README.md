# Noctalia configuration

Noctalia automatically merges every top-level `*.toml` file in this directory.

- `bar.toml`: bar layout and bar-widget settings
- `control-center.toml`: Control Center shortcuts
- `shell.toml`: shell behavior, surfaces, and widget feature toggles
- `services.toml`: idle, brightness, weather, location, monitoring, and notifications
- `plugins.toml`: plugin sources, enabled plugins, and plugin settings
- `theme.toml`: palette selection and generated application templates
- `wallpaper.toml`: wallpaper directory and portable default wallpaper

Keep portable intent and feature toggles here. In particular,
`lockscreen_widgets.enabled` belongs in `shell.toml`.

Noctalia's GUI-managed `~/.local/state/noctalia/settings.toml` is intentionally
not managed by Nix. It owns machine-specific lock-screen layout data such as
output names, logical dimensions, coordinates, widget order, and per-widget
presentation. Noctalia may serialize redundant defaults there when the editor
is opened; the state layer takes precedence over this directory.
