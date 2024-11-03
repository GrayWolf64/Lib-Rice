local Element = {}

Element.Editor = {
    Category = "display"
}

function Element.Create(data, parent, root)
    RiceLib.table.Inherit(data, {
        x = 16,
        y = 16,
        w = 512,
        h = 48,

        ThemeNT = {
            Class = "ProgressBar"
        }
    })

    local panel = RiceUI.SimpleCreate({type = "rl_panel",
        ProcessID = "ProgressBar",

        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        ThemeNT = data.ThemeNT,

        Fraction = 1,
        SmoothFraction = 1,

        SmoothController = RiceUI.SmoothController()
    }, parent, root)

    function panel:Think()
        self.SmoothFraction = RiceUI.Smooth(self.SmoothController, self.Fraction)
    end

    function panel:SetFraction(fraction) self.Fraction = math.min(fraction, 1) end
    function panel:GetFraction() return self.Fraction end
    function panel:GetSmoothFraction() return self.SmoothFraction end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element