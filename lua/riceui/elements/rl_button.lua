local Element = {}
Element.Editor = {Category="interact"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 100,
        h = 50,
        Font = "OPSans_30",
        Text = "按钮",
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetFont(data.Font)
    panel:SetText("")
    panel.GThemeType = "Button"
    panel.ProcessID = "Button"
    panel.Paint = RiceUI.GetTheme("modern").Button
    panel.Theme = {Color = "white1"}

    function panel:DoClick()
        if self:GetParent().RiceUI_Event then
            self:GetParent().RiceUI_Event("Button_Click",self.ID,self)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element