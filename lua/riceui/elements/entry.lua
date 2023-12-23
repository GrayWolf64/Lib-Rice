local Element = {}
Element.Editor = {Category = "input"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 200,
        h = 30,
        Font = "OPSans_25",
        Text = "",
        TextColor = Color(30,30,30),
        Placeholder = "Input Text",
        OnEnter = function() end,
        Multline = false,
        UpdateOnType = true,
    })

    local panel = vgui.Create("DTextEntry",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetFont(data.Font)
    panel:SetText(data.Text)
    panel:SetTextColor(data.TextColor)
    panel:SetPlaceholderText(data.Placeholder)
    panel:SetMultiline(data.Multline)
    panel:SetUpdateOnType(data.UpdateOnType)

    panel.GThemeType = "Entry"
    panel.ProcessID = "Entry"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element