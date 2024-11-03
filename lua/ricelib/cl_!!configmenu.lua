RiceLib.URLMaterial.Create("rl_logo", "https://sv.wolf109909.top:62500/f/ede41dd0da3e4c4dbb3d/?dl=1")
RiceLib.Config.ConfigMenu = RiceLib.Config.ConfigMenu or {}

local function buildConfigEntrys(panel, nameSpace, category)
    local pageName = Format("%s_%s", nameSpace, category)

    if panel:GetPage(pageName) then
        panel:SwitchPage(pageName)

        return
    end

    local page = RiceUI.SimpleCreate({type = "rl_panel",
        Dock = FILL,

        ThemeNT = {
            Class = "NoDraw"
        },
    }, panel)
    panel:RegisterPage(pageName, page)
    panel:SwitchPage(pageName)

    for key, info in SortedPairs(RiceLib.Config.GetEntrysInCategory(nameSpace, category)) do
        local configEntry = RiceLib.Config.GetEntry(nameSpace, info.Key)

        local control = RiceUI.SimpleCreate({type = "rl_panel",
            Dock = TOP,
            Margin = {16, 16, 16, 0},
            h = 32,

            ThemeNT = {
                Class = "NoDraw"
            },

            ConfigEntry = configEntry,

            children = {
                {type = "label",
                    Dock = LEFT,

                    Text = info.DisplayName
                },

                {type = "rl_numberwang",
                    Dock = RIGHT,
                    w = 196,

                    Min = info.Min,
                    Max = info.Max,
                    Dec = info.Dec,
                    Step = info.Step,

                    Value = configEntry:GetValue(),
                    OnValueChanged = function(self, val)
                        configEntry:SetValue(val)
                    end
                }
            }
        }, page)
    end

    RiceUI.ApplyTheme(panel)
end

local function buildNavgationView()
    local tbl = {}

    for category, data in pairs(RiceLib.Config.ConfigMenu) do
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

    for nameSpace, _ in pairs(RiceLib.Config.GetEntrys()) do
        local choices = {}

        for _, category in ipairs(RiceLib.Config.GetCategorys(nameSpace)) do
            table.insert(choices, {category, function(panel)
                buildConfigEntrys(panel, nameSpace, category)
            end})
        end

        local nameSpaceInfo = RiceLib.Config.GetNameSpaceInfo(nameSpace) or {}

        table.insert(tbl, {"Category", nameSpaceInfo.DisplayName or nameSpace, choices})
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

                    Value = RiceLib.Config.Get(data.NameSpace, data.Key),

                    OnValueChanged = function(self, val)
                        RiceLib.Config.Set(data.NameSpace, data.Key, val)

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

                    Value = RiceLib.Config.Get(data.NameSpace, data.Key),

                    OnValueChanged = function(self, val)
                        RiceLib.Config.Set(data.NameSpace, data.Key, val)

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

                    Value = RiceLib.Config.Get(data.NameSpace, data.Key),

                    OnValueChanged = function(self, val)
                        RiceLib.Config.Set(data.NameSpace, data.Key, val)

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

                    Value = RiceLib.Config.Get(data.NameSpace, data.Key),

                    OnValueChanged = function(self, val)
                        RiceLib.Config.Set(data.NameSpace, data.Key, val)

                        if data.OnValueChange ~= nil then data.OnValueChange(val) end
                    end
                }
            }
        }, pnl)
    end,
}

function RiceLib.Config.RegisterConfig(category, name, choice)
    local returnChoice = choice

    if not isfunction(choice) then
        returnChoice = function(view)
            local pageName = Format("%s_%s", category, name)

            if view:GetPage(pageName) then
                view:SwitchPage(pageName)

                return
            end

            local panel = RiceUI.SimpleCreate({type = "rl_pane;",
                Dock = FILL,

                ThemeNT = {
                    Class = "NoDraw"
                }
            }, view)

            for _, data in ipairs(choice) do
                choiceBuilders[ data[1] ]( data, panel )
            end

            view:RegisterPage(name, panel)
            view:SwitchPage(name)
        end
    end

    RiceLib.Config.ConfigMenu[category] = RiceLib.Config.ConfigMenu[category] or {}
    RiceLib.Config.ConfigMenu[category][name] = returnChoice
end

function RiceLib.Config.RegisterConfig_SinglePage(name, choice)
    local returnChoice = choice

    if not isfunction(choice) then
        returnChoice = function(view)
            if view:GetPage(name) then
                view:SwitchPage(name)

                return
            end

            local panel = RiceUI.SimpleCreate({type = "rl_pane;",
                Dock = FILL,

                ThemeNT = {
                    Theme = "Modern",
                    Class = "NoDraw"
                }
            }, view)

            for _, data in ipairs(choice) do
                choiceBuilders[ data[1] ]( data, panel )
            end

            view:RegisterPage(name, panel)
            view:SwitchPage(name)
        end
    end

    RiceLib.Config.ConfigMenu[name] = {"Page", returnChoice}
end

function RiceLib.Config.RegisterCustomPage(name, func)
    RiceLib.Config.ConfigMenu[name] = {"Page", function(pnl)
        func(pnl)

        RiceUI.ApplyTheme(pnl)
    end}
end

function RiceLib.Config.OpenMenu()
    RiceLib.Config.MenuPanel = RiceUI.SimpleCreate({type = "rl_frame2",
        Center = true,
        Root = true,

        Title = "控制中心",

        ThemeNT = {
            Theme = "Modern",
            Class = "Frame",
            Style = "Acrylic"
        },

        children = {
            {type = "rl_navigation_view",
                Dock = TOP,
                h = 655,

                Choice = buildNavgationView()
            }
        },
    })
end

concommand.Add("rl_config", RiceLib.Config.OpenMenu)

list.Set("DesktopWindows", "Lib-Rice ControllCenter", {
    title = "控制中心",
    icon = "data/ricelib/materials/rl_logo.png",
    init = function()
        RunConsoleCommand("rl_config")
    end
})