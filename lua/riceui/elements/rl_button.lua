local Element = {}
Element.Editor = {Category = "interact"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 100,
        h = 50,
        Font = "RiceUI_M_28",
        Text = "按钮",
        Theme = {ThemeName = "modern",ThemeType = "Button",Color = "white",TextColor = "white"},
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetFont(data.Font)
    panel:SetText("")
    panel.GThemeType = "Button"
    panel.ProcessID = "Button"

    function panel:DoClick()
        if self:GetParent().RiceUI_Event then
            self:GetParent():RiceUI_Event("Button_Click",self.ID,self)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element