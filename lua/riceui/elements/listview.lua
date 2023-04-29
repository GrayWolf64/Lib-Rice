local Element = {}
Element.Editor = {Category="display"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("DListView",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel.GThemeType = "ListView"
    panel.ProcessID = "ListView"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    function panel:OnRowSelected(index, pnl)
        if self:GetParent().RiceUI_Event then
            self:GetParent().RiceUI_Event("ListView_Select",self.ID or "",pnl)
        end
    end

    return panel
end

return Element