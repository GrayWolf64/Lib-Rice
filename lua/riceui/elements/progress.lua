local Element = {}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 300,
        h = 50,
        Time = 0.25
    })

    local panel = vgui.Create("DProgress", parent)
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    panel.GThemeType = "Panel"
    panel:SetFraction(0)
    RiceUI.Smooth_CreateController(panel, data.Time)

    panel.Paint = function(self, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 255, 0)
        surface.DrawRect(0, 0, w * RiceUI.Smooth(self, self:GetFraction()), h)
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element