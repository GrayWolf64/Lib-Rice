local getFont = RiceUI.Font.Get
local drawCircle = RiceLib.Draw.Circle
local registerClass = RiceUI.ThemeNT.RegisterClass

local DEFAULT_BODY_BORDER_RADIUS = 8
local DEFAULT_CONTROLL_BORDER_RADIUS = 4
local CONTROLL_ARROWSIZE = RiceUI.Scale.Size(24)

local point = Material("gui/point.png")
local cross = Material("rl_icons/xmark.png")
local zoom = Material("icon16/zoom.png")

local unit_1 = RiceUI.Scale.Size(1)
local unit_2 = RiceUI.Scale.Size(2)
local unit_4 = RiceUI.Scale.Size(4)
local unit_8 = RiceUI.Scale.Size(8)
local SIZE_12 = RiceUI.Scale.Size(12)

local function drawControll(self, w, h, Color, Corner, borderRadius)
    local Corner = Corner or {true, true, true, true}

    local x, y = self:LocalToScreen()

    draw.RoundedBoxEx(borderRadius or DEFAULT_CONTROLL_BORDER_RADIUS, 0, 0, w, h, self:RiceUI_GetColor("Stroke", "Control", "Default"), unpack(Corner))
    render.SetScissorRect(x, y + h - unit_1, x + w, y + h, true)
    draw.RoundedBoxEx(borderRadius or DEFAULT_CONTROLL_BORDER_RADIUS, 0, 0, w, h, self:RiceUI_GetColor("Stroke", "Control", "Secondary"), unpack(Corner))
    render.SetScissorRect(0, 0, 0, 0, false)

    draw.RoundedBoxEx(borderRadius or DEFAULT_CONTROLL_BORDER_RADIUS, unit_1, unit_1, w - unit_1 * 2, h - unit_1 * 2, Color or self:RiceUI_GetColor("Fill", "Control", "Default"), unpack(Corner))
end

local function drawControll_NoOutline(self, w, h, Color, Corner, borderRadius)
    local Corner = Corner or {true, true, true, true}

    draw.RoundedBoxEx(borderRadius or DEFAULT_CONTROLL_BORDER_RADIUS, 0, 0, w, h, Color or self:RiceUI_GetColor("Fill", "Control", "Default"), unpack(Corner))
end

registerClass("Modern", "Button", {
    Default = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        drawControll(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)
        draw.SimpleText(self.Text, getFont(self:GetFont()), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    NavgationButton = function(self, w, h, style)
        local color = self:RiceUI_GetColor("Fill", "NavigationButton", "Default")
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        if self:IsHovered() or self.Selected then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Hover") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end
        if self.Selected then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Selected") end

        drawControll_NoOutline(self, w, h, color)

        if self.Selected then
            draw.RoundedBox(8, 0, h / 4, RiceLib.hudScaleX(4), h / 2, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
        end

        draw.SimpleText(self.Text, self:GetFont(), RiceLib.hudScaleX(10), h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end,

    TextLeft = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        drawControll(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)
        draw.SimpleText(self.Text, getFont(self:GetFont()), unit_8, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end,

    Transparent = function(self, w, h, style)
        local color = self:RiceUI_GetColor("Fill", "Control", "Default")
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        drawControll_NoOutline(self, w, h, ColorAlpha(color, RiceUI.HoverAlpha(self, 20)), style.Corner)

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        draw.SimpleText(self.Text, getFont(self:GetFont()), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    TransparentHighlight = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        drawControll_NoOutline(self, w, h, ColorAlpha(textColor, RiceUI.HoverAlpha(self, 20) * 0.2), style.Corner)

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        draw.SimpleText(self.Text, getFont(self:GetFont()), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    Close = function(self, w, h, style)
        local color = self:RiceUI_GetColor("Fill", "Accent", "Critical")

        drawControll_NoOutline(self, w, h, ColorAlpha(color, RiceUI.HoverAlpha(self, 20)), {false, true, false, false}, DEFAULT_BODY_BORDER_RADIUS)

        surface.SetDrawColor(self:RiceUI_GetColor("Text", "Primary"))
        surface.SetMaterial(cross)
        surface.DrawTexturedRectRotated(w / 2, h / 2, h / 2, h / 2, 0)
    end,

    Accent = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "OnAccent", "Primary")
        local color = self:RiceUI_GetColor("Fill", "Accent", "Primary")

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "OnAccent", "Secondary") end
        if self:IsDown() then
            textColor = self:RiceUI_GetColor("Text", "OnAccent", "Disable")
            color = self:RiceUI_GetColor("Fill", "Accent", "Secondary")
        end

        drawControll_NoOutline(self, w, h, color, style.Corner)
        draw.SimpleText(self.Text, getFont(self:GetFont()), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    AccentTyped = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "OnAccent", "Primary")
        local color = self:RiceUI_GetColor("Fill", "Accent", style.AccentType or "Primary")

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "OnAccent", "Secondary") end
        if self:IsDown() then
            textColor = self:RiceUI_GetColor("Text", "OnAccent", "Disable")
            color = ColorAlpha(color, 240)
        end

        drawControll_NoOutline(self, w, h, color, style.Corner)
        draw.SimpleText(self.Text, getFont(self:GetFont()), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    ImageFilled = function(self, w, h, style)
        local color = style.Color or color_white
        local bgcolor = self:RiceUI_GetColor("Text", "Primary")
        local alpha = RiceUI.HoverAlpha(self, 20)

        drawControll_NoOutline(self, w, h, ColorAlpha(bgcolor, alpha * 0.05), style.Corner)

        local sizeMuti = RICEUI_SIZE_16

        if self:IsDown() then
            sizeMuti = RiceUI.Scale.Size(20)
        end

        surface.SetDrawColor(color)
        surface.SetMaterial(style.Image)
        surface.DrawTexturedRect(sizeMuti, sizeMuti, w - sizeMuti * 2, h - sizeMuti * 2)
    end,

    ComboChoice = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")
        local bgcolor = self:RiceUI_GetColor("Text", "Primary")
        local alpha = RiceUI.HoverAlpha(self, 20)

        if self.Selected then alpha = 255 end

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        drawControll_NoOutline(self, w, h, ColorAlpha(bgcolor, alpha * 0.05), style.Corner)

        if self.Selected then
            draw.RoundedBox(DEFAULT_BODY_BORDER_RADIUS, RICEUI_SIZE_4, RICEUI_SIZE_4, RICEUI_SIZE_4, h - RICEUI_SIZE_8, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
        end

        draw.SimpleText(self.Text, getFont(self:GetFont()), SIZE_12, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end,

    ScrollPanelGrip = function(self, w, h, style)
        local scrollPanel = self:GetParent()
        if not scrollPanel.ShowGripBar then return end
        if not scrollPanel:GetScrollable() then return end

        local color = ColorAlpha(self:RiceUI_GetColor("Text", "Disable"), 200)

        local fraction = scrollPanel:GetScroll() / scrollPanel:GetCanvasTall()
        local height = h * h / scrollPanel:GetCanvasTall() - RICEUI_SIZE_16

        draw.RoundedBox(DEFAULT_BODY_BORDER_RADIUS, 0, RICEUI_SIZE_8 + h * fraction, w / 2, height, color)
    end,

    Keybinder = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")
        local displayText

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        if self:GetValue() then
            displayText = string.upper(input.GetKeyName(self:GetValue()))
        end

        if self.KeyTrapping then
            displayText = "等待按键"
        end

        drawControll(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)
        draw.SimpleText(displayText, getFont(self:GetFont()), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    NumberWang_Button = function(self, w, h, style)
        surface.SetDrawColor(self:RiceUI_GetColor("Text", "Primary"))
        surface.SetMaterial(point)

        local size = h / 2
        if style.Scale then
            size = RiceUI.Scale.Size(style.Scale)
        end

        surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, self.Ang)
    end,
})

registerClass("Modern", "Switch",{
    Default = function(self, w, h, style)
        local raduis = h / 2 - RICEUI_SIZE_4
        local fraction = math.ease.InOutExpo(self.AnimationFraction)

        RiceLib.Render.StartStencil()

        drawCircle(h / 2, h / 2, h / 2 - unit_1, 32, color_white)
        drawCircle(w - h / 2, h / 2, h / 2 - unit_1, 32, color_white)
        surface.SetDrawColor(color_white)
        surface.DrawRect(h / 2 / 2 + RiceUI.Scale.Size(5), unit_1, w - h / 2 - RiceUI.Scale.Size(9), h - unit_2)

        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
        render.SetStencilFailOperation(STENCIL_ZERO)

        draw.RoundedBox(h, 0, 0, w, h, self:RiceUI_GetColor("Fill", "Control", "Switch"))

        render.SetStencilEnable(false)

        draw.RoundedBox(h, 0, 0, w, h, Color(0, 0, 0, 0):Lerp(self:RiceUI_GetColor("Fill", "Accent", "Primary"), fraction))

        local pos = raduis + RICEUI_SIZE_4 + fraction * (w - raduis * 2 - RICEUI_SIZE_8)
        drawCircle(pos, h / 2, raduis, 32, self:RiceUI_GetColor("Fill", "Control", "Switch"):Lerp(self:RiceUI_GetColor("Fill", "Card", "Primary"), fraction))
    end,
})

registerClass("Modern", "Entry", {
    Default = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")
        local statusColor = self:RiceUI_GetColor("Text", "Disable")
        local hasFocus = self:HasFocus()

        if hasFocus then statusColor = self:RiceUI_GetColor("Fill", "Accent", "Primary") end

        RiceLib.Render.StartStencil()

        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, w, h - unit_2)

        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

        drawControll(self, w, h + unit_2, statusColor, style.Corner)

        render.SetStencilCompareFunction(STENCIL_EQUAL)

        drawControll(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)

        render.SetStencilEnable(false)

        --draw.SimpleText(self:GetText(), RiceUI.Font.Get(getFont(self:GetFont())), unit_8, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        --[[ Text Cursor
        if hasFocus then
            surface.SetDrawColor(ColorAlpha(textColor, 255 * math.abs(math.sin(SysTime() * 6 % 360))))
            local len = 0

            for i = 1, self:GetCaretPos() do
                local w, _ = RiceLib.VGUI.TextWide(getFont(self:GetFont()), utf8.sub(self:GetText(), i, i))
                len = len + w
            end

            surface.DrawRect(unit_8 + len, 4, 1, h - 8)
        end]]

        if self:GetText() ~= "" then
            self:DrawTextEntryText( textColor, self:GetHighlightColor(), self:GetCursorColor() )
        else
            draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), unit_4, h / 2, self:RiceUI_GetColor("Text", "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end,
})

registerClass("Modern", "RL_NumberWang", {
    Default = function(self, w, h, style)
        local statusColor = self:RiceUI_GetColor("Text", "Disable")
        local textColor = self:RiceUI_GetColor("Text", "Primary")
        local hasFocus = self:HasFocus()

        if hasFocus then statusColor = self:RiceUI_GetColor("Fill", "Accent", "Primary") end

        RiceLib.Render.StartStencil()

        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, w, h - unit_2)

        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

        drawControll(self, w, h + unit_2, statusColor, style.Corner)

        render.SetStencilCompareFunction(STENCIL_EQUAL)

        drawControll(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)

        render.SetStencilEnable(false)

        if hasFocus then
            local len = unit_8

            for i = 1, self:GetCaretPos() do
                local w = RiceLib.VGUI.TextWide(self:GetFont(), utf8.sub(self:GetText(), i, i))

                len = len + w
            end
            draw.SimpleText(self:GetText(), self:GetFont(), unit_8, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(ColorAlpha(textColor, 255 * math.abs(math.sin(RealTime() * 4))) )
            surface.DrawRect(len, RICEUI_SIZE_4, RICEUI_SIZE_2, h - RICEUI_SIZE_8)
        else
            draw.SimpleText(self:GetValue(), self:GetFont(), unit_8, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end,
})

registerClass("Modern", "ComboBox", {
    Default = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        drawControll(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)

        draw.SimpleText(self.Text, getFont(self:GetFont()), SIZE_12, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(textColor)
        surface.SetMaterial(point)
        surface.DrawTexturedRect(w - h + CONTROLL_ARROWSIZE / 2, CONTROLL_ARROWSIZE / 2, h - CONTROLL_ARROWSIZE, h - CONTROLL_ARROWSIZE)
    end
})

registerClass("Modern", "RL_NumberCounter", {
    Default = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")
        local statusColor = self:RiceUI_GetColor("Text", "Disable")
        local hasFocus = self:HasFocus()

        if hasFocus then statusColor = self:RiceUI_GetColor("Fill", "Accent", "Primary") end

        RiceLib.Render.StartStencil()

        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, w, h - unit_2)

        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

        drawControll(self, w, h + unit_2, statusColor, style.Corner)

        render.SetStencilCompareFunction(STENCIL_EQUAL)

        drawControll(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)

        render.SetStencilEnable(false)

        draw.SimpleText(self:GetValue(), getFont(self:GetFont()), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if hasFocus then
            surface.SetDrawColor(ColorAlpha(textColor, 255 * math.abs(math.sin(SysTime() * 6 % 360))))
            local len = 0
            local textW = RiceLib.VGUI.TextWide(getFont(self:GetFont()), self:GetText())

            for i = 1, self:GetCaretPos() do
                local w, _ = RiceLib.VGUI.TextWide(getFont(self:GetFont()), utf8.sub(self:GetText(), i, i))
                len = len + w
            end

            surface.DrawRect(w / 2 + len - textW / 2, 4, 1, h - 8)
        end
    end,
})

registerClass("Modern", "Slider", {
    Default = function(self, w, h, style)
        local fraction = self.SlideFraction
        local x = w * fraction
        local barRaduis = h / 4

        draw.RoundedBox(h, 0, barRaduis + barRaduis / 2, w, barRaduis, self:RiceUI_GetColor("Text", "Disable"))
        draw.RoundedBox(h, 0, barRaduis + barRaduis / 2, w * fraction, barRaduis, self:RiceUI_GetColor("Fill", "Accent", "Primary"))

        drawCircle(x, h / 2, h / 2, 32, self:RiceUI_GetColor("Text", "Disable"))
        drawCircle(x, h / 2, h / 2 - unit_1, 32, self:RiceUI_GetColor("Fill", "Card", "Primary"))

        drawCircle(x, h / 2, barRaduis, 32, self:RiceUI_GetColor("Fill", "Accent", "Primary"))

        if self.ShowTextEnd > SysTime() then
            local textAlpha = 255 - math.TimeFraction(self.ShowTextEnd - 0.1, self.ShowTextEnd, SysTime()) * 255
            local text = self:GetValue()
            local font = getFont("RiceUI_32")

            surface.SetFont(font)
            local w, h = surface.GetTextSize(text)
            w = w + RICEUI_SIZE_16

            DisableClipping(true)

            draw.RoundedBox(borderRadius or DEFAULT_CONTROLL_BORDER_RADIUS, x - w / 2, -h, w, h, self:RiceUI_GetColor("Stroke", "Control", "Default"))
            draw.RoundedBox(borderRadius or DEFAULT_CONTROLL_BORDER_RADIUS, x + unit_1 - w / 2, -h + unit_1, w - unit_2, h - unit_2, self:RiceUI_GetColor("Fill", "Control", "Default"))

            draw.SimpleText(text, font, x, 0, ColorAlpha(self:RiceUI_GetColor("Text", "Primary"), textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

            DisableClipping(false)
        end
    end
})