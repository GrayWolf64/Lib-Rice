local tbl = {}

tbl.Color = {
    white = Color(250, 250, 250),
    white1 = Color(250, 250, 250),
    white2 = Color(245, 245, 245),
    white3 = Color(240, 240, 240),
    black = HSLToColor(0, 0, 0.2),
    black1 = HSLToColor(0, 0, 0.2),
    black2 = HSLToColor(0, 0, 0.18),
    black3 = HSLToColor(0, 0, 0.16),
}

tbl.TextColor = {
    white = Color(50, 50, 50),
    black = Color(250, 250, 250),
}

tbl.OutlineColor = {
    white = HSLToColor(0, 0, 0.8),
    white1 = HSLToColor(0, 0, 0.8),
    white2 = HSLToColor(0, 0, 0.75),
    white3 = HSLToColor(0, 0, 0.7),
    black = HSLToColor(0, 0, 0.3),
    black1 = HSLToColor(0, 0, 0.3),
    black2 = HSLToColor(0, 0, 0.3),
    black3 = HSLToColor(0, 0, 0.3),
}

tbl.BarColor = {
    white1 = Color(230, 230, 230),
    white2 = Color(220, 220, 220),
    white3 = Color(210, 210, 210),
    black = HSLToColor(0, 0, 0.15),
    black1 = HSLToColor(0, 0, 0.13),
    black2 = HSLToColor(0, 0, 0.11),
    black3 = HSLToColor(0, 0, 0.09),
}

tbl.HoverColor = {
    white = HSLToColor(0, 0, 0.93),
    white1 = HSLToColor(0, 0, 0.93),
    white2 = HSLToColor(0, 0, 0.91),
    white3 = HSLToColor(0, 0, 0.89),
    black = HSLToColor(0, 0, 0.35),
    black1 = HSLToColor(0, 0, 0.35),
    black2 = HSLToColor(0, 0, 0.40),
    black3 = HSLToColor(0, 0, 0.45),
}

tbl.CloseButtonColor = {
    white = Color(255, 0, 0),
    black = Color(255, 0, 0),
}

tbl.FocusColor = {
    white = Color(64, 158, 255),
    black = Color(96, 205, 255),
}

tbl.DisableColor = {
    white = Color(200, 200, 200),
    white1 = Color(200, 200, 200),
    white2 = Color(200, 200, 200),
    white3 = Color(200, 200, 200),
    black = Color(70, 70, 70),
    black1 = Color(70, 70, 70),
    black2 = Color(70, 70, 70),
    black3 = Color(70, 70, 70),
}

tbl.ShadowAlpha = {
    white = 50,
    black = 150,
}

tbl.DefaultCurver = 8

tbl.Colors = {
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

            Frame = RiceUI.AlphaPercent(color_white, 0.75)
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

            Frame = ColorAlpha(color_white, 150),
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

--[[

    Drawing functions

]]
--
local point = Material("gui/point.png")
local cross = Material("rl_icons/xmark.png")
local zoom = Material("icon16/zoom.png")

function tbl.DrawOutline(self, w, h, Color, Corner)
    local Corner = Corner or self.Theme.Corner or {true, true, true, true}

    draw.RoundedBoxEx(self.Theme.Curver or tbl.DefaultCurver, 0, 0, w, h, Color or RiceUI.GetColor(tbl, self, "Outline"), unpack(Corner))
end

function tbl.DrawInnerBox(self, w, h, Color, Corner)
    local Corner = Corner or self.Theme.Corner or {true, true, true, true}

    local thick = RiceLib.hudScaleY(1)

    if isnumber(self.Theme.Border) then
        thick = RiceLib.hudScaleY(self.Theme.Border)
    end

    draw.RoundedBoxEx(self.Theme.Curver or tbl.DefaultCurver, thick, thick, w - (thick * 2), h - (thick * 2), Color or RiceUI.GetColor(tbl, self), unpack(Corner))
end

function tbl.DrawOutlineBox(self, w, h, Color, Corner)
    tbl.DrawOutline(self, w, h, Color or RiceUI.GetColor(tbl, self, "Outline"), Corner)
    tbl.DrawInnerBox(self, w, h, nil, Corner)
end

function tbl.DrawBox(self, w, h, Color, Corner)
    local Corner = Corner or self.Theme.Corner or {true, true, true, true}

    draw.RoundedBoxEx(self.Theme.Curver or tbl.DefaultCurver, 0, 0, w, h, Color or RiceUI.GetColor(tbl, self), unpack(Corner))
end

function tbl.DrawButton(self, w, h, Color, Corner)
    tbl.DrawOutlineBox(self, w, h, Color, Corner)

    if self:IsHovered() then
        tbl.DrawBox(self, w, h, ColorAlpha(RiceUI.GetColor(tbl, self, "Hover"), 150), Corner)
    end
end

function tbl.DrawButton_NT(self, w, h, _, Corner)
    local stroke_color = self:RiceUI_GetColor("Stroke", "Control", "Default")
    local body_color = self:RiceUI_GetColor("Fill", "Control", "Default")

    if self:IsHovered() then body_color = self:RiceUI_GetColor("Fill", "Control", "Secondary") end
    if self:IsDown() then body_color = self:RiceUI_GetColor("Fill", "Control", "Tertiary") end

    RiceLib.Render.StartStencil()

    RiceLib.Draw.RoundedBox(8, 1, 1, w - 2, h - 2, color_white, Corner)

    render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    tbl.DrawBox(self, w, h, stroke_color, Corner)

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    surface.SetDrawColor(body_color)
    surface.DrawRect(0, 0, w, h)

    render.SetStencilEnable(false)
end

function tbl.DrawEntry(self, w, h, Color)
    local color = RiceUI.GetColor(tbl, self, "Outline")

    if self:HasFocus() then
        color = RiceUI.GetColorBase(tbl, self, "Focus")
    end

    tbl.DrawOutlineBox(self, w, h, color)
end

function tbl.DrawTextCursor(self, w, h)
    if self:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl, self, "Text"), 255 * math.abs(math.sin(SysTime() * 6 % 360))))
        local len = 0

        for i = 1, self:GetCaretPos() do
            local w, _ = RiceLib.VGUI.TextWide(self:GetFont(), utf8.sub(self:GetText(), i, i))
            len = len + w
        end

        surface.DrawRect(RiceLib.hudScaleX(10) + len, 4, 1, h - 8)
    end
end

function tbl.ShadowText(self, w, h)
    local offsetx, offsety = RiceLib.hudScale(2, 2)
    draw.SimpleText(self.Text, self.Font, offsetx, offsety, Color(0, 0, 0, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self.Text, self.Font, 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

--[[

    Layouts

]]
--
function tbl.NoDraw()
end

function tbl.Panel(self, w, h)
    if self.DrawBorder or self:GetParent():GetClassName() ~= "CGModBase" and not self.Theme.NoBorder then
        tbl.DrawOutlineBox(self, w, h)

        return
    end

    tbl.DrawBox(self, w, h)
end

function tbl.Layer(self, w, h)
    local color = self:RiceUI_GetColor("Fill", "Layer")
    local borderColor = color

    if self.Theme.Border then
        borderColor = self:RiceUI_GetColor(self.Theme.BorderColor)
    end

    tbl.DrawOutline(self, w, h, borderColor)
    tbl.DrawInnerBox(self, w, h, color)
end

function tbl.PanelNT(self, w, h)
    local color = self:RiceUI_GetColor(self.Theme.ColorNT)
    local borderColor = color

    if self.Theme.Border then
        borderColor = self:RiceUI_GetColor(self.Theme.BorderColor)
    end

    tbl.DrawOutline(self, w, h, borderColor)
    tbl.DrawInnerBox(self, w, h, color)
end

function tbl.RL_Frame(self, w, h)
    if self.DrawBorder or self:GetParent():GetClassName() ~= "CGModBase" and not self.Theme.NoBorder then
        DisableClipping(true)
        draw.RoundedBox(self.Theme.Curver or 5, -1, -1, w + 2, h + 2, RiceUI.GetColor(tbl, self, "Bar"))
        DisableClipping(false)
    end

    tbl.DrawBox(self, w, h, RiceUI.GetColor(tbl, self, "Bar"))
    draw.RoundedBoxEx(self.Theme.Curver or tbl.DefaultCurver, 0, self.Title:GetTall() + 10, w, h - self.Title:GetTall() - 10, RiceUI.GetColor(tbl, self), false, false, true, true)
end

function tbl.RL_Frame2(self, w, h)
    RiceLib.Render.StartStencil()

    RiceLib.Draw.RoundedBox(8, 0, 0, w, h, color_white)

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    RiceLib.VGUI.blurPanel(self, 8)

    render.SetStencilCompareFunction(STENCIL_INVERT)

    local thickness = RiceLib.hudScaleY(2)

    DisableClipping(true)
    draw.RoundedBoxEx(self.Theme.Curver or tbl.DefaultCurver, -thickness, -thickness, w + thickness * 2, h + thickness * 2, self:RiceUI_GetColor("Stroke", "Frame"), true, true, true, true)
    DisableClipping(false)

    render.SetStencilEnable(false)

    draw.RoundedBoxEx(self.Theme.Curver or tbl.DefaultCurver, 0, 0, w, h, self:RiceUI_GetColor("Fill", "Frame"), true, true, true, true)
end

function tbl.ScrollPanel_VBar(self, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, self, "Bar"))
    surface.DrawRect(0, 0, w, h)
end

function tbl.ScrollPanel_VBar_Grip(self, w, h)
    tbl.DrawButton(self, w, h, _, {false, false, false, false})
end

function tbl.Form(self, w, h)
    tbl.DrawButton(self, w, h)

    if self.Value then
        draw.SimpleText(self.Value, self:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(self.Text, self:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, self, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local h = self.h
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, self, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, self.a_pointang)
end

function tbl.Spacer(self, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, self, "Outline"))
    surface.DrawRect(0, h / 2 - RiceLib.hudOffsetY(1), w, RiceLib.hudOffsetY(2))
end

--[[

    Inputs

]]
--
-- Buttons
function tbl.Button(self, w, h)
    tbl.DrawButton(self, w, h)
    local color = RiceUI.GetColorBase(tbl, self, "Text")

    if self:IsDown() then
        color = RiceUI.GetColorBase(tbl, self, "Focus")
    end

    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.Button_NT(self, w, h)
    tbl.DrawButton_NT(self, w, h)
    local color = self:RiceUI_GetColor("Text", "Primary")

    if self:IsHovered() then color = self:RiceUI_GetColor("Text", "Secondary") end
    if self:IsDown() then color = self:RiceUI_GetColor("Text", "Tertiary") end

    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.Button_Accent(self, w, h)
    local color_main = self:RiceUI_GetColor("Fill", "Accent", "Primary")
    local color_text = self:RiceUI_GetColor("Text", "OnAccent", "Primary")

    if self:IsHovered() then
        color_main = self:RiceUI_GetColor("Fill", "Accent", "Secondary")
    end

    if self:IsDown() then
        color_main = self:RiceUI_GetColor("Fill", "Accent", "Tertiary")
        color_text = self:RiceUI_GetColor("Text", "OnAccent", "Secondary")
    end

    tbl.DrawBox(self, w, h, color_main)
    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.Button_Accent_Critical(self, w, h)
    local color_main = self:RiceUI_GetColor("Fill", "Accent", "Critical")
    local color_text = self:RiceUI_GetColor("Text", "OnAccent", "Primary")

    if self:IsHovered() then
        color_main = self:RiceUI_GetColor("Fill", "Accent", "Critical")
    end

    if self:IsDown() then
        color_main = self:RiceUI_GetColor("Fill", "Accent", "Critical")
        color_text = self:RiceUI_GetColor("Text", "OnAccent", "Secondary")
    end

    tbl.DrawBox(self, w, h, color_main)
    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.Button_Accent_Success(self, w, h)
    local color_main = self:RiceUI_GetColor("Fill", "Accent", "Success")
    local color_text = self:RiceUI_GetColor("Text", "OnAccent", "Primary")

    if self:IsHovered() then
        color_main = self:RiceUI_GetColor("Fill", "Accent", "Success")
    end

    if self:IsDown() then
        color_main = self:RiceUI_GetColor("Fill", "Accent", "Success")
        color_text = self:RiceUI_GetColor("Text", "OnAccent", "Secondary")
    end

    tbl.DrawBox(self, w, h, color_main)
    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.Button_TextLeft(self, w, h)
    tbl.DrawButton(self, w, h)
    local color = RiceUI.GetColorBase(tbl, self, "Text")

    if self:IsDown() then
        color = RiceUI.GetColorBase(tbl, self, "Focus")
    end

    draw.SimpleText(self.Text, self:GetFont(), RiceLib.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.TransButton(self, w, h)
    local color = RiceUI.GetColor(tbl, self, "Hover", "closeButton")
    tbl.DrawBox(self, w, h, ColorAlpha(color, RiceUI.HoverAlpha(self, 20)))
    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_TextLeft(self, w, h)
    local color = RiceUI.GetColor(tbl, self, "Hover", "closeButton")
    tbl.DrawBox(self, w, h, ColorAlpha(color, RiceUI.HoverAlpha(self, 20)))
    local color = RiceUI.GetColorBase(tbl, self, "Text")

    if self:IsDown() then
        color = RiceUI.GetColorBase(tbl, self, "Focus")
    end

    draw.SimpleText(self.Text, self:GetFont(), RiceLib.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_F(self, w, h)
    local color = RiceUI.GetColor(tbl, self, "Hover", "closeButton")

    if self:IsHovered() then
        self.HoverAlpha = 255
    else
        self.HoverAlpha = 0
    end

    tbl.DrawBox(self, w, h, ColorAlpha(color, self.HoverAlpha))
    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.CloseButton(self, w, h)
    local color = RiceUI.GetColorBase(tbl, self, "CloseButton")

    tbl.DrawBox(self, w, h, ColorAlpha(color, RiceUI.HoverAlpha(self, 20)), {false, true, false, false})

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, self, "Text"))
    surface.SetMaterial(cross)
    surface.DrawTexturedRectRotated(w / 2, h / 2, h / 2, h / 2, 0)
end

--[[

    Navgation View

]]

function tbl.Navgation_Button(self, w, h)
    local color = self:RiceUI_GetColor("Fill", "NavigationButton", "Default")
    if self:IsHovered() then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Hover") end
    if self.Selected then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Selected") end

    tbl.DrawBox(self, w, h, color)

    if self.Selected then
        draw.RoundedBox(8, 0, h / 4, RiceLib.hudScaleX(4), h / 2, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
    end

    draw.SimpleText(self.Text, self:GetFont(), RiceLib.hudScaleX(10), h / 2, self:RiceUI_GetColor("Text", "Primary"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.Navgation_Button_Transparent(self, w, h)
    local color = self:RiceUI_GetColor("Fill", "NavigationButton", "Default")
    if self:IsHovered() then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Hover") end
    if self.Selected then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Selected") end

    tbl.DrawBox(self, w, h, color)

    if self.Selected then
        draw.RoundedBox(8, 0, h / 4, RiceLib.hudScaleX(4), h / 2, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
    end

    draw.SimpleText(self.Text, self:GetFont(), RiceLib.hudScaleX(10), h / 2, self:RiceUI_GetColor("Text", "Primary"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.Navgation_Combo(self, w, h)
    local color = self:RiceUI_GetColor("Fill", "NavigationButton", "Default")
    if self:IsHovered() then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Hover") end
    if self.Selected then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Selected") end

    tbl.DrawBox(self, w, h, color)

    if self.Selected then
        draw.RoundedBox(8, 0, self.Init_H / 4, RiceLib.hudScaleX(4), self.Init_H / 2, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
    end

    draw.SimpleText(self.Text, self:GetFont(), RiceLib.hudScaleX(10), h / 2, self:RiceUI_GetColor("Text", "Primary"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

--NumberWang
function tbl.RL_NumberWang(self, w, h)
    local color = RiceUI.GetColor(tbl, self, "Outline")

    if self:HasFocus() then
        color = RiceUI.GetColorBase(tbl, self, "Focus")
    end

    tbl.DrawOutlineBox(self, w, h, color)
    draw.SimpleText(self:GetValue(), self:GetFont(), 10, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    tbl.DrawTextCursor(self, w, h)
end

function tbl.NumberWang_Button(self, w, h)
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, self, "Text"))
    surface.SetMaterial(point)
    local size = h / 2 + RiceLib.hudScaleY(self.Theme.Scale or 0)
    surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, self.Theme.Ang)
end

--NumberCounter
function tbl.RL_NumberCounter(self, w, h)
    local color = RiceUI.GetColor(tbl, self, "Outline")

    if self:HasFocus() then
        color = RiceUI.GetColorBase(tbl, self, "Focus")
    end

    tbl.DrawOutlineBox(self, w, h, color)
    draw.SimpleText(self:GetValue(), self:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if self:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl, self, "Text"), 255 * math.abs(math.sin(SysTime() * 6 % 360))))
        local len = 0
        local textW = RiceLib.VGUI.TextWide(self:GetFont(), self:GetText())

        for i = 1, self:GetCaretPos() do
            local w, _ = RiceLib.VGUI.TextWide(self:GetFont(), utf8.sub(self:GetText(), i, i))
            len = len + w
        end

        surface.DrawRect(w / 2 + len - textW / 2, 4, 1, h - 8)
    end
end

--Entry
function tbl.Entry(self, w, h)
    tbl.DrawEntry(self, w, h)

    if self:IsMultiline() then
        draw.DrawText(self:GetText(), self:GetFont(), 10, 5, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        tbl.DrawTextCursor(self, w, h)

        return
    end

    if self:GetValue() == "" then
        draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), 10, h / 2, self:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(self:GetText(), self:GetFont(), 10, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    tbl.DrawTextCursor(self, w, h)
end

function tbl.Entry_Search(self, w, h)
    tbl.DrawEntry(self, w, h)

    if self:GetValue() == "" then
        draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), 10, h / 2, self:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, self, "Text"))
    surface.SetMaterial(zoom)
    surface.DrawTexturedRect(0, 0, w, h)
    draw.SimpleText(self:GetText(), self:GetFont(), 32, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    tbl.DrawTextCursor(self, w, h)
end

--Switch
function tbl.Switch(self, w, h)
    RiceLib.Draw.Circle(h / 2, h / 2, h / 2, 32, self:GetColor())
    RiceLib.Draw.Circle(w - h / 2, h / 2, h / 2, 32, self:GetColor())
    surface.SetDrawColor(self:GetColor())
    surface.DrawRect(h / 2 / 2 + 4, 0, w - h / 2 - 8, h)
    RiceLib.Draw.Circle(h / 2 + self.togglePos, h / 2, h / 2 - 2, 32, Color(250, 250, 250))
end

--Slider
function tbl.Slider(self, w, h)
    local pos = w * self:GetSlideX()
    draw.RoundedBox(32, 0, h / 3, pos, h / 3, RiceUI.GetColorBase(tbl, self, "Focus"))
    draw.RoundedBox(32, pos, h / 3, w - pos, h / 3, RiceUI.GetColor(tbl, self, "Disable"))
    DisableClipping(true)
    RiceLib.Draw.Circle(pos, h / 2, h / 2, 32, RiceUI.GetColorBase(tbl, self, "Focus"))
    RiceLib.Draw.Circle(pos, h / 2, h / 2 - 2, 32, Color(250, 250, 250))

    if self:GetDragging() then self.TextAlpha = 255 end

    if self.TextAlpha > 0 then
        draw.SimpleText(tostring(self:GetValue()), "RiceUI_32", pos, -h / 2, ColorAlpha(RiceUI.GetColorBase(tbl, self, "Text"), self.TextAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.TextAlpha = math.Clamp(self.TextAlpha - 20 * (RealFrameTime() * 100), 0, 255)

    DisableClipping(false)
end

--CheckBox
function tbl.CheckBox(self, w, h)
    tbl.DrawButton(self, w, h)
    draw.RoundedBox(self.Theme.Curver or 5, 4, 4, w - 8, h - 8, ColorAlpha(RiceUI.GetColorBase(tbl, self, "Focus"), self.a_Alpha))
end

local alpha_grid = Material("gui/alpha_grid.png")

function tbl.ColorButton(self, w, h)
    tbl.DrawButton(self, w, h)
    local x, y = RiceLib.hudScale(12, 12)
    surface.SetMaterial(alpha_grid)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(x / 2, y / 2, w - x, h - y)
    surface.SetDrawColor(self.Value)
    surface.DrawRect(x / 2, y / 2, w - x, h - y)
end

--ComboBox
function tbl.RL_Combo(self, w, h)
    local Corner = {true, true, true, true}

    if self.Openning then
        Corner = {true, true, false, false}
    end

    tbl.DrawButton(self, w, h, nil, Corner)

    if self.Value then
        draw.SimpleText(self.Value, self:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, self, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(self.Text, self:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, self, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, self, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, self.a_pointang)
end

function tbl.RL_Combo_Choice(self, w, h)
    local color = RiceUI.GetColor(tbl, self, "Hover", "closeButton")

    if not self.HoverAlpha then
        self.HoverAlpha = 0
    end

    if self:IsHovered() then
        self.HoverAlpha = math.min(self.HoverAlpha + (self.Theme.Speed or 20) * (RealFrameTime() * 100), 255)
    else
        self.HoverAlpha = math.max(self.HoverAlpha - (self.Theme.Speed or 20) * (RealFrameTime() * 100), 0)
    end

    tbl.DrawBox(self, w, h, ColorAlpha(color, self.HoverAlpha))
    local color = RiceUI.GetColorBase(tbl, self, "Text")

    if self:IsDown() or self.Selected then
        color = RiceUI.GetColorBase(tbl, self, "Focus")
    end

    draw.SimpleText(self.Text, self:GetFont(), RiceLib.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

return tbl