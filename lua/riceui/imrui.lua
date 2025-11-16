ImRiceUI = ImRiceUI or {}

local remove_at = table.remove
local insert_at = table.insert

local GImRiceUI = nil

--- Notable: VGUIMousePressAllowed?
local GDummyPanel = nil

local function ParseRGBA(str)
    local r, g, b, a = str:match("ImVec4%(([%d%.]+)f?, ([%d%.]+)f?, ([%d%.]+)f?, ([%d%.]+)f?%)")
    return {r = tonumber(r) * 255, g = tonumber(g) * 255, b = tonumber(b) * 255, a = tonumber(a) * 255}
end

local function ImHash(name)
    if not GImRiceUI then return end

    return string.format("Im_%s", string.sub(util.SHA256(name), 1, 16))
end

--- ImGui::StyleColorsDark
local StyleColorsDark = {
    Text          = ParseRGBA("ImVec4(1.00f, 1.00f, 1.00f, 1.00f)"),
    WindowBg      = ParseRGBA("ImVec4(0.06f, 0.06f, 0.06f, 0.94f)"),
    Border        = ParseRGBA("ImVec4(0.43f, 0.43f, 0.50f, 0.50f)"),
    TitleBg       = ParseRGBA("ImVec4(0.04f, 0.04f, 0.04f, 1.00f)"),
    TitleBgActive = ParseRGBA("ImVec4(0.16f, 0.29f, 0.48f, 1.00f)"),
    MenuBarBg     = ParseRGBA("ImVec4(0.14f, 0.14f, 0.14f, 1.00f)"),
    Button        = ParseRGBA("ImVec4(0.26f, 0.59f, 0.98f, 0.40f)"),
    ButtonHovered = ParseRGBA("ImVec4(0.26f, 0.59f, 0.98f, 1.00f)"),
    ButtonActive  = ParseRGBA("ImVec4(0.06f, 0.53f, 0.98f, 1.00f)")
}

local StyleFontsDefault = {
    Title = "BudgetLabel"
}

local DefaultConfig = {
    WindowSize = {w = 500, h = 480},
    WindowPos = {x = 0, y = 0},

    TitleHeight = 25,

    WindowBorderWidth = 1,
}

--- Index starts from 1
local MouseButtonMap = {
    [1] = MOUSE_LEFT,
    [2] = MOUSE_RIGHT
}

local function CreateNewContext()
    GImRiceUI = {
        Style = {
            Colors = StyleColorsDark,
            Fonts = StyleFontsDefault
        },
        Config = DefaultConfig,
        Initialized = true,

        WindowStack = {},
        Windows = {},

        IO = {
            MousePos = {x = 0, y = 0},
            MouseX = gui.MouseX,
            MouseY = gui.MouseY,
            IsMouseDown = input.IsMouseDown,

            MouseDown             = {false, false},
            MouseClicked          = {false, false},
            MouseReleased         = {false, false},
            MouseDownDuration     = {-1, -1},
            MouseDownDurationPrev = {-1, -1}
        },

        MovingWindow = nil,
        MovingWindowOffset = {x = 0, y = 0},

        HotID = nil,
        ActiveID = nil,

        FrameCount = 0
    }

    hook.Add("PostGamemodeLoaded", "ImGDummyWindow", function()
        GDummyPanel = vgui.Create("DFrame")
        GDummyPanel:SetScreenLock(true)
        GDummyPanel:SetTitle("")                GDummyPanel:SetSize(ScrW(), ScrH())
        GDummyPanel:ShowCloseButton(false)      GDummyPanel:SetDrawOnTop(true)
        GDummyPanel:SetDraggable(false)         GDummyPanel:SetSizable(false)
        GDummyPanel:SetMouseInputEnabled(false) -- GDummyPanel:SetKeyboardInputEnabled(false)
        GDummyPanel.Paint = function() end
    end)

    return GImRiceUI
end

local function IsMouseHoveringRect(x, y, w, h)
    if GImRiceUI.IO.MousePos.x < x or
        GImRiceUI.IO.MousePos.y < y or
        GImRiceUI.IO.MousePos.x >= x + w or
        GImRiceUI.IO.MousePos.y >= y + h then

        return false
    end

    return true
end

local function BringWindowToFront(window_id)
    for i, id in ipairs(GImRiceUI.WindowStack) do
        if id == window_id then
            remove_at(GImRiceUI.WindowStack, i)
            break
        end
    end

    insert_at(GImRiceUI.WindowStack, window_id)
end

local ImDrawList = {}

local function PushDrawCommand(draw_call, ...)
    ImDrawList[#ImDrawList + 1] = {draw_call = draw_call, args = {...}}
end

local function AddRectFilled(color, x, y, w, h)
    PushDrawCommand(surface.SetDrawColor, color)
    PushDrawCommand(surface.DrawRect, x, y, w, h)
end

local function AddRectOutline(color, x, y, w, h, thickness)
    PushDrawCommand(surface.SetDrawColor, color)
    PushDrawCommand(surface.DrawOutlinedRect, x, y, w, h, thickness)
end

local function AddText(text, font, x, y, color)
    PushDrawCommand(surface.SetTextPos, x, y)
    PushDrawCommand(surface.SetFont, font)
    PushDrawCommand(surface.SetDrawColor, color)
    PushDrawCommand(surface.DrawText, text)
end

local function AddLine(x1, y1, x2, y2, color)
    PushDrawCommand(surface.SetDrawColor, color)
    PushDrawCommand(surface.DrawLine, x1, y1, x2, y2)
end

-- local function ButtonBehavior(button_id, x, y, w, h)
--     local io = GImRiceUI.IO
--     local hovering = IsMouseHoveringRect(x, y, w, h)
--     local pressed = false

--     if hovering and GImRiceUI.HotID == nil then
--         GImRiceUI.HotID = button_id
--     end

--     local is_hot = (GImRiceUI.HotID == button_id)

--     if is_hot and io.MouseClicked[1] then
--         pressed = true
--         GImRiceUI.ActiveID = button_id
--     end

--     return pressed, hovering, is_hot
-- end

-- local function CloseButton(button_id, x, y, w, h)
--     local pressed, hovered, is_hot = ButtonBehavior(button_id, x, y, w, h)

--     local color
--     if (hovered or is_hot) then
--         color = GImRiceUI.Style.Colors.ButtonHovered
--     else
--         color = GImRiceUI.Style.Colors.Button
--     end

--     AddRectFilled(color, x, y, w, h)

--     local center_x = x + w * 0.5
--     local center_y = y + h * 0.5
--     local cross_extent = w * 0.5 * 0.7071 - 1

--     AddLine(center_x - cross_extent, center_y - cross_extent,
--             center_x + cross_extent, center_y + cross_extent,
--             GImRiceUI.Style.Colors.Text)

--     AddLine(center_x + cross_extent, center_y - cross_extent,
--             center_x - cross_extent, center_y + cross_extent,
--             GImRiceUI.Style.Colors.Text)

--     return pressed
-- end

local function CreateNewWindow(name)
    if not GImRiceUI then return nil end

    local window_id = ImHash(name)

    if not GImRiceUI.Windows[window_id] then
        GImRiceUI.Windows[window_id] = {
            ID = window_id,
            Name = name,
            Pos = {x = GImRiceUI.Config.WindowPos.x, y = GImRiceUI.Config.WindowPos.y},
            Size = {w = GImRiceUI.Config.WindowSize.w, h = GImRiceUI.Config.WindowSize.h},

            Open = true,
            Collapsed = false
        }
    end

    return window_id
end

local function RenderWindow(window)
    if not window or not window.Open then return end

    local title_color
    if GImRiceUI.ActiveID == window.ID then
        title_color = GImRiceUI.Style.Colors.TitleBgActive
    else
        title_color = GImRiceUI.Style.Colors.TitleBg
    end

    -- Window background
    AddRectFilled(GImRiceUI.Style.Colors.WindowBg, window.Pos.x, window.Pos.y,
        window.Size.w, window.Size.h)

    -- RenderWindowOuterBorders
    AddRectOutline(GImRiceUI.Style.Colors.Border, window.Pos.x, window.Pos.y,
        window.Size.w, window.Size.h,GImRiceUI.Config.WindowBorderWidth)

    -- Title bar
    AddRectFilled(title_color, window.Pos.x + GImRiceUI.Config.WindowBorderWidth,
        window.Pos.y + GImRiceUI.Config.WindowBorderWidth,
        window.Size.w - 2 * GImRiceUI.Config.WindowBorderWidth,
        GImRiceUI.Config.TitleHeight)

    -- Title text
    AddText(window.Name, GImRiceUI.Style.Fonts.Title,
        window.Pos.x + GImRiceUI.Config.TitleHeight / 4, window.Pos.y + GImRiceUI.Config.TitleHeight / 4,
        GImRiceUI.Style.Colors.Text)

    -- Close button
    -- local close_button_size = GImRiceUI.Config.TitleHeight - 8
    -- local close_button_x = window.Pos.x + window.Size.w - close_button_size - 4
    -- local close_button_y = window.Pos.y + 4
    -- local close_button_id = window.ID .. "##CLOSE"

    -- if CloseButton(close_button_id, close_button_x, close_button_y, close_button_size, close_button_size) then
    --     window.Open = false
    -- end
end

local function Render()
    for _, window_id in ipairs(GImRiceUI.WindowStack) do
        local window = GImRiceUI.Windows[window_id]
        if window then
            RenderWindow(window)
        end
    end

    for _, cmd in ipairs(ImDrawList) do
        cmd.draw_call(unpack(cmd.args))
    end
end

local function Begin(name)
    if name == nil or name == "" then return end

    local window_id = CreateNewWindow(name)
    local window = GImRiceUI.Windows[window_id]

    local in_stack = false
    for _, id in ipairs(GImRiceUI.WindowStack) do
        if id == window_id then
            in_stack = true
            break
        end
    end
    if not in_stack then
        insert_at(GImRiceUI.WindowStack, window_id)
    end

    local window_hit = IsMouseHoveringRect(window.Pos.x, window.Pos.y, window.Size.w, window.Size.h)
    local title_hit = IsMouseHoveringRect(window.Pos.x, window.Pos.y, window.Size.w, GImRiceUI.Config.TitleHeight)

    if window_hit and GImRiceUI.IO.MouseClicked[1] and GImRiceUI.HotID == window_id then
        GImRiceUI.ActiveID = window_id
        BringWindowToFront(window_id)
    end

    local left_mousedown = GImRiceUI.IO.MouseDown[1]

    if title_hit and left_mousedown and
        (GImRiceUI.MovingWindow == nil or GImRiceUI.MovingWindow == window_id) and
        GImRiceUI.IO.MouseClicked[1] and
        GImRiceUI.HotID == window_id then

        GImRiceUI.MovingWindow = window_id
        GImRiceUI.MovingWindowOffset = {
            x = GImRiceUI.IO.MousePos.x - window.Pos.x,
            y = GImRiceUI.IO.MousePos.y - window.Pos.y
        }
    end

    if GImRiceUI.MovingWindow == window_id and left_mousedown then
        window.Pos.x = GImRiceUI.IO.MousePos.x - GImRiceUI.MovingWindowOffset.x
        window.Pos.y = GImRiceUI.IO.MousePos.y - GImRiceUI.MovingWindowOffset.y
    end

    return true
end

local function ProcessWindowInteractions()
    GImRiceUI.HotID = nil

    local topmost_hovered_window = nil

    for i = #GImRiceUI.WindowStack, 1, -1 do
        local window_id = GImRiceUI.WindowStack[i]
        local window = GImRiceUI.Windows[window_id]
        if window then
            local window_hit = IsMouseHoveringRect(window.Pos.x, window.Pos.y, window.Size.w, window.Size.h)

            if window_hit and GImRiceUI.HotID == nil then
                GImRiceUI.HotID = window_id
                topmost_hovered_window = window

                break
            end
        end
    end

    if GImRiceUI.IO.MouseClicked[1] and not topmost_hovered_window then
        GImRiceUI.ActiveID = nil
    end

    if GDummyPanel and topmost_hovered_window then
        GDummyPanel:SetPos(topmost_hovered_window.Pos.x, topmost_hovered_window.Pos.y)
        GDummyPanel:SetSize(topmost_hovered_window.Size.w, topmost_hovered_window.Size.h)
        GDummyPanel:MakePopup()
        GDummyPanel:SetKeyboardInputEnabled(false)
    end
end

--- ImGui::UpdateMouseInputs()
local function UpdateMouseInputs()
    local io = GImRiceUI.IO -- pointer to IO field

    io.MousePos.x = io.MouseX()
    io.MousePos.y = io.MouseY()
    GImRiceUI.FrameCount = GImRiceUI.FrameCount + 1

    for i = 1, #MouseButtonMap do
        local button_down = io.IsMouseDown(MouseButtonMap[i])

        io.MouseClicked[i] = button_down and (io.MouseDownDuration[i] < 0)

        io.MouseReleased[i] = not button_down and (io.MouseDownDuration[i] >= 0)

        if button_down then
            if io.MouseDownDuration[i] < 0 then
                io.MouseDownDuration[i] = 0
            else
                io.MouseDownDuration[i] = io.MouseDownDuration[i] + 1
            end
        else

            io.MouseDownDuration[i] = -1.0
        end

        io.MouseDownDurationPrev[i] = io.MouseDownDuration[i]

        io.MouseDown[i] = button_down
    end
end

local function NewFrame()
    if not GImRiceUI or not GImRiceUI.Initialized then return end

    UpdateMouseInputs()

    GImRiceUI.HotID = nil

    if not GImRiceUI.IO.MouseDown[1] and GImRiceUI.MovingWindow then
        GImRiceUI.MovingWindow = nil
    end

    if GDummyPanel then
        GDummyPanel:SetMouseInputEnabled(false)
    end

    ProcessWindowInteractions()

    ImDrawList = {}
end

-- test here

CreateNewContext()

hook.Add("PostRender", "ImRiceUI", function()
    cam.Start2D()

    NewFrame()

    Begin("Hello World!")
    Begin("ImRiceUI Demo")

    Render()

    cam.End2D()
end)