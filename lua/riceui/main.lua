RiceUI          = RiceUI or {}
RiceUI.RootName = "main"

local elements = {}
local widgets = {}
local instances = {}

RiceLib.FS.LoadFiles(elements, "riceui/elements")
RiceLib.IncludeDir("riceui/modules", true)

--- Load Widgets, which are groups of elements
-- @section Widgets
function RiceUI.DefineWidget(name, data) widgets[name] = data end
local function createWidget(data, parent, root)
    local name = data.widget
    local func = widgets[name]

    if not func then return elements.error.Create(data, parent) end
    return func(data, parent, root)
end
RiceUI.CreateWidget = createWidget

RiceLib.IncludeDir("riceui/widgets")

---Create UI Elements
---@param data table
---@param parent? DPanel
---@param root? DPanel
---@return DPanel|nil
function RiceUI.SimpleCreate(data, parent, root)
    if data.widget then return createWidget(data, parent, root) end

    if not elements[data.type] then elements.error.Create(data, parent) return end
    if data.ShouldCreate and not data.ShouldCreate() then return end

    local panel = elements[data.type].Create(data, parent)
    panel.RiceUI_Root = root

    instances[#instances + 1] = panel

    root = root or panel

    RiceUI.DoProcess(panel, root)
    RiceUI.ApplyMixins(panel)

    if data.children then
        local childRoot = root
        if data.ChildrenIgnoreRoot then childRoot = panel end

        RiceUI.Create(data.children, panel, childRoot)
    end

    if data.OnCreated then data.OnCreated(panel) end
    if panel.ChildCreated then panel:ChildCreated() end

    if data.ID then
        if not IsValid(parent) then return panel end

        root.riceui_elements = root.riceui_elements or {}
        root.riceui_elements[data.ID] = panel
    end

    return panel
end

---Create UI Elements
---@param tab table
---@param parent? DPanel
---@param root? DPanel
---@return table
function RiceUI.Create(tab, parent, root)
    local _insts = {}

    for _, data in ipairs(tab) do
        _insts[#_insts + 1] = RiceUI.SimpleCreate(data, parent, root)
    end

    return _insts
end


--- Handle generic parameters
-- @section UniProcess
local uniProcess = uniProcess or {}

function RiceUI.DoProcess(panel, root)
    if not panel.riceui_data then return end

    for name, data in pairs(panel.riceui_data) do
        if uniProcess[name] == nil then continue end

        local processor
        if istable(uniProcess[name]) then
            processor = uniProcess[name][panel.ProcessID]
        else
            processor = uniProcess[name]
        end

        if not processor then continue end
        processor(panel, data, root)
    end
end

function RiceUI.DefineUniProcess(name,data)
    uniProcess[name] = data
end

RiceLib.IncludeDir("riceui/uniprocess", true)

-- Prefab will soon be replace by widgets
RiceUI.Prefab = {}
RiceLib.IncludeDir("riceui/prefabs", true)


concommand.Add("riceui_reload", function()
    RiceLib.FS.LoadFiles(elements, "riceui/elements")
    RiceLib.FS.LoadFiles(uniProcess, "riceui/uniprocess")
    RiceUI.ReloadThemes()
end)

concommand.Add("riceui_panic", function()
    for _, panel in ipairs(instances) do
        if IsValid(panel) then
            panel:Remove()
        end
    end

    instances = {}
end)

concommand.Add("riceui_elements", function()
    PrintTable(elements)
end)

concommand.Add("riceui_all", function()
    PrintTable(instances)
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

local debug_overlay = false
concommand.Add("riceui_debugoverlay", function()
    debug_overlay = not debug_overlay

    if not debug_overlay then
        hook.Remove("PostRenderVGUI", "RiceUI_Debugoverlay")
        hook.Remove("Think", "RiceUI_Debugoverlay_CaptureMouse")

        return
    end

    local wireframe_x, wireframe_y = 0, 0
    local pressed = false
    hook.Add("Think", "RiceUI_Debugoverlay_CaptureMouse", function()
        if input.IsMouseDown(MOUSE_LEFT) then
            if not pressed then
                wireframe_x, wireframe_y = input.GetCursorPos()

                pressed = true
            end

            return
        end

        pressed = false
        wireframe_x, wireframe_y = 0, 0
    end)

    hook.Add("PostRenderVGUI", "RiceUI_Debugoverlay", function()
        for _, panel in pairs(instances) do
            if not IsValid(panel) then continue end
            if not panel:RiceUI_GetRoot():IsVisible() or not panel:GetParent():IsVisible() or not panel:IsVisible() then continue end

            local x, y = panel:LocalToScreen()
            local w, h = panel:GetSize()

            local color = Color(255, 0, 0)

            if panel:HasFocus() then color = Color(0, 255, 0) end

            surface.SetDrawColor(color)
            surface.DrawOutlinedRect(x, y, w, h, 1)

            if not panel:IsHovered() then continue end

            draw.SimpleTextOutlined(string.format("%s %s %s", x, y, panel.ID or ""), "RiceUI_24", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
            draw.SimpleTextOutlined(string.format("%s %s", w, h), "RiceUI_24", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)

            surface.SetDrawColor(ColorAlpha(color, 50))
            surface.DrawRect(x, y, w, h)

            local parent = panel:GetParent()
            if parent then
                local x, y = parent:LocalToScreen()
                local w, h = parent:GetSize()

                surface.SetDrawColor(ColorAlpha(Color(0, 0, 255), 50))
                surface.DrawRect(x, y, w, h)
            end
        end

        local x, y = input.GetCursorPos()

        surface.SetDrawColor(0, 0, 255)
        surface.DrawLine(x, 0, x, ScrH())
        surface.DrawLine(0, y, ScrW(), y)

        draw.SimpleTextOutlined(string.format("%s %s", x, y), "RiceUI_24", x + 16, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)

        if wireframe_x > 0 then
            local w = -(wireframe_x - x)
            local h = -(wireframe_y - y)

            surface.SetDrawColor(0, 0, 255)
            surface.DrawOutlinedRect(wireframe_x, wireframe_y, w, h, 1)

            draw.SimpleTextOutlined(string.format("%s %s", w, h), "RiceUI_24", x + 16, y + 32, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
        end
    end)
end)