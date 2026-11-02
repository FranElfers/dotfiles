-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- open zed
o.bind("SUPER + F1", "Zed", "zeditor")

-- Rebind PRINT to copy screenshot to clipboard without saving to disk
hl.unbind("PRINT")
o.bind("PRINT", "Screenshot to clipboard", "omarchy capture screenshot smart copy")


-- SUPER+L: toggle dwindle <-> floating (new windows open floating) per workspace.
hl.unbind("SUPER + L")
o.bind("SUPER + L", "Toggle floating-by-default workspace", os.getenv("HOME") .. "/.config/hypr/scripts/workspace-float-toggle")

local float_dir = os.getenv("HOME") .. "/.local/state/omarchy/floating-workspaces/"

-- Per-app geometry of floating windows, remembered across closes.
-- File format: class<TAB>x<TAB>y<TAB>w<TAB>h per line.
-- ponytail: no monitor-layout check; delete the file if windows land off-screen.
local geo_file = os.getenv("HOME") .. "/.local/state/omarchy/window-geometry.tsv"
local geo = {}
local geo_in = io.open(geo_file)
for line in (geo_in and geo_in:lines() or function() end) do
  local c, x, y, w, h = line:match("^(.-)\t(%-?%d+)\t(%-?%d+)\t(%d+)\t(%d+)$")
  if c then geo[c] = { tonumber(x), tonumber(y), tonumber(w), tonumber(h) } end
end
if geo_in then geo_in:close() end

hl.on("window.open", function(w)
  local f = w.workspace and io.open(float_dir .. w.workspace.id)
  if f then
    f:close()
    hl.dispatch(hl.dsp.window.float({ action = "enable", window = w }))
  end
  local g = geo[w.class]
  if g and w.floating then
    hl.dispatch(hl.dsp.window.resize({ x = g[3], y = g[4], exact = true, window = w }))
    hl.dispatch(hl.dsp.window.move({ x = g[1], y = g[2], window = w }))
  end
end)

hl.on("window.close", function(w)
  if not (w.floating and w.class ~= "" and w.class:find("^[^\t\n]+$")) then return end
  geo[w.class] = { w.at.x, w.at.y, w.size.x, w.size.y }
  local out = io.open(geo_file, "w")
  for c, v in pairs(geo) do out:write(string.format("%s\t%d\t%d\t%d\t%d\n", c, v[1], v[2], v[3], v[4])) end
  out:close()
end)
