local Element = {}

Element.Editor = {
    Category = "base"
}

function Element.Create(data, parent)
    local panel = vgui.Create("DTree", parent)
    panel:Dock(FILL)

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element