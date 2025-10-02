RiceLib.Config.ConfigMenu = RiceLib.Config.ConfigMenu or {}

local function createConfigEntry(entry, parent)
    local control = RiceUI.SimpleCreate({
        widget = Format("RiceLib_ConfigManager_%s", entry.Type),
        Entry = entry
    }, parent)
end

local function buildConfigEntrys(panel, nameSpace, category)
    local pageName = Format("%s_%s", nameSpace, category)

    if panel:GetPage(pageName) then
        if input.IsShiftDown() then
            panel:GetPage(pageName):Remove()
        else
            panel:SwitchPage(pageName)

            return
        end
    end

    local page = RiceUI.SimpleCreate({
        type = "rl_scrollpanel",
        Dock = FILL,

        ThemeNT = {
            Class = "NoDraw"
        },
    }, panel)
    panel:RegisterPage(pageName, page)
    panel:SwitchPage(pageName)

    local subCategorys = {}
    for key, info in SortedPairs(RiceLib.Config.GetEntrysInCategory(nameSpace, category)) do
        local configEntry = RiceLib.Config.GetEntry(nameSpace, info.Key)

        local subCategory = configEntry.SubCategory
        if subCategory then
            if not subCategorys[subCategory] then
                subCategorys[subCategory] = {}
            end

            table.insert(subCategorys[subCategory], {nameSpace, info.Key})

            continue
        end

        createConfigEntry(configEntry, page)
    end

    local Spacers = {}
    for subCategory, infos in SortedPairs(subCategorys) do
        local spacer = Spacers[subCategory]

        if not spacer then
            spacer = RiceUI.SimpleCreate({
                type = "rl_panel",
                Dock = TOP,
                Margin = {0, 16, 0, 0},

                ThemeNT = {
                    Class = "NoDraw"
                },

                children = {
                    {
                        type = "rl_button",
                        Dock = TOP,
                        Margin = {12, 0, 16, 0},
                        h = 32,

                        ThemeNT = {
                            Style = "ComboChoice"
                        },

                        Selected = true,
                        Text = subCategory
                    }
                }
            }, page)
        end

        for _, info in SortedPairsByMemberValue(infos, 2) do
            local nameSpace, key = unpack(info)
            local configEntry = RiceLib.Config.GetEntry(nameSpace, key)

            createConfigEntry(configEntry, spacer)
        end

        spacer:FitContents_Vertical()
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
        RiceUI.SimpleCreate({
            type = "rl_panel",
            UseNewTheme = true,
            Theme = {
                ThemeName = "modern",
                ThemeType = "NoDraw"
            },

            Dock = TOP,
            Margin = {16, 16, 16, 0},
            h = 32,

            children = {
                {type = "label", Text = data.DisplayText, Dock = LEFT},
                {
                    type = "switch",
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
        RiceUI.SimpleCreate({
            type = "rl_panel",
            UseNewTheme = true,
            Theme = {
                ThemeName = "modern",
                ThemeType = "NoDraw"
            },

            Dock = TOP,
            Margin = {16, 16, 16, 0},
            h = 32,

            children = {
                {type = "label", Text = data[2], Dock = LEFT},
                {
                    type = "entry",
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
        RiceUI.SimpleCreate({
            type = "rl_panel",
            UseNewTheme = true,
            Theme = {
                ThemeName = "modern",
                ThemeType = "NoDraw"
            },

            Dock = TOP,
            Margin = {16, 16, 16, 0},
            h = 32,

            children = {
                {type = "label", Text = data[2], Dock = LEFT},
                {
                    type = "rl_numberwang",
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
        RiceUI.SimpleCreate({
            type = "rl_panel",
            UseNewTheme = true,
            Theme = {
                ThemeName = "modern",
                ThemeType = "NoDraw"
            },

            Dock = TOP,
            Margin = {16, 16, 16, 0},
            h = 32,

            children = {
                {type = "label", Text = data[2], Dock = LEFT},
                {
                    type = "slider",
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

            local panel = RiceUI.SimpleCreate({
                type = "rl_pane;",
                Dock = FILL,

                ThemeNT = {
                    Class = "NoDraw"
                }
            }, view)

            for _, data in ipairs(choice) do
                choiceBuilders[data[1]](data, panel)
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

            local panel = RiceUI.SimpleCreate({
                type = "rl_pane;",
                Dock = FILL,

                ThemeNT = {
                    Theme = "Modern",
                    Class = "NoDraw"
                }
            }, view)

            for _, data in ipairs(choice) do
                choiceBuilders[data[1]](data, panel)
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
    local color = "white"

    if RiceUI.ThemeNT.IsDarkMode() then
        color = "black"
    end

    RiceLib.Config.MenuPanel = RiceUI.SimpleCreate({
        type = "rl_frame2",
        Center = true,
        Root = true,

        Title = "控制中心",

        ThemeNT = {
            Theme = "Modern",
            Class = "Frame",
            Style = "Acrylic",
            Color = color
        },

        children = {
            {
                type = "rl_navigation_view",
                Dock = TOP,
                h = 655,

                Choice = buildNavgationView()
            }
        },
    })
end

hook.Add("RiceLib_ConfigManager_ValueChanged", "RiceLib_ConfigMenu_Darkmode", function(nameSpace, key, value)
    if nameSpace ~= "ricelib" then return end
    if key ~= "ThemeNT_DarkMode" then return end
    if not IsValid(RiceLib.Config.MenuPanel) then return end

    local color = "white"

    if RiceUI.ThemeNT.IsDarkMode() then
        color = "black"
    end

    RiceLib.Config.MenuPanel.ThemeNT.Color = color

    RiceUI.ThemeNT.ApplyTheme(RiceLib.Config.MenuPanel)
end)

concommand.Add("rl_config", RiceLib.Config.OpenMenu)

list.Set("DesktopWindows", "Lib-Rice ControllCenter", {
    title = "控制中心",
    icon = "rl_icons/ricelib_controlcenter.png",
    init = function()
        RunConsoleCommand("rl_config")
    end
})
