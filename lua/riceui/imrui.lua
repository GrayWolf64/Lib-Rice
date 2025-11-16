ImRiceUI = ImRiceUI or {}

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
    TitleFont = "BudgetLabel"
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

        Windows = {},

        MousePos = {x = 0, y = 0},
        MouseX = gui.MouseX,
        MouseY = gui.MouseY,
        IsMouseDown = input.IsMouseDown,
        WasLeftMouseDown = false,

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
        GDummyPanel:SetMouseInputEnabled(false) GDummyPanel:SetKeyboardInputEnabled(false)
        GDummyPanel.Paint = function() end
    end)

    return GImRiceUI
end

local ImDrawList = {}

local function PushDrawCommand(draw_call, ...)
    ImDrawList[#ImDrawList + 1] = {draw_call = draw_call, args = {...}}
end

local function Render()
    for _, cmd in ipairs(ImDrawList) do
        cmd.draw_call(unpack(cmd.args))
    end
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
        }
    end

    return window_id
end

local function RenderWindow(window)
    if not window then return end

    local title_color
    if GImRiceUI.ActiveID == window.ID then
        title_color = GImRiceUI.Style.Colors.TitleBgActive
    else
        title_color = GImRiceUI.Style.Colors.TitleBg
    end

    PushDrawCommand(surface.SetDrawColor, GImRiceUI.Style.Colors.WindowBg)
    PushDrawCommand(surface.DrawRect, window.Pos.x, window.Pos.y,
                    window.Size.w, window.Size.h)

    PushDrawCommand(surface.SetDrawColor, GImRiceUI.Style.Colors.Border)
    PushDrawCommand(surface.DrawOutlinedRect, window.Pos.x, window.Pos.y,
                    window.Size.w, window.Size.h,
                    GImRiceUI.Config.WindowBorderWidth)

    PushDrawCommand(surface.SetDrawColor, title_color)
    PushDrawCommand(surface.DrawRect, window.Pos.x + GImRiceUI.Config.WindowBorderWidth,
                    window.Pos.y + GImRiceUI.Config.WindowBorderWidth,
                    window.Size.w - 2 * GImRiceUI.Config.WindowBorderWidth,
                    GImRiceUI.Config.TitleHeight)

    PushDrawCommand(draw.DrawText, window.Name, GImRiceUI.Style.Fonts.TitleFont,
                    window.Pos.x + GImRiceUI.Config.TitleHeight / 4, window.Pos.y + GImRiceUI.Config.TitleHeight / 4,
                    GImRiceUI.Style.Colors.Text)
end

local function RegionHit(x, y, w, h)
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

    local left_mousedown = GImRiceUI.IsMouseDown(MOUSE_LEFT)
    local window_hit = RegionHit(window.Pos.x, window.Pos.y, window.Size.w, window.Size.h)
    local title_hit = RegionHit(window.Pos.x, window.Pos.y, window.Size.w, GImRiceUI.Config.TitleHeight)

    if GDummyPanel and window_hit then
        GDummyPanel:MakePopup()
    end

    if window_hit then
        GImRiceUI.HotID = window_id
    elseif GImRiceUI.HotID == window_id then
        GImRiceUI.HotID = nil
    end

    if title_hit and left_mousedown and
        (GImRiceUI.MovingWindow == nil or GImRiceUI.MovingWindow == window_id) and
        GImRiceUI.MousePressedThisFrame then

        GImRiceUI.ActiveID = window_id

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

    RenderWindow(window)

    return true
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