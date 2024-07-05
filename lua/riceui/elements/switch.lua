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
    panel:SetColor(data.DisableColor)
    panel.ProcessID = "Switch"
    panel.togglePos = 0

    function panel:DoClick()
        panel.Value = not panel.Value
        panel:DoAnim(panel.Value)
        panel:OnValueChanged(panel.Value)
    end

    function panel:OnValueChanged(val, noanim)
    end

    function panel:SetValue(val, noTrigger)
        panel.Value = val
        panel:DoAnim(panel.Value, true)

        if not noTrigger then panel:OnValueChanged(val) end
    end

    function panel:DoAnim(val, noanim)
        if noanim then
            if val then
                self.togglePos = self:GetWide() / 2
                self:SetColor(Color(64, 158, 255))
            else
                self.togglePos = 0
                self:SetColor(self.DisableColor)
            end

            return
        end

        local anim = self:NewAnimation(self.a_length or 0.25, 0, self.a_ease or 0.25)

        if val then
            anim.StartPos = 0
            anim.TargetPos = self:GetWide() / 2
            self:ColorTo(self.Color, 0.15, 0.05)
        else
            anim.StartPos = self:GetWide() / 2
            anim.TargetPos = 0
            self:ColorTo(self.DisableColor, 0.15, 0.05)
        end

        anim.Think = function(anim, pnl, fraction)
            self.togglePos = Lerp(fraction, anim.StartPos, anim.TargetPos)
            self.animFraction = fraction
        end
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))
    panel:SetValue(data.Value or false, true)

    return panel
end

return Element