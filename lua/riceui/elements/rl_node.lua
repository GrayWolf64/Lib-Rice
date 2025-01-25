local Element = {}
Element.Editor = {Category = "base"}

function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 128,
        h = 32
    })

    local panel = vgui.Create("DTree",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel.ProcessID = "Tree"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element