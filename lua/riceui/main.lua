RiceUI          = RiceUI or {}
RiceUI.RootName = "main"

file.CreateDir"riceui"
file.CreateDir"riceui/web_image"

local elements = {}
local UI_Elements = {}

RL.IO.LoadFiles(elements, "riceui/elements")

--- Create UI Elements
-- @section CreateElement
function RiceUI.SimpleCreate(data, parent, root)
    if not elements[data.type] then elements.error.Create(data, parent) return end
    if data.ShouldCreate and not data.ShouldCreate() then return end

    local panel = elements[data.type].Create(data, parent)

    root = root or panel

    RiceUI.DoProcess(panel)
    RiceUI.ApplyMixins(panel)

    if data.children then RiceUI.Create(data.children, panel, root) end
    if data.OnCreated then data.OnCreated(panel) end
    if panel.ChildCreated then panel:ChildCreated() end

    if data.ID then
        if not IsValid(parent) then return panel end

        -- Remove this soon
        parent.Elements = parent.Elements or {}
        parent.Elements[data.ID] = panel

        root.RiceUI_Elements = root.RiceUI_Elements or {}
        root.RiceUI_Elements[data.ID] = panel
    end

    table.insert(UI_Elements, panel)

    return panel
end

function RiceUI.Create(tab, parent, root)
    local elements = {}

    for _, data in ipairs(tab) do
        local panel = RiceUI.SimpleCreate(data, parent, root)
        table.insert(elements, panel)
    end

    return elements
end

--- Handle generic parameters
-- @section UniProcess
local uniProcess = uniProcess or {}

function RiceUI.DoProcess(panel)
    if not panel.RiceUI_Data then return end

    for name,data in pairs(panel.RiceUI_Data) do
        if uniProcess[name] == nil then continue end

        local processor
        if istable(uniProcess[name]) then
            processor = uniProcess[name][panel.ProcessID]
        else
            processor = uniProcess[name]
        end

        if not processor then continue end
        processor(panel, data)
    end
end

function RiceUI.DefineUniProcess(name,data)
    uniProcess[name] = data
end

RL.IncludeDir("riceui/uniprocess", true)

RiceUI.Prefab = {}
RL.IncludeDir("riceui/prefabs", true)
RL.IncludeDir("riceui/modules", true, true)

concommand.Add("riceui_reload", function()
    RL.IO.LoadFiles(elements, "riceui/elements")
    RL.IO.LoadFiles(uniProcess, "riceui/uniprocess")
    RiceUI.ReloadThemes()
end)

concommand.Add("riceui_panic", function()
    for _, panel in ipairs(UI_Elements) do
        if IsValid(panel) then
            panel:Remove()
        end
    end

    UI_Elements = {}
end)

concommand.Add("riceui_elements", function()
    PrintTable(elements)
end)

concommand.Add("riceui_all", function()
    PrintTable(UI_Elements)
end)

concommand.Add("riceui_prefabs", function()
    RiceUI.SimpleCreate({type = "rl_frame",
        Text = "Examples",
        Center = true,
        Root = true,
        Alpha = 0,
        w = 400,
        h = 600,

        UseNewTheme = true,
        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_Frame",
            Color = "black1",
            TextColor = "black1",
            Shadow = true,
        },

        Anim = {
            {
                type = "alpha",
                time = 0.075,
                alpha = 255
            }
        },

        children = {
            {type = "scrollpanel",
                ID = "ScrollPanel",
                x = 10,
                y = 40,
                w = 380,
                h = 550,
                OnCreated = function(panel)
                    for k, v in SortedPairs(RiceUI.Prefab) do
                        panel:AddItem(RiceUI.SimpleCreate({type = "rl_button",
                            Dock = TOP,
                            h = 50,
                            Margin = {0, 0, 5, 5},
                            Text = k,

                            Theme = {
                                ThemeType = "Button",
                                ThemeName = "modern_rect",
                                Color = "white"
                            },

                            DoClick = function() RiceUI.Prefab[k]({}) end
                        }, panel))

                        panel:AddItem(RiceUI.SimpleCreate({type = "rl_button",
                            Dock = TOP,
                            h = 50,
                            Margin = {0, 0, 5, 5},
                            Text = k .. " Dark",

                            Theme = {
                                ThemeType = "Button",
                                ThemeName = "modern_rect",
                                Color = "white"
                            },

                            DoClick = function() RiceUI.Prefab[k]({
                                Theme = {
                                    ThemeName = "modern",
                                    ThemeType = "Panel",

                                    Color = "black",
                                    TextColor = "black"
                                },
                            }) end
                        }, panel))
                    end
                end
            },
        },
    })
end)