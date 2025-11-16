ImRiceUI = ImRiceUI or {}

local remove_at = table.remove
local insert_at = table.insert

local GImRiceUI = nil

local GDummyPanel = nil

local function ParseRGBA(str)
    local r, g, b, a = str:match("ImVec4%(([%d%.]+)f?, ([%d%.]+)f?, ([%d%.]+)f?, ([%d%.]+)f?%)")
    return {r = tonumber(r) * 255, g = tonumber(g) * 255, b = tonumber(b) * 255, a = tonumber(a) * 255}
end

local function ImHash(name)
    if not GImRiceUI then return end

    return string.format("Im_%s", string.sub(util.SHA256(name), 1, 16))
end

local StyleColorsDark = {
    Text          = ParseRGBA("ImVec4(1.00f, 1.00f, 1.00f, 1.00f)"),
    WindowBg      = ParseRGBA("ImVec4(0.06f, 0.06f, 0.06f, 0.94f)"),
    Border        = ParseRGBA("ImVec4(0.43f, 0.43f, 0.50f, 0.50f)"),
    TitleBg       = ParseRGBA("ImVec4(0.04f, 0.04f, 0.04f, 1.00f)"),
    TitleBgActive = ParseRGBA("ImVec4(0.16f, 0.29f, 0.48f, 1.00f)"),
    MenuBarBg     = ParseRGBA("ImVec4(0.14f, 0.14f, 0.14f, 1.00f)")
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

        MousePos = {x = 0, y = 0},
        MouseX = gui.MouseX,
        MouseY = gui.MouseY,
        IsMouseDown = input.IsMouseDown,
        WasLeftMouseDown = false,
        MousePressedThisFrame = false,

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

local function IsMouseHoveringRect(x, y, w, h)
    if GImRiceUI.MousePos.x < x or
        GImRiceUI.MousePos.y < y or
        GImRiceUI.MousePos.x >= x + w or
        GImRiceUI.MousePos.y >= y + h then

        return false
    end

    return true
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

    local left_mousedown = GImRiceUI.IsMouseDown(MOUSE_LEFT)

    local window_hit = IsMouseHoveringRect(window.Pos.x, window.Pos.y, window.Size.w, window.Size.h)
    local title_hit = IsMouseHoveringRect(window.Pos.x, window.Pos.y, window.Size.w, GImRiceUI.Config.TitleHeight)

    if window_hit and GImRiceUI.MousePressedThisFrame and GImRiceUI.HotID == window_id then
        GImRiceUI.ActiveID = window_id
        BringWindowToFront(window_id)
    end

    if title_hit and left_mousedown and
        (GImRiceUI.MovingWindow == nil or GImRiceUI.MovingWindow == window_id) and
        GImRiceUI.MousePressedThisFrame and
        GImRiceUI.HotID == window_id then

        GImRiceUI.MovingWindow = window_id
        GImRiceUI.MovingWindowOffset = {
            x = GImRiceUI.MousePos.x - window.Pos.x,
            y = GImRiceUI.MousePos.y - window.Pos.y
        }
    end

    if GImRiceUI.MovingWindow == window_id and left_mousedown then
        window.Pos.x = GImRiceUI.MousePos.x - GImRiceUI.MovingWindowOffset.x
        window.Pos.y = GImRiceUI.MousePos.y - GImRiceUI.MovingWindowOffset.y
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
            end
        end
    end

    if GImRiceUI.MousePressedThisFrame and not topmost_hovered_window then
        GImRiceUI.ActiveID = nil
    end

    if GDummyPanel and topmost_hovered_window then
        GDummyPanel:SetPos(topmost_hovered_window.Pos.x, topmost_hovered_window.Pos.y)
        GDummyPanel:SetSize(topmost_hovered_window.Size.w, topmost_hovered_window.Size.h)
        GDummyPanel:MakePopup()
        GDummyPanel:SetKeyboardInputEnabled(false)
    end
end

local function NewFrame()
    if not GImRiceUI or not GImRiceUI.Initialized then return end

    GImRiceUI.MousePos.x = GImRiceUI.MouseX()
    GImRiceUI.MousePos.y = GImRiceUI.MouseY()
    GImRiceUI.FrameCount = GImRiceUI.FrameCount + 1

    local left_mousedown = GImRiceUI.IsMouseDown(MOUSE_LEFT)

    GImRiceUI.MousePressedThisFrame = (left_mousedown and not GImRiceUI.WasLeftMouseDown)
    GImRiceUI.WasLeftMouseDown = left_mousedown

    if not left_mousedown and GImRiceUI.MovingWindow then
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