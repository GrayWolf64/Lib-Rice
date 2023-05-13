local Element = {}
Element.Editor = {Category="base"}
function Element.Create(data,parent)
    local panel = vgui.Create("DTree",parent)
    panel:Dock(FILL)

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    function panel:DoClick(node)
        if self:GetParent().RiceUI_Event then
            self:GetParent().RiceUI_Event("Node_Click",self.ID or "",node)
        end
    end

    return panel
end

return Element