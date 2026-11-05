-- ~/.config/hypr/system.lua
-- Personal system window rules

-- 1. File pickers, dialogs and popups in English for user applications
o.window({
  class = "(drawio|DesktopEditors|DBeaver|org.jkiss.dbeaver.core.product|sublime_text|org.gnome.Nautilus)",
  title = "^(Open.*|Save.*|All Files|.*wants to [open|save].*|[C|c]hoose.*|Select.*|Export.*|Import.*|Preferences|Properties|Settings|New Connection.*|Database Drivers?|Driver Settings|Confirm.*|Alert.*|Error.*)",
}, {
  tag = "+floating-window",
})

-- 2. Specific DBeaver dialogs and wizards
o.window({
  class = "(DBeaver|org.jkiss.dbeaver.core.product)",
  title = "(Connection|Driver|Database|Execute|Browse|Filter|Profile|Preferences|Properties|Rename|Create|New.*)",
}, {
  tag = "+floating-window",
})

-- 3. Specific OnlyOffice (DesktopEditors) dialogs
o.window({
  class = "DesktopEditors",
  title = "(Options|Document Info|Protection|Find and Replace|Plugins|Settings|Insert.*|Color Picker|Font.*)",
}, {
  tag = "+floating-window",
})

-- 4. Specific draw.io popups and modal dialogs
o.window({
  class = "^drawio$",
  title = "^(Open.*|Save.*|Import.*|Export.*|Insert.*|Page Setup|Properties|Edit.*|Select.*)$",
}, {
  tag = "+floating-window",
})

-- 5. Generic placement guard for XWayland floating windows.
--    X11 apps often ask for 0,0, which Hyprland honors literally: the window
--    lands under the bar (Zoom file pickers, OnlyOffice print and save
--    prompts). Some (Java/AWT, e.g. the jt400 "Signon to the System" dialog)
--    even move themselves off every monitor right after mapping. Measured on
--    oma: positions are final at window.open except Java, which moved within
--    16 ms. Instead of fixed delays (they depend on machine load), every
--    floating XWayland window is watched each frame for WATCH_MS and centered
--    in the usable area of its monitor whenever its top-left corner sits under
--    the reserved area or outside every monitor, the way Hyprland already
--    centers native Wayland dialogs. Windows that open well placed are never
--    touched. New floating windows (native too) are also raised, and kept on
--    top during the same watch while they hold the focus, so a dialog does not
--    open hidden behind a sibling dialog of the same app.
do
  local TICK_MS = 16
  local WATCH_MS = 1000
  local MAX_FIXES = 5

  local function pair(v)
    if type(v) ~= "table" then
      return nil, nil
    end
    return v.x or v[1], v.y or v[2]
  end

  -- Logical geometry of a monitor and its usable area (minus reserved space).
  local function geometry(m)
    local scale = m.scale or 1
    local w, h = (m.width or 0) / scale, (m.height or 0) / scale
    if (m.transform or 0) % 2 == 1 then
      w, h = h, w
    end
    local r = m.reserved or {}
    local left = r.left or r[1] or 0
    local top = r.top or r[2] or 0
    local right = r.right or r[3] or 0
    local bottom = r.bottom or r[4] or 0
    local mx, my = m.x or 0, m.y or 0
    return {
      x = mx, y = my, w = w, h = h,
      ux = mx + left, uy = my + top, uw = w - left - right, uh = h - top - bottom,
    }
  end

  local function monitor_at(x, y)
    for _, m in ipairs(hl.get_monitors() or {}) do
      local g = geometry(m)
      if x >= g.x and x < g.x + g.w and y >= g.y and y < g.y + g.h then
        return m
      end
    end
    return nil
  end

  local function focused_monitor()
    for _, m in ipairs(hl.get_monitors() or {}) do
      if m.focused then
        return m
      end
    end
    return nil
  end

  -- Relative offset that centers a misplaced window, or nil if it is fine.
  local function correction(w)
    if not w.floating or not w.xwayland or (w.fullscreen or 0) ~= 0 then
      return nil
    end
    local x, y = pair(w.at)
    local sw, sh = pair(w.size)
    if not x or not sw or sw == 0 then
      return nil
    end

    local m = monitor_at(x, y)
    if m and y >= geometry(m).uy then
      return nil
    end
    -- Under the bar: its own monitor. Off every monitor: the window's (or the
    -- focused) monitor.
    m = m or w.monitor or focused_monitor()
    if not m then
      return nil
    end

    local g = geometry(m)
    local tx = g.ux + math.max(0, math.floor((g.uw - sw) / 2))
    local ty = g.uy + math.max(0, math.floor((g.uh - sh) / 2))
    return tx - x, ty - y
  end

  -- One watch step: center the window if misplaced (XWayland only) and, while
  -- it holds the focus, keep it on top. Seen once on oma: a DBeaver error
  -- dialog got the focus but stayed drawn behind its sibling dialog. Raising
  -- only the focused window never fights a click on another one.
  -- Returns: moved (bool), gone (bool).
  local function step(address, fixes)
    local w = hl.get_window("address:" .. address)
    if not w then
      return false, true
    end

    local active = hl.get_active_window()
    if active and active.address == address then
      hl.dispatch(hl.dsp.window.bring_to_top({ window = "address:" .. address }))
    end

    if fixes >= MAX_FIXES then
      return false, false
    end
    local dx, dy = correction(w)
    if not dx then
      return false, false
    end
    hl.dispatch(hl.dsp.window.move({ x = dx, y = dy, relative = true, window = "address:" .. address }))
    return true, false
  end

  hl.on("window.open", function(window)
    if not window.floating then
      return
    end
    local address = window.address
    hl.dispatch(hl.dsp.window.bring_to_top({ window = "address:" .. address }))

    local moved = step(address, 0)
    local fixes = moved and 1 or 0
    local elapsed = 0
    local timer
    timer = hl.timer(function()
      elapsed = elapsed + TICK_MS
      local fixed, gone = step(address, fixes)
      if fixed then
        fixes = fixes + 1
      end
      if gone or elapsed >= WATCH_MS then
        timer:set_enabled(false)
      end
    end, { type = "repeat", timeout = TICK_MS })
  end)
end
