-- define items, see the Inventory API on github

local config = {}
-- see the manual to understand how to create parametric items
-- idname = {name or genfunc, description or genfunc, genfunc choices or nil, weight or genfunc}
-- a good practice is to create your own item pack file instead of adding items here
config.items = {
  ["card"] = {"Card", "", nil, 0.1},
  ["harness"] = {"Harness", "For drugs.", nil, 0.4},
  ["benzoilmetilecgonina"] = {"Benzo", "For drugs.", nil, 0.3},
  ["seeds"] = {"Seeds", "For drugs.", nil, 0.2},
  ["opium"] = {"Opium", "For drugs.", nil, 0.4},
}

-- load more items function
local function load_item_pack(name)
  local items = module("config/item/"..name)
  if items then
    for k,v in pairs(items) do
      config.items[k] = v
    end
  else
    print("[vRP] item pack ["..name.."] not found")
  end
end

-- PACKS
load_item_pack("required")
load_item_pack("food")
load_item_pack("drugs")

return config
