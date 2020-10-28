local MySQLSync = module("mysql-async", "lib/MySQL")

local MySQLCommands = {}
function MySQL.createCommand(name, command)
  if not MySQLCommands[name] then
      MySQLCommands[name] = command
  end
end

function MySQL.execute(name, args, cb)
  MySQLSync.ready(function()
      if MySQLCommands[name] then
          local args2 = {}
          if args then
              for k, v in pairs(args) do
                  args2['@'..k] = v
              end
          end
          MySQLSync.Sync.execute(MySQLCommands[name], args2)
          if cb then
              local task = Task(cb)
              task({})
          end
      else
          print("^1MySQL: error the command "..name.." doesn't exist")
      end
  end)
end

function MySQL.query(name, args, cb)
  MySQLSync.ready(function()
    if MySQLCommands[name] then
      local args2 = {}
      if args then
          for k, v in pairs(args) do
              args2['@'..k] = v
          end
      end
      if cb then
          local task = Task(cb)
          local rws = MySQLSync.Sync.fetchAll(MySQLCommands[name], args2)
          task({rws})
      else
        MySQLSync.Sync.execute(MySQLCommands[name], args2)
      end
    else
        print("^1MySQL: error the command "..name.." doesn't exist")
    end
  end)
end

return MySQL