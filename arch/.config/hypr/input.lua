-- Antigravity Input Setup
-- Keep only your personal input overrides here.
-- Loaded after Omarchy's default (/usr/share/omarchy/default/hypr/input.lua)

hl.config({
  input = {
    -- Explicitly set pointer scroll factor (default is 1.0)
    scroll_factor = 1.0,

    -- Handle high-resolution vs discrete wheel scrolling events (0: disable, 1: standard/default, 2: force)
    emulate_discrete_scroll = 1,
  },
})

-- Device-specific override for Logitech wireless mouse
hl.device({
  name = "logitech-m280/320/275-1",
  scroll_factor = 1.0,
})

-- Calibrate Ghostty terminal scroll speed:
-- Omarchy default throttles Ghostty down to 0.2 (1/5th speed).
-- Override to 1.5 for fast and responsive scrolling (matching Alacritty/kitty/foot):
o.window("com.mitchellh.ghostty", { scroll_touchpad = 1.5 })
