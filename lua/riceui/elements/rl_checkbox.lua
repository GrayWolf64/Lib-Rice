local Element = {}
Element.Editor = {Category="interact"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        size = 20,
        x = 10,
        y = 10,
        Theme = {ThemeName="modern",ThemeType="CheckBox",Color="white"}
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    local s = RL.hudScaleY(data.size)
    panel:SetSize(s,s)
    panel:SetText("")
    panel.GThemeType = "CheckBox"
    panel.ProcessID = "CheckBox"
    panel.Value = false
    panel.a_Alpha = 0

    function panel:DoAnim()
        local anim = self:NewAnimation(0.075,0,0.3)

        anim.Think = function(_,pnl,fraction)
            if not self.Value then
                self.a_Alpha = 255 - 255 * fraction
                return
            end

            self.a_Alpha = 255 * fraction
        end
    end

    function panel:SetValue(val)
        self.Value = val

        self:DoAnim()
    end

    function panel:OnValueChanged(val)
    end

    function panel:DoClick()
        if self.Disable then return end

        self.Value = not self.Value
        self:OnValueChanged(self.Value)

        self:DoAnim()

        if self:GetParent().RiceUI_Event then
            self:GetParent():RiceUI_Event("CheckBox_Check",self.ID,self)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    if panel.Value then panel.a_Alpha = 255 end

    return panel
end

return Element