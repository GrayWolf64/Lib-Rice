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
                Disable = HSLToColor(0, 0, 0.78)
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
            }
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

            Frame = ColorAlpha(HSLToColor(0, 0, 0.15), 240),
            Layer = ColorAlpha(color_white, 10),

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
                Disable = HSLToColor(0, 0, 0.30)
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

function tbl.DrawOutline(pnl, w, h, Color, Corner)
    local Corner = Corner or pnl.Theme.Corner or {true, true, true, true}

    draw.RoundedBoxEx(pnl.Theme.Curver or tbl.DefaultCurver, 0, 0, w, h, Color or RiceUI.GetColor(tbl, pnl, "Outline"), unpack(Corner))
end

function tbl.DrawInnerBox(pnl, w, h, Color, Corner)
    local Corner = Corner or pnl.Theme.Corner or {true, true, true, true}

    local thick = RL.hudScaleY(1)

    if isnumber(pnl.Theme.Border) then
        thick = RL.hudScaleY(pnl.Theme.Border)
    end

    draw.RoundedBoxEx(pnl.Theme.Curver or tbl.DefaultCurver, thick, thick, w - (thick * 2), h - (thick * 2), Color or RiceUI.GetColor(tbl, pnl), unpack(Corner))
end

function tbl.DrawOutlineBox(pnl, w, h, Color, Corner)
    tbl.DrawOutline(pnl, w, h, Color or RiceUI.GetColor(tbl, pnl, "Outline"), Corner)
    tbl.DrawInnerBox(pnl, w, h, _, Corner)
end

function tbl.DrawBox(pnl, w, h, Color, Corner)
    local Corner = Corner or pnl.Theme.Corner or {true, true, true, true}

    draw.RoundedBoxEx(pnl.Theme.Curver or tbl.DefaultCurver, 0, 0, w, h, Color or RiceUI.GetColor(tbl, pnl), unpack(Corner))
end

function tbl.DrawButton(pnl, w, h, Color, Corner)
    tbl.DrawOutlineBox(pnl, w, h, Color, Corner)

    if pnl:IsHovered() then
        tbl.DrawBox(pnl, w, h, ColorAlpha(RiceUI.GetColor(tbl, pnl, "Hover"), 150), Corner)
    end
end

function tbl.DrawButton_NT(self, w, h, _, Corner)
    local stroke_color = self:RiceUI_GetColor("Stroke", "Control", "Default")
    local body_color = self:RiceUI_GetColor("Fill", "Control", "Default")

    if self:IsHovered() then body_color = self:RiceUI_GetColor("Fill", "Control", "Secondary") end
    if self:IsDown() then body_color = self:RiceUI_GetColor("Fill", "Control", "Tertiary") end

    RL.Render.StartStencil()

    RL.Draw.RoundedBox(8, 1, 1, w - 2, h - 2, color_white, Corner)

    render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    tbl.DrawBox(self, w, h, stroke_color, Corner)

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    surface.SetDrawColor(body_color)
    surface.DrawRect(0, 0, w, h)

    render.SetStencilEnable(false)
end

function tbl.DrawEntry(pnl, w, h, Color)
    local color = RiceUI.GetColor(tbl, pnl, "Outline")

    if pnl:HasFocus() then
        color = RiceUI.GetColorBase(tbl, pnl, "Focus")
    end

    tbl.DrawOutlineBox(pnl, w, h, color)
end

function tbl.DrawTextCursor(pnl, w, h)
    if pnl:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl, pnl, "Text"), 255 * math.abs(math.sin(SysTime() * 6 % 360))))
        local len = 0

        for i = 1, pnl:GetCaretPos() do
            local w, _ = RL.VGUI.TextWide(pnl:GetFont(), utf8.sub(pnl:GetText(), i, i))
            len = len + w
        end

        surface.DrawRect(RL.hudScaleX(10) + len, 4, 1, h - 8)
    end
end

function tbl.ShadowText(pnl, w, h)
    local offsetx, offsety = RL.hudScale(2, 2)
    draw.SimpleText(pnl.Text, pnl.Font, offsetx, offsety, Color(0, 0, 0, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(pnl.Text, pnl.Font, 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

--[[

    Layouts

]]
--
function tbl.NoDraw()
end

function tbl.Panel(pnl, w, h)
    if pnl.DrawBorder or pnl:GetParent():GetClassName() ~= "CGModBase" and not pnl.Theme.NoBorder then
        tbl.DrawOutlineBox(pnl, w, h)

        return
    end

    tbl.DrawBox(pnl, w, h)
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

function tbl.RL_Frame(pnl, w, h)
    if pnl.DrawBorder or pnl:GetParent():GetClassName() ~= "CGModBase" and not pnl.Theme.NoBorder then
        DisableClipping(true)
        draw.RoundedBox(pnl.Theme.Curver or 5, -1, -1, w + 2, h + 2, RiceUI.GetColor(tbl, pnl, "Bar"))
        DisableClipping(false)
    end

    tbl.DrawBox(pnl, w, h, RiceUI.GetColor(tbl, pnl, "Bar"))
    draw.RoundedBoxEx(pnl.Theme.Curver or tbl.DefaultCurver, 0, pnl.Title:GetTall() + 10, w, h - pnl.Title:GetTall() - 10, RiceUI.GetColor(tbl, pnl), false, false, true, true)
end

function tbl.RL_Frame2(self, w, h)
    RL.Render.StartStencil()

    RL.Draw.RoundedBox(8, 0, 0, w, h, color_white)

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    RL.VGUI.blurPanel(self, 8)

    render.SetStencilEnable(false)

    draw.RoundedBoxEx(self.Theme.Curver or tbl.DefaultCurver, 0, 0, w, h, self:RiceUI_GetColor("Fill", "Frame"), true, true, true, true)
end

function tbl.ScrollPanel_VBar(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl, "Bar"))
    surface.DrawRect(0, 0, w, h)
end

function tbl.ScrollPanel_VBar_Grip(pnl, w, h)
    tbl.DrawButton(pnl, w, h, _, {false, false, false, false})
end

function tbl.Form(pnl, w, h)
    tbl.DrawButton(pnl, w, h)

    if pnl.Value then
        draw.SimpleText(pnl.Value, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(pnl.Text, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local h = pnl.h
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, pnl.a_pointang)
end

function tbl.Spacer(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl, "Outline"))
    surface.DrawRect(0, h / 2 - RL.hudOffsetY(1), w, RL.hudOffsetY(2))
end

--[[

    Inputs

]]
--
-- Buttons
function tbl.Button(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() then
        color = RiceUI.GetColorBase(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

function tbl.Button_TextLeft(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() then
        color = RiceUI.GetColorBase(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), RL.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.TransButton(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")
    tbl.DrawBox(pnl, w, h, ColorAlpha(color, RiceUI.HoverAlpha(pnl, 20)))
    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_TextLeft(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")
    tbl.DrawBox(pnl, w, h, ColorAlpha(color, RiceUI.HoverAlpha(pnl, 20)))
    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() then
        color = RiceUI.GetColorBase(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), RL.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_F(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")

    if pnl:IsHovered() then
        pnl.HoverAlpha = 255
    else
        pnl.HoverAlpha = 0
    end

    tbl.DrawBox(pnl, w, h, ColorAlpha(color, pnl.HoverAlpha))
    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.CloseButton(pnl, w, h)
    local color = RiceUI.GetColorBase(tbl, pnl, "CloseButton")

    tbl.DrawBox(pnl, w, h, ColorAlpha(color, RiceUI.HoverAlpha(pnl, 20)), {false, true, false, false})

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
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
        draw.RoundedBox(8, 0, h / 4, RL.hudScaleX(4), h / 2, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
    end

    draw.SimpleText(self.Text, self:GetFont(), RL.hudScaleX(10), h / 2, self:RiceUI_GetColor("Text", "Primary"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.Navgation_Button_Transparent(self, w, h)
    local color = self:RiceUI_GetColor("Fill", "NavigationButton", "Default")
    if self:IsHovered() then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Hover") end
    if self.Selected then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Selected") end

    tbl.DrawBox(self, w, h, color)

    if self.Selected then
        draw.RoundedBox(8, 0, h / 4, RL.hudScaleX(4), h / 2, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
    end

    draw.SimpleText(self.Text, self:GetFont(), RL.hudScaleX(10), h / 2, self:RiceUI_GetColor("Text", "Primary"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.Navgation_Combo(self, w, h)
    local color = self:RiceUI_GetColor("Fill", "NavigationButton", "Default")
    if self:IsHovered() then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Hover") end
    if self.Selected then color = self:RiceUI_GetColor("Fill", "NavigationButton", "Selected") end

    tbl.DrawBox(self, w, h, color)

    if self.Selected then
        draw.RoundedBox(8, 0, self.Init_H / 4, RL.hudScaleX(4), self.Init_H / 2, self:RiceUI_GetColor("Fill", "Accent", "Primary"))
    end

    draw.SimpleText(self.Text, self:GetFont(), RL.hudScaleX(10), h / 2, self:RiceUI_GetColor("Text", "Primary"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

--NumberWang
function tbl.RL_NumberWang(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Outline")

    if pnl:HasFocus() then
        color = RiceUI.GetColorBase(tbl, pnl, "Focus")
    end

    tbl.DrawOutlineBox(pnl, w, h, color)
    draw.SimpleText(pnl:GetValue(), pnl:GetFont(), 10, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    tbl.DrawTextCursor(pnl, w, h)
end

function tbl.NumberWang_Button(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    local size = h / 2 + RL.hudScaleY(pnl.Theme.Scale or 0)
    surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, pnl.Theme.Ang)
end

--Entry
function tbl.Entry(pnl, w, h)
    tbl.DrawEntry(pnl, w, h)

    if pnl:GetValue() == "" then
        draw.SimpleText(pnl:GetPlaceholderText(), pnl:GetFont(), 10, h / 2, pnl:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(pnl:GetText(), pnl:GetFont(), 10, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    tbl.DrawTextCursor(pnl, w, h)
end

function tbl.Entry_Search(pnl, w, h)
    tbl.DrawEntry(pnl, w, h)

    if pnl:GetValue() == "" then
        draw.SimpleText(pnl:GetPlaceholderText(), pnl:GetFont(), 10, h / 2, pnl:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(zoom)
    surface.DrawTexturedRect(0, 0, w, h)
    draw.SimpleText(pnl:GetText(), pnl:GetFont(), 32, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    tbl.DrawTextCursor(pnl, w, h)
end

--Switch
function tbl.Switch(pnl, w, h)
    RL.Draw.Circle(h / 2, h / 2, h / 2, 32, pnl:GetColor())
    RL.Draw.Circle(w - h / 2, h / 2, h / 2, 32, pnl:GetColor())
    surface.SetDrawColor(pnl:GetColor())
    surface.DrawRect(h / 2 / 2 + 4, 0, w - h / 2 - 8, h)
    RL.Draw.Circle(h / 2 + pnl.togglePos, h / 2, h / 2 - 2, 32, Color(250, 250, 250))
end

--Slider
function tbl.Slider(pnl, w, h)
    local pos = w * pnl:GetSlideX()
    draw.RoundedBox(32, 0, h / 3, pos, h / 3, RiceUI.GetColorBase(tbl, pnl, "Focus"))
    draw.RoundedBox(32, pos, h / 3, w - pos, h / 3, RiceUI.GetColor(tbl, pnl, "Disable"))
    DisableClipping(true)
    RL.Draw.Circle(pos, h / 2, h / 2, 32, RiceUI.GetColorBase(tbl, pnl, "Focus"))
    RL.Draw.Circle(pos, h / 2, h / 2 - 2, 32, Color(250, 250, 250))

    if pnl:GetDragging() then
        draw.SimpleText(tostring(pnl:GetValue()), "OPPOSans_" .. tostring(h), pos, -h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    DisableClipping(false)
end

--CheckBox
function tbl.CheckBox(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    draw.RoundedBox(pnl.Theme.Curver or 5, 4, 4, w - 8, h - 8, ColorAlpha(RiceUI.GetColorBase(tbl, pnl, "Focus"), pnl.a_Alpha))
end

local alpha_grid = Material("gui/alpha_grid.png")

function tbl.ColorButton(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    local x, y = RL.hudScale(12, 12)
    surface.SetMaterial(alpha_grid)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(x / 2, y / 2, w - x, h - y)
    surface.SetDrawColor(pnl.Value)
    surface.DrawRect(x / 2, y / 2, w - x, h - y)
end

--ComboBox
function tbl.RL_Combo(pnl, w, h)
    local Corner = {true, true, true, true}

    if pnl.Openning then
        Corner = {true, true, false, false}
    end

    tbl.DrawButton(pnl, w, h, _, Corner)

    if pnl.Value then
        draw.SimpleText(pnl.Value, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(pnl.Text, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, pnl.a_pointang)
end

function tbl.RL_Combo_Choice(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")

    if not pnl.HoverAlpha then
        pnl.HoverAlpha = 0
    end

    if pnl:IsHovered() then
        pnl.HoverAlpha = math.min(pnl.HoverAlpha + (pnl.Theme.Speed or 20) * (RealFrameTime() * 100), 255)
    else
        pnl.HoverAlpha = math.max(pnl.HoverAlpha - (pnl.Theme.Speed or 20) * (RealFrameTime() * 100), 0)
    end

    tbl.DrawBox(pnl, w, h, ColorAlpha(color, pnl.HoverAlpha))
    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() or pnl.Selected then
        color = RiceUI.GetColorBase(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), RL.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

return tbl