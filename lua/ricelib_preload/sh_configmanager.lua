RL.Config = RL.Config or {}

function RL.Config.LoadConfig(Config,Name,default)
    local root = "ricelib/settings/" .. Config
    local dir = "ricelib/settings/" .. Config .. "/" .. Name .. ".json"

    if file.Exists(root,"DATA") and file.Exists(dir,"DATA") then
        local data = RL.table.Inherit(util.JSONToTable(file.Read(dir)),default)
        RL.Config.SaveConfig(Config,Name,data)

        return data
    else
        file.CreateDir(root)
        file.Write(dir,util.TableToJSON(default,true) or "")

        return default
    end
end

function RL.Config.SaveConfig(Config,Name,tbl)
    dir = "ricelib/settings/" .. Config .. "/" .. Name .. ".json"

    file.Write(dir,util.TableToJSON(tbl,true))
end

if SERVER then
    util.AddNetworkString("RL_Config_Command")

    RL.Net.AddCommandReceiver("RL_Config_Command", {})
else
    RL.Config.All = RL.Config.All or {}

    function RL.Config.GetForNavgationView()
        tbl = {}

        for category, data in pairs(RL.Config.All) do
            if data[1] == "Page" then
                table.insert(tbl, {"Page", category, data[2]})

                continue
            end

            local choice = {}

            for name, func in pairs(data) do
                table.insert(choice, {name, func})
            end

            table.insert(tbl, {"Category", category, choice})
        end

        return tbl
    end

    function RL.Config.RegisterConfig(category, name, func)
        RL.Config.All[category] = RL.Config.All[category] or {}
        RL.Config.All[category][name] = func
    end

    function RL.Config.RegisterConfig_SinglePage(name, func)
        RL.Config.All[name] = RL.Config.All[name] or {}

        RL.Config.All[name][1] = "Page"
        RL.Config.All[name][2] = func
    end

    function RL.Config.OpenMenu()
        RL.Config.MenuPanel = RiceUI.SimpleCreate({type = "rl_frame2",
            Center = true,
            Root = true,

            Title = "设置",

            children = {
                {type = "rl_navigation_view", Dock = TOP, h = 655,
                    Choice = RL.Config.GetForNavgationView()
                }
            }
        })
    end

    concommand.Add("rl_config", RL.Config.OpenMenu)

    concommand.Add("rl_config_createExample", function()
        RL.Config.RegisterConfig_SinglePage("Example_SinglePage", function() end)

        RL.Config.RegisterConfig("Example", "Server", function() end)
        RL.Config.RegisterConfig("Example", "Client", function() end)
        RL.Config.RegisterConfig("Example", "Custom", function() end)

        RL.Config.RegisterConfig("Example2", "Server", function() end)
        RL.Config.RegisterConfig("Example2", "Client", function() end)
        RL.Config.RegisterConfig("Example2", "Custom", function() end)
    end)
end