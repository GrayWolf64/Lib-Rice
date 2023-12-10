RL.Config = RL.Config or {}

file.CreateDir"ricelib/settings"

-- file based config
function RL.Config.LoadConfig(Config, Name, default)
    local root = "ricelib/settings/" .. Config
    local dir = root .. "/" .. Name .. ".json"

    if file.Exists(root, "DATA") and file.Exists(dir, "DATA") then
        local data = RL.table.Inherit(util.JSONToTable(file.Read(dir)), default)
        RL.Config.SaveConfig(Config, Name, data)

        return data
    else
        file.CreateDir(root)
        file.Write(dir, util.TableToJSON(default, true) or "")

        return default
    end
end

function RL.Config.SaveConfig(Config, Name, tbl)
    dir = "ricelib/settings/" .. Config .. "/" .. Name .. ".json"
    file.Write(dir, util.TableToJSON(tbl, true))
end

-- key based config
RL.Config.All = RL.Config.LoadConfig("ricelib", "config_manager", {})

function RL.Config.Set(NameSpace, Key, Value)
    RL.Config.All[NameSpace] = RL.Config.All[NameSpace] or {}
    RL.Config.All[NameSpace][Key] = Value
    RL.Config.SaveConfig("ricelib", "config_manager", RL.Config.All)
end

function RL.Config.Get(NameSpace, Key)
    if NameSpace == nil or Key == nil then return end

    RL.Config.All[NameSpace] = RL.Config.All[NameSpace] or {}

    return RL.Config.All[NameSpace][Key]
end

if SERVER then
    util.AddNetworkString("RL_Config_Command")
    RL.Net.RegisterCommandReceiver("RL_Config_Command", {})
else
    RL.URLMaterial.Create("rl_logo", "https://sv.wolf109909.top:62500/f/ede41dd0da3e4c4dbb3d/?dl=1")

    RL.Config.ConfigMenu = RL.Config.ConfigMenu or {}

    function RL.Config.GetForNavgationView()
        tbl = {}

        for category, data in pairs(RL.Config.ConfigMenu) do
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

    local choiceBuilders = {
        Bool = function(data, pnl)
            RiceUI.SimpleCreate({type = "rl_panel",
                UseNewTheme = true,
                Theme = {
                    ThemeName = "modern",
                    ThemeType = "NoDraw"
                },

                Dock = TOP,
                Margin = {16,16,16,0},
                h = 32,

                children = {
                    {type = "label", Text = data.DisplayText, Dock = LEFT},
                    {type = "switch",
                        Dock = RIGHT,
                        w = 65,

                        Value = RL.Config.Get(data.NameSpace, data.Key),

                        OnValueChanged = function(self, val)
                            RL.Config.Set(data.NameSpace, data.Key, val)

                            if data.OnValueChange ~= nil then data.OnValueChange(val) end
                        end
                    }
                }
            }, pnl)
        end,

        String = function(data, pnl)
            RiceUI.SimpleCreate({type = "rl_panel",
                UseNewTheme = true,
                Theme = {
                    ThemeName = "modern",
                    ThemeType = "NoDraw"
                },

                Dock = TOP,
                Margin = {16,16,16,0},
                h = 32,

                children = {
                    {type = "label", Text = data[2], Dock = LEFT},
                    {type = "entry",
                        Dock = RIGHT,
                        w = 400,

                        Value = RL.Config.Get(data.NameSpace, data.Key),

                        OnValueChanged = function(self, val)
                            RL.Config.Set(data.NameSpace, data.Key, val)

                            if data.OnValueChange ~= nil then data.OnValueChange(val) end
                        end
                    }
                }
            }, pnl)
        end,

        Number = function(data, pnl)
            RiceUI.SimpleCreate({type = "rl_panel",
                UseNewTheme = true,
                Theme = {
                    ThemeName = "modern",
                    ThemeType = "NoDraw"
                },

                Dock = TOP,
                Margin = {16,16,16,0},
                h = 32,

                children = {
                    {type = "label", Text = data[2], Dock = LEFT},
                    {type = "rl_numberwang",
                        Dock = RIGHT,
                        w = 200,

                        Value = RL.Config.Get(data.NameSpace, data.Key),

                        OnValueChanged = function(self, val)
                            RL.Config.Set(data.NameSpace, data.Key, val)

                            if data.OnValueChange ~= nil then data.OnValueChange(val) end
                        end
                    }
                }
            }, pnl)
        end,

        Slider = function(data, pnl)
            RiceUI.SimpleCreate({type = "rl_panel",
                UseNewTheme = true,
                Theme = {
                    ThemeName = "modern",
                    ThemeType = "NoDraw"
                },

                Dock = TOP,
                Margin = {16,16,16,0},
                h = 32,

                children = {
                    {type = "label", Text = data[2], Dock = LEFT},
                    {type = "slider",
                        Dock = RIGHT,
                        w = 200,

                        Value = RL.Config.Get(data.NameSpace, data.Key),

                        OnValueChanged = function(self, val)
                            RL.Config.Set(data.NameSpace, data.Key, val)

                            if data.OnValueChange ~= nil then data.OnValueChange(val) end
                        end
                    }
                }
            }, pnl)
        end,
    }

    function RL.Config.RegisterConfig(category, name, choice)
        local returnChoice = choice

        if not isfunction(choice) then
            returnChoice = function(pnl)
                pnl:Clear()

                for _, data in ipairs(choice) do
                    choiceBuilders[ data[1] ]( data, pnl )
                end
            end
        end

        RL.Config.ConfigMenu[category] = RL.Config.ConfigMenu[category] or {}
        RL.Config.ConfigMenu[category][name] = returnChoice
    end

    function RL.Config.RegisterConfig_SinglePage(name, choice)
        local returnChoice = choice

        if not isfunction(choice) then
            returnChoice = function(pnl)
                pnl:Clear()

                for _, data in ipairs(choice) do
                    choiceBuilders[ data[1] ]( data, pnl )
                end
            end
        end

        RL.Config.ConfigMenu[name] = {"Page", returnChoice}
    end

    function RL.Config.OpenMenu()
        RL.Config.MenuPanel = RiceUI.SimpleCreate({type = "rl_frame2",
            Center = true,
            Root = true,

            Title = "控制中心",

            children = {
                {type = "rl_navigation_view",
                    Dock = TOP,
                    h = 655,

                    Choice = RL.Config.GetForNavgationView()
                }
            },
        })
    end

    concommand.Add("rl_config", RL.Config.OpenMenu)

    list.Set("DesktopWindows", "Lib-Rice ControllCenter", {
        title = "控制中心",
        icon = "data/ricelib/materials/rl_logo.png",
        init = function()
            RunConsoleCommand("rl_config")
        end
    })
end