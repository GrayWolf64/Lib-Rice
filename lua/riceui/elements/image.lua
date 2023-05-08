local Element = {}
Element.Editor = {Category="display"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "vgui/cursors/hand"
    })

    local panel = vgui.Create("DImageButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetImage(data.Image)

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element