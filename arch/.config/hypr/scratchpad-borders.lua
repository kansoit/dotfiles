-- Generado por setup-scratchpad-borders.sh.
-- Se lee la paleta de nuevo en cada recarga de Hyprland/cambio de tema.
local path = os.getenv("HOME") .. "/.local/state/omarchy/current/theme/colors.toml"
local file = io.open(path, "r")
if not file then return end
local colors = {}
for line in file:lines() do
  local key, value = line:match([=[^%s*([%w_]+)%s*=%s*["']#(%x+)["']]=])
  if key and #value == 6 then colors[key] = value:lower() end
end
file:close()
-- Preferir amarillo del tema; evitar el mismo color que el acento habitual.
local selected
for _, key in ipairs({"yellow", "magenta", "cyan", "green", "red", "foreground"}) do
  if colors[key] and colors[key] ~= colors.accent and colors[key] ~= colors.background then
    selected = colors[key]
    break
  end
end
if not selected then return end
-- Mismo tono sin foco, mezclado con el fondo del tema para atenuarlo.
local inactive = selected
if colors.background then
  local channels = {}
  for i = 1, 5, 2 do
    local fg = tonumber(selected:sub(i, i + 1), 16)
    local bg = tonumber(colors.background:sub(i, i + 1), 16)
    channels[#channels + 1] = string.format("%02x", math.floor(fg * 0.65 + bg * 0.35 + 0.5))
  end
  inactive = table.concat(channels)
end
o.window({ workspace = "special:scratchpad" }, {
  border_color = "rgb(" .. selected .. ") rgb(" .. inactive .. ")",
})
