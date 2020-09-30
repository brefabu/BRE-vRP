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
config.spawn_death = {-240.37907409668,6323.8247070313,32.426189422607} -- CHANGE THIS COORD FOR DEATH SPAWN
```

Secondly, we need to config the roles ( `/vrp/cfg/roles.lua` ):
```lua
return { [1] = "Player", [2] = "Helper", [3] = "Moderator", [4] = "Administrator", [5] = "Developer", [6] = "Owner" }
-- CHANGE BY YOUR LIKE
```

Config the factions ( `/vrp/cfg/factions.lua` ):
```lua
return { [1] = "Player", [2] = "Helper", [3] = "Moderator", [4] = "Administrator", [5] = "Developer", [6] = "Owner" }
-- CHANGE BY YOUR LIKE
```

Config the vehicles ( `/vrp/cfg/vehicles.lua` ):
```lua
    ["tampa"] = {"Tampa", 4800000.0},
-- This is an example
```
The rest of configuration is similar enough to Old vRP.

### NOTE: Some of the scripts are written in Romanian.
