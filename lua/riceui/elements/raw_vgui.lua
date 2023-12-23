local Element = {}

Element.Editor = {
    Category = "base"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 500,
        h = 300,

        NoGTheme = true,
    })

    local panel = vgui.Create(data.PanelName, parent)
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    panel.IsBase = true

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element