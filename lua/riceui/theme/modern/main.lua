local colors = {
    white = {
        Text = {
            Primary = HSLToColor(0, 0, 0.15),
            Secondary = HSLToColor(0, 0, 0.39),
            Tertiary = HSLToColor(0, 0, 0.55),
            Disable = HSLToColor(0, 0, 0.63),
            OnAccent = {
                Primary = color_white,
                Secondary = RiceUI.AlphaPercent(color_white, 0.7),
                Disable = color_white
            }
        },

        Stroke = {
            Default = RiceUI.AlphaPercent(color_black, 0.05),
            Solid = HSLToColor(0, 0, 0.92),

            Control = {
                Default = RiceUI.AlphaPercent(color_black, 0.07),
                Secondary = RiceUI.AlphaPercent(color_black, 0.16),
            },

            Frame = {
                Primary = RiceUI.AlphaPercent(color_white, 0.75),
                Secondary = RiceUI.AlphaPercent(color_white, 0.35),
            }
        },

        Background = {
            Soild = {
                Primary = HSLToColor(0, 0, 0.95),
                Secondary = HSLToColor(0, 0, 0.95),
                Tertiary = HSLToColor(0, 0, 0.95),
            }
        },

        Fill = {
            Card = {
                Primary = color_white,
                Secondary = HSLToColor(0, 0, 0.96),
            },

            Frame = {
                Primary = ColorAlpha(color_white, 150),
                Secondary = ColorAlpha(color_white, 75),
            },

            Layer = ColorAlpha(color_white, 50),

            NavigationButton = {
                Default = ColorAlpha(color_white, 0),
                Hover = ColorAlpha(color_white, 50),
                Selected = ColorAlpha(color_white, 75)
            },

            Control = {
                Default = RiceUI.AlphaPercent(color_white, 0.7),
                Secondary = RiceUI.AlphaPercent(HSLToColor(0, 0, 0.97), 0.5),
                Tertiary = RiceUI.AlphaPercent(HSLToColor(0, 0, 0.97), 0.3),
                Active = color_white
            },

            Accent = {
                Primary = Color(0, 95, 184),
                Secondary = Color(26, 111, 191),
                Tertiary = Color(51, 127, 198),
                Disable = HSLToColor(0, 0, 0.78),

                Critical = Color(196, 43, 28),
                CriticalBackground = Color(253, 231, 233),

                Success = Color(15, 123, 15),
                SuccessBackground = Color(223, 246, 221),
            }
        },
    },
    black = {
        Text = {
            Primary = color_white,
            Secondary = HSLToColor(0, 0, 0.81),
            Tertiary = HSLToColor(0, 0, 0.62),
            Disable = HSLToColor(0, 0, 0.47),

            OnAccent = {
                Primary = HSLToColor(0, 0, 0),
                Secondary = RiceUI.AlphaPercent(HSLToColor(0, 0, 0), 0.5),
                Disable = RiceUI.AlphaPercent(HSLToColor(0, 0, 0), 0.53)
            }
        },

        Stroke = {
            Default = RiceUI.AlphaPercent(color_black, 0.1),
            Solid = HSLToColor(0, 0, 0.11),

            Control = {
                Default = RiceUI.AlphaPercent(HSLToColor(0, 0, 1), 0.04),
                Secondary = RiceUI.AlphaPercent(HSLToColor(0, 0, 1), 0.06),
            },

            Frame = Color(50, 50, 50, 191)
        },

        Background = {
            Soild = {
                Primary = Color(32, 32, 32),
                Secondary = Color(28, 28, 28),
                Tertiary = Color(40, 40, 40),
            }
        },

        Fill = {
            Card = {
                Primary = HSLToColor(0, 0, 0.215),
                Secondary = HSLToColor(0, 0, 0.20)
            },

            Frame = ColorAlpha(HSLToColor(0, 0, 0.15), 250),
            Layer = ColorAlpha(color_black, 30),

            NavigationButton = {
                Default = ColorAlpha(color_white, 0),
                Hover = ColorAlpha(color_white, 5),
                Selected = ColorAlpha(color_white, 10)
            },

            Control = {
                Default = RiceUI.AlphaPercent(color_white, 0.02),
                Secondary = RiceUI.AlphaPercent(color_white, 0.04),
                Tertiary = RiceUI.AlphaPercent(color_white, 0.01),
                Active = RiceUI.AlphaPercent(Color(30, 30, 30), 0.7)
            },

            Accent = {
                Primary = Color(96, 205, 255),
                Secondary = Color(91, 189, 233),
                Tertiary = Color(86, 173, 213),
                Disable = HSLToColor(0, 0, 0.30),

                Critical = Color(255, 153, 164),
                CriticalBackground = Color(68, 39, 38),

                Success = Color(108, 203, 95),
                SuccessBackground = Color(57, 61, 27),
            }
        },
    }
}

RiceUI.ThemeNT.DefineTheme("Modern", {
    Base = "modern",
    BaseNT = false,

    Colors = colors
})

local DEFAULT_BORDER_RADIUS = 6

local function drawBox(self, w, h, Color, Corner, borderRadius)
    local Corner = Corner or {true, true, true, true}

    draw.RoundedBoxEx(borderRadius or DEFAULT_BORDER_RADIUS, 0, 0, w, h, Color or self:RiceUI_GetColor("Fill", "Control", "Prmiary"), unpack(Corner))
end


local point = Material("gui/point.png")
local cross = Material("rl_icons/xmark.png")
local zoom = Material("icon16/zoom.png")
local unit_2 = RiceLib.hudScaleY(2)
local unit_8 = RiceLib.hudScaleY(8)


RiceUI.ThemeNT.RegisterClass("Modern", "Panel",{
    Default = function(self, w, h, style)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, w, h)
    end,

    Shadow = function(self, w, h, style)
        local corner = style.Corner or {true, true, true, true}

        draw.RoundedBoxEx(8, 0, 0, w, h, ColorAlpha(color_black, 100), unpack(corner))
        draw.RoundedBoxEx(8, 0, 0, w, h - unit_2, color_white, unpack(corner))
    end,

    ShadowExpensive = function(self, w, h, style)
        local corner = style.Corner or {true, true, true, true}
        local shadowData = table.Copy(style.Shadow) or {1, 1, 1, 150, 20, 1}

        local x, y = self:LocalToScreen()
        local parent = self:GetParent()
        local _shadowOnly, startY = parent:LocalToScreen()
        local sizeW, sizeH = parent:GetSize()
        RiceUI.Render.StartShadow()
        draw.RoundedBoxEx(6, x + unit_2, y + unit_2, w - unit_2 * 2, h  - unit_2 * 2, color_white, unpack(corner))
        RiceUI.Render.EndShadow(unpack( table.Add(shadowData, {0, startY, ScrW(), sizeH}) ))

        draw.RoundedBoxEx(8, 0, 0, w, h, style.Color or color_white, unpack(corner))
    end,

    Acrylic = function(self, w, h, style)
        local level = style.Level or "Primary"

        RiceLib.Render.StartStencil()

        RiceLib.Draw.RoundedBox(8, 0, 0, w, h, color_white)

        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

        RiceLib.VGUI.blurPanel(self, 8)

        RiceLib.Render.StartStencil()

        RiceLib.Draw.RoundedBox(6, unit_2, unit_2, w - unit_2 * 2, h - unit_2 * 2, color_white)

        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
        render.SetStencilFailOperation(STENCIL_ZERO)

        draw.RoundedBoxEx(8, 0, 0, w, h, self:RiceUI_GetColor("Stroke", "Frame", level), true, true, true, true)

        render.SetStencilEnable(false)

        draw.RoundedBoxEx(8, 0, 0, w, h, self:RiceUI_GetColor("Fill", "Frame", level), true, true, true, true)
    end,
})

RiceUI.ThemeNT.RegisterClass("Modern", "Frame",{
    Default = function(self, w, h, style)
        draw.RoundedBox(8, 0, 0, w, h - unit_2, color_white)
    end,

    Acrylic = function(self, w, h, style)
        RiceLib.Render.StartStencil()

        RiceLib.Draw.RoundedBox(8, 0, 0, w, h, color_white)

        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

        RiceLib.VGUI.blurPanel(self, 8)

        render.SetStencilCompareFunction(STENCIL_INVERT)

        local thickness = RiceLib.hudScaleY(2)

        DisableClipping(true)
        draw.RoundedBox(8, -thickness, -thickness, w + thickness * 2, h + thickness * 2, self:RiceUI_GetColor("Stroke", "Frame"))
        DisableClipping(false)

        render.SetStencilEnable(false)

        draw.RoundedBox(8, 0, 0, w, h, self:RiceUI_GetColor("Fill", "Frame"))
    end,

    Transparent = function(self, w, h, style)
        RiceLib.Render.StartStencil()

        RiceLib.Draw.RoundedBox(8, 0, 0, w, h, color_white)

        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilCompareFunction(STENCIL_INVERT)

        local thickness = RiceLib.hudScaleY(3)

        DisableClipping(true)
        draw.RoundedBox(8, -thickness, -thickness, w + thickness * 2, h + thickness * 2, self:RiceUI_GetColor("Fill", "Layer"))
        DisableClipping(false)

        render.SetStencilEnable(false)

        draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 255, 10))
    end,
})

RiceUI.ThemeNT.RegisterClass("Modern", "NoDraw",{
    Default = function(self, w, h, style) end,
    Custom = function(self, w, h, style)
        style.Draw(self, w, h, style)
    end
})

RiceUI.ThemeNT.RegisterClass("Modern", "Button", {
    Default = function(self, w, h, style)
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        drawBox(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then color = self:RiceUI_GetColor("Text", "Tertiary") end

        draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    Transparent = function(self, w, h, style)
        local color = self:RiceUI_GetColor("Fill", "Control", "Default")
        local textColor = self:RiceUI_GetColor("Text", "Primary")

        drawBox(self, w, h, ColorAlpha(color, RiceUI.HoverAlpha(self, 20)), style.Corner)

        if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end
        if self:IsDown() then textColor = self:RiceUI_GetColor("Text", "Tertiary") end

        draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    Close = function(self, w, h, style)
        local color = self:RiceUI_GetColor("Fill", "Accent", "Critical")

        drawBox(self, w, h, ColorAlpha(color, RiceUI.HoverAlpha(self, 20)), {false, true, false, false})

        surface.SetDrawColor(self:RiceUI_GetColor("Text", "Primary"))
        surface.SetMaterial(cross)
        surface.DrawTexturedRectRotated(w / 2, h / 2, h / 2, h / 2, 0)
    end
})

RiceUI.ThemeNT.RegisterClass("Modern", "Entry", {
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

        drawBox(self, w, h + unit_2, statusColor, style.Corner)

        render.SetStencilCompareFunction(STENCIL_EQUAL)

        drawBox(self, w, h, self:RiceUI_GetColor("Fill", "Control", "Default"), style.Corner)

        render.SetStencilEnable(false)

        draw.SimpleText(self:GetText(), RiceUI.Font.Get(self:GetFont()), unit_8, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        -- Text Cursor
        if hasFocus then
            surface.SetDrawColor(ColorAlpha(textColor, 255 * math.abs(math.sin(SysTime() * 6 % 360))))
            local len = 0

            for i = 1, self:GetCaretPos() do
                local w, _ = RiceLib.VGUI.TextWide(self:GetFont(), utf8.sub(self:GetText(), i, i))
                len = len + w
            end

            surface.DrawRect(unit_8 + len, 4, 1, h - 8)
        end
    end,
})