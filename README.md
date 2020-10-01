# Modified vRP by BRE Faby

`Firstly, this project it's made long time ago, but I decided to post it now. And yes, it's optimized!`

- [x] MySQL-ASync
```
The modification was made by PlexAlex.

> How it works?

It uses the basic MySQL-ASync functions, but it has adapted functions to vRP_MySQL format.

> It is better?

Basically yes, but there are better choices.
```

- [x] vRP
```
The modification was made by BRE Faby.

> What's changed?

It uses a new database format, easily to use. And modifified base system like: Inventory, Vehicles, Groups and many more.

Now all the database is autogenerating.

Payday is now server-sided for preventing LUA Executions.

> What's new?
Integrated Login System based on SHA256 encryption, a very secure one, for many accounts, and global ban per identifiers.

Vehicle parking it's a native function now!

Added Visa and Driver Licenses per type of players.

Added factions with an on duty system, that adds the uniform!
```
- [x] vRP Scripts
```
A new showroom and a new gunshop are waiting for you!
```

- [x] Documentation for setting up the server

* Setting up the database:

Add this line in server.cfg and replace with your database connection credentials.
```lua
set mysql_connection_string "server=localhost;database=vrp;userid=root;password="
```

* Configuring the server:

Every configuration is in `/vrp/cfg`.

Firstly, we need to set up the first spawn-zone and the death spawn-zone ( `/vrp/cfg/player_state.lua` ):
```lua
config.spawn_position = {-330.58148193359,6149.779296875,32.30689239502} -- CHANGE THIS COORD FOR FIRST SPAWN
```

Secondly, we need to config the roles ( `/vrp/cfg/roles.lua` ):
```lua
return { [1] = "Player", [2] = "Helper", [3] = "Moderator", [4] = "Administrator", [5] = "Developer", [6] = "Owner" }
-- CHANGE BY YOUR LIKE
```

Config the factions ( `/vrp/cfg/factions.lua` ):
```luafactions = {
  ["Police"] = {
    _coords = {
      {445.55010986328,-984.70275878906,30.689599990845},
      {-445.90008544922,6013.9404296875,31.716373443604}
    },
    _offices = {
      {448.12948608398,-973.21948242188,30.689599990845},
      {-441.23086547852,6004.388671875,31.716438293457}
    },
    _type = "Departament",
    _chat = " <span style='color:rgb(0, 157, 236)'>Police</span> ",
    _blip_id = 60,
    _blip_color = 3,
    _leader = "Leader Police",
    _ranks = {
      "Agent",
      "Rutier Agent",
      "Frontier Agent",
      "Swat Agent",
    },
    _salary = {
      ["Leader Police"] = 7000 + math.random(500,1000),
      ["Swat Agent"] = 5000 + math.random(500,1000),
      ["Frontier Agent"] = 4200 + math.random(500,1000),
      ["Rutier Agent"] = 4000 + math.random(500,1000),
      ["Agent"] = 3000 + math.random(500,1000),
    }
  },
  ["EMS"] = {
    _coords = {
      {342.86727905273,-1398.0349121094,32.509269714355},
      {-242.41955566406,6325.9760742188,32.426189422607},
      {1839.5577392578,3672.3471679688,34.276710510254}
    },
    _type = "Departament",
    _chat = " <span style='color:rgb(255, 200, 200)'>EMS</span> ",
    _blip_id = 61,
    _blip_color = 3,
    _leader = "Director",
    _ranks = {
      "Paramedic",
      "Specialist",
      "Surgeon",
    },
    _salary = {
      ["Director"] = 10000  + math.random(100,650),
      ["Surgeon"] = 7200  + math.random(100,650),
      ["Specialist"] = 7000  + math.random(100,650),
      ["Paramedic"] = 6500  + math.random(100,650),
    }
  }
}
-- CHANGE BY YOUR LIKE
```

Config the vehicles ( `/vrp/cfg/vehicles.lua` ):
```lua
    ["tampa"] = {"Tampa", 4800000.0},
-- This is an example
```
The rest of configuration is similar enough to Old vRP.

### NOTE: Some of the scripts are written in Romanian.
