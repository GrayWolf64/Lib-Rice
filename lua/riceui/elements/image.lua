local Element = {}

Element.Editor = {
    Category = "display"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "gui/contenticon-normal.png"
    })

    local panel = vgui.Create("DImageButton", parent)
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    RiceUI.MergeData(panel, RiceUI.ProcessData(data))
    panel:SetImage(data.Image)

    return panel
end

return Element