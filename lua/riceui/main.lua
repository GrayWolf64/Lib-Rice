RiceUI = RiceUI or {}
RiceUI.UI = {}
RiceUI.RootName = "main"

file.CreateDir("riceui")
file.CreateDir("riceui/web_image")

local elements = {}
RL.Functions.LoadFiles(elements, "riceui/elements")

--- Create UI Elements
-- @section CreateElement
function RiceUI.SimpleCreate(data, parent)
    if not elements[data.type] then
        elements["error"].Create(data, parent)

        return
    end

    if data.ShouldCreate and not data.ShouldCreate() then return end

    local pnl = elements[data.type].Create(data, parent)
    table.insert(RiceUI.UI, pnl)
    RiceUI.DoProcess(pnl)
    RiceUI.ApplyExtraFunctions(pnl)

    if data.children then
        RiceUI.Create(data.children, pnl)
    end

    if data.OnCreated then
        data.OnCreated(pnl)
    end

    if pnl.ChildCreated then
        pnl:ChildCreated()
    end

    if data.ID then
        if not IsValid(parent) then return pnl end

        parent.Elements = parent.Elements or {}
        parent.Elements[data.ID] = pnl
    end

    return pnl
end

function RiceUI.Create(tbl, parent)
    for i, data in ipairs(tbl) do
        local pnl = RiceUI.SimpleCreate(data, parent)
        local parent = parent or pnl
        parent.Elements = parent.Elements or {}

        if data.ID then
            parent.Elements[data.ID] = pnl
        end
    end
end

--- Handle generic parameters
-- @section UniProcess
local uniprocess = {}

function RiceUI.DoProcess(pnl)
    if not pnl.RiceUI_Data then return end

    for name,data in pairs(pnl.RiceUI_Data) do
        if uniprocess[name] == nil then continue end

        local processor
        if istable(uniprocess[name]) then
            processor = uniprocess[name][pnl.ProcessID]
        else
            processor = uniprocess[name]
        end

        if processor then
            processor(pnl,data)
        end
    end
end

function RiceUI.DefineUniProcess(name,data)
    uniprocess[name] = data
end

RL.IncludeDir("riceui/uniprocess",true)

concommand.Add("riceui_reload", function()
    RL.Functions.LoadFiles(elements, "riceui/elements")
    RL.Functions.LoadFiles(uniprocess, "riceui/uniprocess")
    RL.Functions.LoadFiles(RiceUI.Theme, "riceui/theme")
end)

concommand.Add("riceui_panic", function()
    for _, v in pairs(RiceUI.UI) do
        if IsValid(v) then
            v:Remove()
        end
    end
end)

concommand.Add("riceui_elements", function()
    PrintTable(RiceUI.Elements)
end)

concommand.Add("riceui_theme", function()
    PrintTable(RiceUI.Theme)
end)

concommand.Add("riceui_all", function()
    PrintTable(RiceUI.UI)
end)

RiceUI.Prefab = {}
RL.IncludeDir("riceui/prefabs", true)
RL.IncludeDir("riceui/modules", true, true)

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
                OnCreated = function(pnl)
                    for k, v in SortedPairs(RiceUI.Prefab) do
                        pnl:AddItem(RiceUI.SimpleCreate({type = "rl_button",
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
                        }, pnl))

                        pnl:AddItem(RiceUI.SimpleCreate({type = "rl_button",
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
                        }, pnl))
                    end
                end
            },
        },
    })
end)

RiceUI.UniProcess = uniprocess
RiceUI.Elements = elements