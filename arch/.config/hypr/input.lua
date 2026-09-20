-- Antigravity Input Setup
-- Keep only your personal input overrides here.
-- Loaded after Omarchy's default (/usr/share/omarchy/default/hypr/input.lua)

hl.config({
  input = {
    -- IMPORTANT KEYBOARD OVERRIDE
    --
    -- Omarchy's default input configuration includes:
    --   compose:caps,shift:both_capslock_cancel
    --
    -- `compose:caps` turns the physical Caps Lock key into a Compose key. It
    -- is not a plugin setting and it is not a shortcut/bind: it changes the
    -- role of that key at the XKB keyboard-layout level. As a result, the key
    -- no longer toggles the Caps Lock modifier and any Caps Lock indicator is
    -- correctly unable to report it as active.
    --
    -- This user override intentionally removes only `compose:caps`, so Caps
    -- Lock remains a normal Caps Lock key. It keeps
    -- `shift:both_capslock_cancel`, Omarchy's behavior that lets both Shift
    -- keys activate Caps Lock and a following lone Shift cancel it.
    --
    -- This line is independent of mero.caps-indicator: installing, updating,
    -- or removing that plugin does not add or remove this override. It lives
    -- here because this file is loaded after Omarchy's default input config.
    -- The bar indicator reads the logical lock state from Hyprland. A physical
    -- Logitech Caps Lock LED can still lag or remain out of sync when the
    -- lock is changed from another keyboard; that is a HID/firmware behavior,
    -- not a failure of this configuration or of the bar indicator.
    kb_options = "shift:both_capslock_cancel",

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
