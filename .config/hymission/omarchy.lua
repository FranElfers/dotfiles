-- Hymission: config personal. Reemplaza omarchy/defaults.lua y bindings.json
-- del plugin; se aplica después de cargar Hymission y en cada recarga.
if not (hl.plugin and hl.plugin.hymission) then return end

-- toggle() sin scope muestra solo el workspace actual.
hl.config({ plugin = { hymission = { only_active_workspace = 1 } } })

-- Super solo (tocar y soltar): Mission Control. Al ser bind de release,
-- Hyprland no lo dispara si se apretó otra tecla con Super (Super+1, etc.).
-- Super+Tab queda con el "Next workspace" de Omarchy.
hl.bind("SUPER + SUPER_L", hl.plugin.hymission.toggle, { description = "Mission Control", release = true })

-- Super+Shift+Tab: todos los workspaces (reemplaza "Previous workspace").
hl.unbind("SUPER + SHIFT + TAB")
hl.bind("SUPER + SHIFT + TAB", function() hl.plugin.hymission.toggle("forceall") end,
    { description = "Mission Control (all workspaces)" })

-- Swipe vertical de 3 dedos: todos los workspaces.
hl.plugin.hymission.gesture({ fingers = 3, direction = "vertical", action = "toggle", args = "forceall" })
