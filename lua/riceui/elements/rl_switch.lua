local Element = {}

Element.Editor = {
    Category = "interact"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 64,
        h = 50,

        Color = Color(64, 158, 255),
        DisableColor = Color(200, 200, 200),

        Theme = {
            ThemeName = "modern",
            ThemeType = "Switch",
            Color = "white"
        }
    })

    local panel = vgui.Create("DButton", parent)
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    panel:SetText("")
    panel.ProcessID = "Switch"
    panel.AnimationFraction = 0

    function panel:DoClick()
        self.Value = not self.Value

        self:OnValueChanged(self.Value)
    end

    function panel:OnValueChanged(val, noanim)
    end

    function panel:SetValue(val, noTrigger)
        self.Value = val

        if not noTrigger then self:OnValueChanged(val) end
    end

    function panel:GetValue()
        return self.Value
    end

    function panel:Think()
        local change = -RealFrameTime() * RiceUI.Animation.GetRate() * 6

        if self:GetValue() then
            change = RealFrameTime() * RiceUI.Animation.GetRate() * 6
        end

        local fraction = self.AnimationFraction

        fraction = math.Clamp(fraction + change, 0, 1)

        self.AnimationFraction = fraction
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))
    panel:SetValue(data.Value or false, true)

    return panel
end

return Element