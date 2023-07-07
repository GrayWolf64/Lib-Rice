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
    panel.ProcessID = "CheckBox"
    panel.Value = false
    panel.a_Alpha = 0

    function panel:DoAnim(noAnim)
        if noAnim then
            if self.Value then
                self.a_Alpha = 255
            else
                self.a_Alpha = 0
            end

            return
        end

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

        self:DoAnim(true)
        self:OnValueChange(val)
    end

    function panel:OnValueChange(val)
    end

    function panel:DoClick()
        if self.Disable then return end

        self.Value = not self.Value
        self:OnValueChange(self.Value)

        self:DoAnim()

        if self:GetParent().RiceUI_Event then
            self:GetParent():RiceUI_Event("Radio_Check",self.ID,self)
        end
    end

    function panel.RiceUI_Event(self,name,id,pnl)
        if self == pnl then return end
        if self.Group == nil then return end
        if name ~= "Radio_Check" then return end
        if pnl.Group ~= self.Group then return end

        if pnl.Value then self:SetValue(false) end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    if panel.Value then panel.a_Alpha = 255 end

    return panel
end

return Element