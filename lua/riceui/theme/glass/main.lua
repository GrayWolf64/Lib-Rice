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

        Fill = {
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

        Overlay = {
            Control = ColorAlpha(color_white, 50)
        },

        Fill = {
            Control = {
                Default = Color(0, 0, 0, 50)
            },

            Card = {
                Default = Color(0, 0, 0, 75)
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

RiceUI.ThemeNT.DefineTheme("Glass", {
    Base = "glass",
    BaseNT = false,

    Colors = colors
})

local BOX_RADIUS = 8

local function drawBox(self, w, h, style, color)
    color = color or self:RiceUI_GetColor("Fill", "Card", "Default")

    if style.Blur then
        RiceLib.Render.StartStencil()

        RiceLib.Draw.RoundedBox(style.Radius or 0, 0, 0, w, h, color_white)

        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

        RiceLib.VGUI.blurPanel(self, style.Blur)

        render.SetStencilEnable(false)

        draw.RoundedBox(style.Radius or 0, 0, 0, w, h, color)

        return
    end

    draw.RoundedBox(style.Radius or BOX_RADIUS, 0, 0, w, h, color)
end

local function drawControl(self, w, h, style, color)
    if style.Blur then
        RiceLib.VGUI.blurPanel(self, style.Blur)
    end

    color = color or self:RiceUI_GetColor("Fill", "Control", "Default")
    draw.RoundedBox(style.Radius or BOX_RADIUS, 0, 0, w, h, color)
end

local function drawButton(self, w, h, style)
    drawControl(self, w, h, style)

    local height = RiceLib.hudOffsetY(3)
    surface.SetDrawColor(self:RiceUI_GetColor("Fill", "Control", "Default"))
    surface.DrawRect(0, h - height, w, height)

    if self:IsHovered() then
        surface.SetDrawColor(self:RiceUI_GetColor("Overlay", "Control"))
        surface.DrawRect(0, 0, w, h)
    end
end

RiceUI.ThemeNT.RegisterClass("Glass", "Panel",{
    Default = function(self, w, h, style)
        drawBox(self, w, h, style)
    end
})

local text_gap = RiceLib.UI.ScaleX(16)
RiceUI.ThemeNT.RegisterClass("Glass", "Button",{
    Default = function(self, w, h, style)
        drawButton(self, w, h, style)

        local color = self:RiceUI_GetColor("Text", "Primary")
        if self:IsDown() then color = self:RiceUI_GetColor("Fill", "Accent", "Primary") end

        draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,

    TextLeft = function(self, w, h, style)
        drawButton(self, w, h, style)

        local color = self:RiceUI_GetColor("Text", "Primary")
        if self:IsDown() then color = self:RiceUI_GetColor("Fill", "Accent", "Primary") end

        draw.SimpleText(self.Text, self:GetFont(), text_gap, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end,

    Accent = function(self, w, h, style)
        drawBox(self, w, h, style, self:RiceUI_GetColor("Fill", "Accent", "Primary"))

        local height = RiceLib.hudOffsetY(3)
        surface.SetDrawColor(self:RiceUI_GetColor("Fill", "Control", "Default"))
        surface.DrawRect(0, h - height, w, height)

        if self:IsHovered() then
            surface.SetDrawColor(self:RiceUI_GetColor("Overlay", "Control"))
            surface.DrawRect(0, 0, w, h)
        end

        local color = self:RiceUI_GetColor("Text", "OnAccent", "Primary")
        if self:IsDown() then color = self:RiceUI_GetColor("Text", "OnAccent", "Secondary") end

        draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end,
})

RiceUI.ThemeNT.RegisterClass("Glass", "NoDraw",{
    Default = function(self, w, h, style) end,
    Custom = function(self, w, h, style)
        style.Draw(self, w, h, style)
    end
})