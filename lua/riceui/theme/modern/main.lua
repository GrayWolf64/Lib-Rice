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

RiceUI.ThemeNT.DefineTheme("Modern", {
    Base = "modern",
    BaseNT = false,

    Colors = colors
})

local offset = RiceLib.hudScaleY(2)
RiceUI.ThemeNT.RegisterClass("Modern", "Panel",{
    Default = function(self, w, h, style)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, w, h)
    end,

    Shadow = function(self, w, h, style)
        draw.RoundedBox(8, 0, 0, w, h, ColorAlpha(color_black, 100))
        draw.RoundedBox(8, 0, 0, w, h - offset, color_white)
    end,
})

RiceUI.ThemeNT.RegisterClass("Modern", "Frame",{
    Default = function(self, w, h, style)
        draw.RoundedBox(8, 0, 0, w, h - offset, color_white)
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