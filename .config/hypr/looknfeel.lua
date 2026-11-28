-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

hl.config({
    decoration = {
        blur = {
            enabled = true,
            popups = true,
            size = 3,
            passes = 2,
            vibrancy = 0.2,
            noise = 0.02,
            contrast = 1.0,
            brightness = 1.5,
        },
        rounding = 12,
        -- 4.0 = squircle (macOS continuous corners); 2.0 = circular
        rounding_power = 4.0,
        shadow = {
            enabled = true,
            range = 40,
            render_power = 2,
            color = "rgba(00000048)",
            color_inactive = "rgba(00000022)",
            offset = "0 8",
        },
    },
    general = {
        border_size = 1,
        col = {
            -- macOS-style: bright top edge fading out toward the bottom
            active_border = { colors = { "rgba(ffffff44)", "rgba(ffffff14)", "rgba(ffffff08)" }, angle = 45 },
            inactive_border = { colors = { "rgba(ffffff22)", "rgba(ffffff08)" }, angle = 50 },
        },
        gaps_in = 3,
        gaps_out = 5,
    },
})

hl.curve("fran", { type = "bezier", points = { { 0.25, 1 }, { 0, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("easeInOutCirc", { type = "bezier", points = { { 0.85, 0 }, { 0.15, 1 } } })
hl.curve("overshoot", { type = "bezier", points = { {0.5, 0.9}, {0.1, 1.1} } } )
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 50, dampening = 15 })

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3,
    bezier = "fran",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 8,
    bezier = "fran",
})

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.
