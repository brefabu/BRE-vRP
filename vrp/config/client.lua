-- client-side vRP configuration

local config = {}

config.iplload = true

config.voice_proximity = 30.0 -- default voice proximity (outside)
config.voice_proximity_vehicle = 5.0
config.voice_proximity_inside = 9.0

config.gui = {
  anchor_minimap_width = 260,
  anchor_minimap_left = 60,
  anchor_minimap_bottom = 213
}

-- gui controls (see https://wiki.fivem.net/wiki/Controls)
-- recommended to keep the default values and ask players to change their keys
config.controls = {
  phone = {
    -- PHONE CONTROLS
    up = {3,172},
    down = {3,173},
    left = {3,174},
    right = {3,175},
    select = {3,176},
    cancel = {3,177},
    open = {3,311}, -- K to open the menu
  },
  request = {
    yes = {1,166}, -- Numbpad+
    no = {1,167} -- Numbpad-
  }
}

-- disable menu if handcuffed
config.handcuff_disable_menu = true

-- when health is under the threshold, player is in coma
-- set to 0 to disable coma
config.coma_threshold = 120

-- maximum duration of the coma in minutes
config.coma_duration = 5

-- if true, a player in coma will not be able to open the main menu
config.coma_disable_menu = false

-- see https://wiki.fivem.net/wiki/Screen_Effects
config.coma_effect = "DeathFailMPIn"

-- if true, vehicles can be controlled by others, but this might corrupts the vehicles id and prevent players from interacting with their vehicles
config.vehicle_migration = true

return config