-- Extra autostart processes.
-- o.launch_on_start("my-service")
o.launch_on_start("keepassxc")

-- Obsidian: inicio automático en el escritorio 3.
hl.on("hyprland.start", function()
  hl.exec_cmd(o.launch("obsidian"), { workspace = "3 silent" })
end)
