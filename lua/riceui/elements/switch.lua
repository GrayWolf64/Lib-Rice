local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 100,
        h = 50,
        DisableColor = Color(200,200,200),
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetText("")
    panel:SetColor(data.DisableColor)
    panel.GThemeType = "Switch"
    panel.NoGTheme = data.NoGTheme
    panel.DisableColor = data.DisableColor

    panel.Paint = RiceUI.GetTheme("modern").Switch
    panel.Theme = {Color="white"}
    panel.togglePos = 0

    function panel:DoClick()
        panel.Value = !panel.Value

        panel.DoAnim(panel.Value)
        panel:OnValueChanged(panel.Value)
    end

    function panel:OnValueChanged(val,noanim)
    end

    function panel:SetValue(val)
        panel.Value = val
        panel.DoAnim(panel.Value,true)
        panel:OnValueChanged(val)
    end

    function panel.DoAnim(val,noanim)
        local self = panel

        if noanim then
            if val then
                self.togglePos = self:GetWide()/2
                self:SetColor(Color(64, 158, 255))
            else
                self.togglePos = 0
                self:SetColor(self.DisableColor)
            end

            return
        end

        local anim = self:NewAnimation( self.a_length or 0.25, 0, self.a_ease or 0.25 )

        if val then
            anim.StartPos = 0
            anim.TargetPos = self:GetWide()/2
            
            self:ColorTo(Color(64, 158, 255),0.15,0.05)
        else
            anim.StartPos = self:GetWide()/2
            anim.TargetPos = 0

            self:ColorTo(self.DisableColor,0.15,0.05)
        end
    
        anim.Think = function( anim, pnl, fraction )
            self.togglePos = Lerp( fraction, anim.StartPos, anim.TargetPos )
            self.animFraction = fraction
        end
    end

    panel:SetValue(data.Value or false)

    RiceUI.Process("panel",panel,data)
    RiceUI.Process("button",panel,data)

    return panel
end

return main