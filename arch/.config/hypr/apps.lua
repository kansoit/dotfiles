-- Personal application and window rules.
-- Overrides default 875x600 size for centered floating windows so TUIs
-- and presentation terminals have ample space (95 cols x 25 rows)
-- even with 14pt fonts, while fitting comfortably on 1.5x scaled laptop screens.

o.window({ tag = "floating-window" }, { size = { 1100, 670 } })

-- AS/400 (tn5250 sobre foot): abre siempre flotante y centrado
o.window({ class = "as400" }, {
  float = true,
  center = true,
})
