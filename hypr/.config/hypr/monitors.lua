-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "highrr", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

local function apply_aw3423dwf_mode(monitor)
  if not monitor or not monitor.description:find("AW3423DWF", 1, true) then return end

  local full_panel = false
  for _, mode in ipairs(monitor.available_modes) do
    if mode.width == 3440 and mode.height == 1440 then
      full_panel = true
      break
    end
  end

  hl.monitor({
    output = monitor.name,
    mode = full_panel and "highrr" or "preferred",
    position = "auto",
    scale = omarchy_monitor_scale,
  })
end

hl.on("monitor.added", apply_aw3423dwf_mode)
hl.on("config.reloaded", function()
  for _, monitor in ipairs(hl.get_monitors()) do apply_aw3423dwf_mode(monitor) end
end)
