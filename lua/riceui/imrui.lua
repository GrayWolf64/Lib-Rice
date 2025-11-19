ImRiceUI = ImRiceUI or {}

local IsValid = IsValid

local remove_at = table.remove
local insert_at = table.insert

local GImRiceUI = nil

--- Notable: VGUIMousePressAllowed?
local GDummyPanel = GDummyPanel or nil

local function SetupDummyPanel()
    if IsValid(GDummyPanel) then return end

    GDummyPanel = vgui.Create("DFrame")

    GDummyPanel:SetSizable(false)
    GDummyPanel:SetTitle("")
    GDummyPanel:SetPaintShadow(false)
    GDummyPanel:ShowCloseButton(false)
    GDummyPanel:SetDrawOnTop(true)
    GDummyPanel:SetDraggable(false)
    GDummyPanel:SetMouseInputEnabled(false)
    GDummyPanel:SetKeyboardInputEnabled(false)

    GDummyPanel:SetVisible(false)

    GDummyPanel.Paint = function(self, w, h)
        -- surface.SetDrawColor(0, 255, 0)
        -- surface.DrawOutlinedRect(0, 0, w, h, 4)
    end
end

local function AttachDummyPanel(x, y, w, h)
    if not GDummyPanel then return end

    GDummyPanel:SetPos(x, y)
    GDummyPanel:SetSize(w, h)
    GDummyPanel:SetVisible(true)
    GDummyPanel:MakePopup()
    GDummyPanel:SetKeyboardInputEnabled(false)
end

local function DetachDummyPanel()
    if not GDummyPanel then return end

    GDummyPanel:SetVisible(false)
end

--- If lower, the window title cross or arrow will look awful
-- TODO: let client decide?
RunConsoleCommand("mat_antialias", "8")

local function ParseRGBA(str)
    local r, g, b, a = str:match("ImVec4%(([%d%.]+)f?, ([%d%.]+)f?, ([%d%.]+)f?, ([%d%.]+)f?%)")
    return {r = tonumber(r) * 255, g = tonumber(g) * 255, b = tonumber(b) * 255, a = tonumber(a) * 255}
end

--- Use FNV1a, as one ImGui FIXME suggested
local str_byte, bit_bxor, bit_band = string.byte, bit.bxor, bit.band
local function ImHashStr(str)
    if not GImRiceUI then return end

    local FNV_OFFSET_BASIS = 0x811C9DC5
    local FNV_PRIME = 0x01000193

    local hash = FNV_OFFSET_BASIS

    local byte
    for i = 1, #str do
        byte = str_byte(str, i)
        hash = bit_bxor(hash, byte)
        hash = bit_band(hash * FNV_PRIME, 0xFFFFFFFF)
    end

    return string.format("Im_%d", hash)
end

--- ImGui::StyleColorsDark
local StyleColorsDark = {
    Text             = ParseRGBA("ImVec4(1.00f, 1.00f, 1.00f, 1.00f)"),
    WindowBg         = ParseRGBA("ImVec4(0.06f, 0.06f, 0.06f, 0.94f)"),
    Border           = ParseRGBA("ImVec4(0.43f, 0.43f, 0.50f, 0.50f)"),
    BorderShadow     = ParseRGBA("ImVec4(0.00f, 0.00f, 0.00f, 0.00f)"),
    TitleBg          = ParseRGBA("ImVec4(0.04f, 0.04f, 0.04f, 1.00f)"),
    TitleBgActive    = ParseRGBA("ImVec4(0.16f, 0.29f, 0.48f, 1.00f)"),
    TitleBgCollapsed = ParseRGBA("ImVec4(0.00f, 0.00f, 0.00f, 0.51f)"),
    MenuBarBg        = ParseRGBA("ImVec4(0.14f, 0.14f, 0.14f, 1.00f)"),
    Button           = ParseRGBA("ImVec4(0.26f, 0.59f, 0.98f, 0.40f)"),
    ButtonHovered    = ParseRGBA("ImVec4(0.26f, 0.59f, 0.98f, 1.00f)"),
    ButtonActive     = ParseRGBA("ImVec4(0.06f, 0.53f, 0.98f, 1.00f)")
}

--- TODO: font subsystem later
local StyleFontsDefault = {
    Title = "BudgetLabel"
}

local FontDataDefault = {
    font      = "Arial",
    extended  = false,
    size      = 13,
    weight    = 500,
    blursize  = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic    = false,
    strikeout = false,
    symbol    = false,
    rotary    = false,
    shadow    = false,
    additive  = false,
    outline   = false
}

--- Fonts created have a very long lifecycle, since can't be deleted
-- ImFont {name = , data = }
local GImFontAtlas = GImFontAtlas or {Fonts = {}}

--- Add or get a font, always take its return val as fontname
function GImFontAtlas:AddFont(font_name, font_data)
    for i = #self.Fonts, 1, -1 do
        local identical = self.Fonts[i].name

        for key, _ in pairs(FontDataDefault) do
            if self.Fonts[i].data[key] ~= font_data[key] then
                identical = ""
                break
            end
        end

        if identical ~= "" then return identical end
    end

    self.Fonts[#self.Fonts + 1] = {name = font_name, data = font_data}
    surface.CreateFont(font_name, font_data)

    return font_name
end

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

--- struct ImGuiContext
local function CreateNewContext()
    GImRiceUI = {
        Style = {
            Colors = StyleColorsDark,
            Fonts = StyleFontsDefault
        },
        Config = DefaultConfig,
        Initialized = true,

        WindowsFocusOrder = {}, -- ID
        Windows = {},

        CurrentWindowStack = {}, -- ID
        CurrentWindow = nil,

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
        ActiveIDClickOffset = {x = 0, y = 0},

        HoveredWindow = nil,
        ActiveID = nil,

        HoveredID = nil,

        FrameCount = 0
    }

    hook.Add("PostGamemodeLoaded", "ImGDummyWindow", function()
        SetupDummyPanel()
    end)

    return GImRiceUI
end

local function PushDrawCommand(draw_list, draw_call, ...)
    draw_list[#draw_list + 1] = {draw_call = draw_call, args = {...}}
end

local function AddRectFilled(draw_list, color, x, y, w, h)
    PushDrawCommand(draw_list, surface.SetDrawColor, color)
    PushDrawCommand(draw_list, surface.DrawRect, x, y, w, h)
end

local function AddRectOutline(draw_list, color, x, y, w, h, thickness)
    PushDrawCommand(draw_list, surface.SetDrawColor, color)
    PushDrawCommand(draw_list, surface.DrawOutlinedRect, x, y, w, h, thickness)
end

local function AddText(draw_list, text, font, x, y, color)
    PushDrawCommand(draw_list, surface.SetTextPos, x, y)
    PushDrawCommand(draw_list, surface.SetFont, font)
    PushDrawCommand(draw_list, surface.SetTextColor, color)
    PushDrawCommand(draw_list, surface.DrawText, text)
end

local function AddLine(draw_list, x1, y1, x2, y2, color)
    PushDrawCommand(draw_list, surface.SetDrawColor, color)
    PushDrawCommand(draw_list, surface.DrawLine, x1, y1, x2, y2)
end

--- ImGui::RenderArrow
local function RenderArrow(draw_list, x, y, color, dir, scale)
    local h = 14 * scale -- FontSize?
    local r = h * 0.40 * scale

    local center = {
        x = x + h * 0.5,
        y = y + h * 0.5 * scale
    }

    local a, b, c

    if dir == "up" or dir == "down" then
        if dir == "up" then r = -r end
        a = {x = center.x + r *  0.000, y = center.y + r *  0.750}
        b = {x = center.x + r * -0.866, y = center.y + r * -0.750}
        c = {x = center.x + r *  0.866, y = center.y + r * -0.750}
    elseif dir == "left" or dir == "right" then
        if dir == "left" then r = -r end
        a = {x = center.x + r *  0.750, y = center.y + r *  0.000}
        b = {x = center.x + r * -0.750, y = center.y + r *  0.866}
        c = {x = center.x + r * -0.750, y = center.y + r * -0.866}
    end

    PushDrawCommand(draw_list, surface.SetDrawColor, color)
    PushDrawCommand(draw_list, draw.NoTexture)
    PushDrawCommand(draw_list, surface.DrawPoly, {a, b, c})
end

local function PushID(str_id)
    local window = GImRiceUI.CurrentWindow
    if not window then return end
    insert_at(window.IDStack, str_id)

    -- print("PushID: " .. str_id, "IDStack: " .. table.concat(window.IDStack, ">"))
end

local function PopID()
    local window = GImRiceUI.CurrentWindow
    if not window then return end

    if #window.IDStack > 0 then
        remove_at(window.IDStack)

        -- print("PopID: " .. pop, "IDStack: " .. table.concat(window.IDStack, ">"))
    end
end

local function GetID(str_id)
    local window = GImRiceUI.CurrentWindow
    if not window then return end

    local full_string = table.concat(window.IDStack, "#") .. "#" .. (str_id or "")

    return ImHashStr(full_string)
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

--- ImGui::BringWindowToFocusFront
local function BringWindowToFocusFront(window_id)
    for i, id in ipairs(GImRiceUI.WindowsFocusOrder) do
        if id == window_id then
            remove_at(GImRiceUI.WindowsFocusOrder, i)
            break
        end
    end

    insert_at(GImRiceUI.WindowsFocusOrder, window_id)
end

local function ItemHoverable(item_id, x, y, w, h)
    if not GImRiceUI.CurrentWindow or not GImRiceUI.CurrentWindow.Open then
        return false
    end

    if GImRiceUI.HoveredWindow ~= GImRiceUI.CurrentWindow then
        return false
    end

    local hovered = IsMouseHoveringRect(x, y, w, h)
    if not hovered then
        return false
    end

    if GImRiceUI.HoveredID == nil then
        GImRiceUI.HoveredID = item_id

        return true
    end

    return false
end

local function ButtonBehavior(button_id, x, y, w, h)
    if GImRiceUI.CurrentWindow and not GImRiceUI.CurrentWindow.Open then
        return false, false
    end

    local io = GImRiceUI.IO
    local hovered = ItemHoverable(button_id, x, y, w, h)
    local pressed = false

    if hovered and io.MouseClicked[1] then
        pressed = true
        GImRiceUI.ActiveID = GImRiceUI.CurrentWindow.ID
    end

    -- FIXME: Is this correct? ActiveIDWindow or ActiveID?
    -- if GImRiceUI.ActiveID == button_id and io.MouseReleased[1] then
    --     GImRiceUI.ActiveID = nil
    -- end

    return pressed, hovered
end

local function CloseButton(window, x, y, w, h)
    local button_id = GetID("#CLOSE")
    local pressed, hovered = ButtonBehavior(button_id, x, y, w, h)

    if hovered then
        AddRectFilled(window.DrawList, GImRiceUI.Style.Colors.ButtonHovered, x, y, w, h)
    end

    --- DrawLine draws lines of different thickness, why? Antialiasing
    -- AddText(window.DrawList, "X", "ImCloseButtonCross", x + w * 0.25, y, GImRiceUI.Style.Colors.Text)
    local center_x = x + w * 0.5 - 1 -- tuned this 1
    local center_y = y + h * 0.5 - 1
    local cross_extent = w * 0.5 * 0.7071 - 1  -- √2/2

    AddLine(window.DrawList, center_x - cross_extent, center_y - cross_extent,
            center_x + cross_extent, center_y + cross_extent,
            GImRiceUI.Style.Colors.Text)

    AddLine(window.DrawList, center_x + cross_extent, center_y - cross_extent,
            center_x - cross_extent, center_y + cross_extent,
            GImRiceUI.Style.Colors.Text)

    return pressed
end

local function CollapseButton(window, x, y, w, h)
    local button_id = GetID("#COLLAPSE")
    local pressed, hovered = ButtonBehavior(button_id, x, y, w, h)

    if hovered then
        AddRectFilled(window.DrawList, GImRiceUI.Style.Colors.ButtonHovered, x, y, w, h)
    end

    if window.Collapsed then
        RenderArrow(window.DrawList, x + 1, y + 1, GImRiceUI.Style.Colors.Text, "right", 1)
    else
        RenderArrow(window.DrawList, x + 1, y + 1, GImRiceUI.Style.Colors.Text, "down", 1)
    end

    return pressed
end

local function CreateNewWindow(name)
    if not GImRiceUI then return nil end

    local window_id = ImHashStr(name)

    if not GImRiceUI.Windows[window_id] then
        --- struct IMGUI_API ImGuiWindow
        GImRiceUI.Windows[window_id] = {
            ID = window_id,
            Name = name,
            Pos = {x = GImRiceUI.Config.WindowPos.x, y = GImRiceUI.Config.WindowPos.y},
            Size = {w = GImRiceUI.Config.WindowSize.w, h = GImRiceUI.Config.WindowSize.h}, -- Current size (==SizeFull or collapsed title bar size)

            Active = false,

            Open = true,
            Collapsed = false,

            DrawList = {},

            IDStack = {},

            --- struct IMGUI_API ImGuiWindowTempData
            DC = {
                CursorPos = {}
            }
        }

        insert_at(GImRiceUI.WindowsFocusOrder, window_id)
    end

    return window_id
end

--- ImGui::RenderFrame, ImGui::RenderFrameBorder
-- local function RenderFrame(draw_list, x, y, w, h)

-- end

--- ImGui::RenderMouseCursor

--- ImGui::RenderWindowDecorations
local function RenderWindowDecorations(window)
    local title_color
    if GImRiceUI.ActiveID == window.ID then
        title_color = GImRiceUI.Style.Colors.TitleBgActive
    else
        title_color = GImRiceUI.Style.Colors.TitleBg
    end

    local border_width = GImRiceUI.Config.WindowBorderWidth

    if window.Collapsed then
        AddRectFilled(window.DrawList, GImRiceUI.Style.Colors.TitleBgCollapsed,
            window.Pos.x + border_width, window.Pos.y + border_width,
            window.Size.w - 2 * border_width,
            GImRiceUI.Config.TitleHeight - 2 * border_width)
        AddRectOutline(window.DrawList, GImRiceUI.Style.Colors.Border,
            window.Pos.x, window.Pos.y,
            window.Size.w, GImRiceUI.Config.TitleHeight, border_width)
    else
        AddRectFilled(window.DrawList, title_color,
            window.Pos.x + border_width, window.Pos.y + border_width,
            window.Size.w - 2 * border_width,
            GImRiceUI.Config.TitleHeight)
        -- Window background
        AddRectFilled(window.DrawList, GImRiceUI.Style.Colors.WindowBg,
            window.Pos.x + border_width, window.Pos.y + GImRiceUI.Config.TitleHeight + border_width,
            window.Size.w - 2 * border_width, window.Size.h - GImRiceUI.Config.TitleHeight - border_width)
        -- RenderWindowOuterBorders?
        AddRectOutline(window.DrawList, GImRiceUI.Style.Colors.Border,
            window.Pos.x, window.Pos.y,
            window.Size.w, window.Size.h, border_width)
    end
end

--- ImGui::RenderWindowTitleBarContents
local function RenderWindowTitleBarContents(window)
    -- Collapse button
    local collapse_button_size = GImRiceUI.Config.TitleHeight - 8
    local collapse_button_x = window.Pos.x + 4
    local collapse_button_y = window.Pos.y + 4
    if CollapseButton(window, collapse_button_x, collapse_button_y, collapse_button_size, collapse_button_size) then
        window.Collapsed = not window.Collapsed
    end

    -- Close button
    local close_button_size = GImRiceUI.Config.TitleHeight * 0.75
    local close_button_x = window.Pos.x + window.Size.w - close_button_size - 4
    local close_button_y = window.Pos.y + 4
    if CloseButton(window, close_button_x, close_button_y, close_button_size, close_button_size) then
        window.Open = false
    end

    -- Title text
    AddText(window.DrawList, window.Name, GImRiceUI.Style.Fonts.Title,
        window.Pos.x + GImRiceUI.Config.TitleHeight, window.Pos.y + GImRiceUI.Config.TitleHeight / 4,
        GImRiceUI.Style.Colors.Text)
end

local function Render()
    for _, window_id in ipairs(GImRiceUI.WindowsFocusOrder) do
        local window = GImRiceUI.Windows[window_id]
        if window and window.Open and window.DrawList then
            for _, cmd in ipairs(window.DrawList) do
                cmd.draw_call(unpack(cmd.args))
            end
        end
    end
end

--- void ImGui::StartMouseMovingWindow
local function StartMouseMovingWindow(window)
    GImRiceUI.ActiveIDClickOffset = {
        x = GImRiceUI.IO.MousePos.x - window.Pos.x,
        y = GImRiceUI.IO.MousePos.y - window.Pos.y
    }

    GImRiceUI.MovingWindow = window
end

--- void ImGui::UpdateMouseMovingWindowNewFrame
local function UpdateMouseMovingWindowNewFrame()
    local window = GImRiceUI.MovingWindow
    if not window then return end

    window.Pos.x = GImRiceUI.IO.MousePos.x - GImRiceUI.ActiveIDClickOffset.x
    window.Pos.y = GImRiceUI.IO.MousePos.y - GImRiceUI.ActiveIDClickOffset.y
end

--- void ImGui::UpdateMouseMovingWindowEndFrame()
local function UpdateMouseMovingWindowEndFrame()
    local hovered_window = GImRiceUI.HoveredWindow

    if GImRiceUI.IO.MouseClicked[1] then
        if hovered_window then
            StartMouseMovingWindow(hovered_window)
        else
            -- TODO: FocusWindow(NULL)
            GImRiceUI.ActiveID = nil
        end
    end
end

local function Begin(name)
    if name == nil or name == "" then
        GImRiceUI.CurrentWindow = nil
        return false
    end

    local window_id = CreateNewWindow(name)
    local window = GImRiceUI.Windows[window_id]

    GImRiceUI.CurrentWindow = window

    for i = #window.IDStack, 1, -1 do
        window.IDStack[i] = nil
    end
    PushID(window_id)

    insert_at(GImRiceUI.CurrentWindowStack, window_id)

    window.Active = true

    if window.Collapsed then
        window.Size.h = GImRiceUI.Config.TitleHeight
    else
        window.Size.h = GImRiceUI.Config.WindowSize.h
    end

    local window_hit = IsMouseHoveringRect(window.Pos.x, window.Pos.y, window.Size.w, window.Size.h)

    if window_hit and GImRiceUI.IO.MouseClicked[1] and GImRiceUI.HoveredWindow == window then
        GImRiceUI.ActiveID = window_id
        BringWindowToFocusFront(window_id)
    end

    for i = #window.DrawList, 1, -1 do
        window.DrawList[i] = nil
    end

    RenderWindowDecorations(window)

    RenderWindowTitleBarContents(window)

    return not window.Collapsed
end

local function End()
    local window = GImRiceUI.CurrentWindow
    if not window then return end

    PopID()
    remove_at(GImRiceUI.CurrentWindowStack)

    GImRiceUI.CurrentWindow = GImRiceUI.CurrentWindowStack[#GImRiceUI.CurrentWindowStack]
end

local function FindHoveredWindow()
    GImRiceUI.HoveredWindow = nil

    local x, y, w, h

    for i = #GImRiceUI.WindowsFocusOrder, 1, -1 do
        local window_id = GImRiceUI.WindowsFocusOrder[i]
        local window = GImRiceUI.Windows[window_id]

        if window and window.Open then
            x, y, w, h = window.Pos.x, window.Pos.y, window.Size.w, window.Size.h

            local hit = IsMouseHoveringRect(window.Pos.x, window.Pos.y, window.Size.w, window.Size.h)

            if hit and GImRiceUI.HoveredWindow == nil then
                GImRiceUI.HoveredWindow = window

                break
            end
        end
    end

    --- Our window isn't actually a window. It doesn't "exist"
    -- need to block input to other game ui like Derma panels, and prevent render artifacts
    if GImRiceUI.HoveredWindow then
        AttachDummyPanel(0, 0, ScrW(), ScrH())
    else
        if x and y and w and h then
            AttachDummyPanel(x, y, w, h)
        else
            DetachDummyPanel()
        end
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

    for i = #GImRiceUI.CurrentWindowStack, 1, -1 do
        GImRiceUI.CurrentWindowStack[i] = nil
    end
    GImRiceUI.CurrentWindow = nil

    UpdateMouseInputs()

    GImRiceUI.HoveredID = nil
    GImRiceUI.HoveredWindow = nil

    if not GImRiceUI.IO.MouseDown[1] and GImRiceUI.MovingWindow then
        GImRiceUI.MovingWindow = nil
    end

    FindHoveredWindow()

    UpdateMouseMovingWindowNewFrame()
end

--- TODO: FrameCountEnded
local function EndFrame()
    UpdateMouseMovingWindowEndFrame()
end

-- test here

CreateNewContext()

hook.Add("PostRender", "ImRiceUI", function()
    cam.Start2D()

    NewFrame()

    if Begin("Hello World!") then
        End()
    end

    if Begin("ImRiceUI Demo") then
        End()
    end

    EndFrame()

    Render()

    cam.End2D()
end)