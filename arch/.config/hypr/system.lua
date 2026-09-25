-- ~/.config/hypr/system.lua
-- Personal system window rules and dialog centering

-- 1. All floating windows must center automatically (prevents getting stuck under top bar)
o.window({ float = true }, { center = true })

-- 2. File pickers, dialogs and popups in English for user applications
o.window({
  class = "(drawio|DesktopEditors|DBeaver|org.jkiss.dbeaver.core.product|sublime_text|org.gnome.Nautilus)",
  title = "^(Open.*|Save.*|All Files|.*wants to [open|save].*|[C|c]hoose.*|Select.*|Export.*|Import.*|Preferences|Properties|Settings|New Connection.*|Database Drivers?|Driver Settings|Confirm.*|Alert.*|Error.*)",
}, {
  tag = "+floating-window",
})

-- 3. Specific DBeaver dialogs and wizards
o.window({
  class = "(DBeaver|org.jkiss.dbeaver.core.product)",
  title = "(Connection|Driver|Database|Execute|Browse|Filter|Profile|Preferences|Properties|Rename|Create|New.*)",
}, {
  tag = "+floating-window",
})

-- 4. Specific OnlyOffice (DesktopEditors) dialogs
o.window({
  class = "DesktopEditors",
  title = "(Options|Document Info|Protection|Find and Replace|Plugins|Settings|Insert.*|Color Picker|Font.*)",
}, {
  tag = "+floating-window",
})

-- 5. Specific draw.io popups and modal dialogs
o.window({
  class = "^drawio$",
  title = "^(Open.*|Save.*|Import.*|Export.*|Insert.*|Page Setup|Properties|Edit.*|Select.*)$",
}, {
  tag = "+floating-window",
})
