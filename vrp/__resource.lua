resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description "RP module/framework"

ui_page "gui/index.html"

-- server scripts
server_scripts{ 
  "@mysql-async/lib/MySQL.lua",
  "lib/utils.lua",
  "base.lua",
  "_server/login.lua",
  "_server/player_data.lua",
  "_server/gui.lua",
  "_server/roles.lua",
  "_server/factions.lua",
  "_server/commands.lua",
  "_server/visa.lua",
  "_server/vehicles.lua",
  "_server/items.lua",
  "_server/inventory.lua",
  "_server/map.lua",
  "_server/money.lua",
  "_server/markets.lua",
  "_server/leader_menu.lua",
  "_server/police.lua",
  "_server/homes.lua",
  "_server/grills.lua",
  "_server/records.lua",
  "_server/jobs.lua",
  "_server/menu.lua",
  "_server/skins.lua",
  "_server/identity.lua",
  "_server/insurance.lua",
  "_server/payday.lua",
  "_server/licenses.lua"
}

-- _client scripts
client_scripts{
  "lib/utils.lua",
  "_client/Tunnel.lua",
  "_client/Proxy.lua",
  "_client/base.lua",
  "_client/login.lua",
  "_client/iplloader.lua",
  "_client/gui.lua",
  "_client/odometer.lua",
  "_client/survival.lua",
  "_client/map.lua",
  "_client/police.lua",
  "_client/vehicles.lua",
  "_client/hud.lua",
  "_client/carwash.lua",
  "_client/interior.lua",
  "_client/admin.lua",
  "_client/gates.lua",
  "_client/grills.lua",
  "_client/homes.lua",
  "_client/hours.lua",
  "_client/spectate.lua",
  "_client/safezone.lua"
}

-- _client files
files{
  "gui/index.html",
  "gui/design.css",
  "gui/main.js",
  "gui/hud.css",
  "gui/hud.js",
  "gui/login.css",
  "gui/login.js",
  "gui/ogrp.main.js",
  "gui/ogrp.menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/fonts/Pdown.woff",
  "gui/fonts/GOODTIME.ttf",
  "gui/fonts/GTA.woff"
}
