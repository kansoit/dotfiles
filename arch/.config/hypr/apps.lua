-- Personal application and window rules.
-- Overrides default 875x600 size for centered floating windows so TUIs
-- and presentation terminals have ample space (95 cols x 25 rows)
-- even with 14pt fonts, while fitting comfortably on 1.5x scaled laptop screens.

o.window({ tag = "floating-window" }, { size = { 1100, 670 } })

-- IBM i Access Client Solutions (Java Swing / AWT bajo XWayland)
-- Centrar todas las ventanas de ACS (License Agreement, LaunchPad, Emulador 5250)
o.window("com-ibm-iaccess-.*", { float = true, center = true })
