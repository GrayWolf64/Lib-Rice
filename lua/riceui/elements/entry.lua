local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 200,
        h = 30,
        Font = "OPSans_20",
        Text = "",
        TextColor = Color(30,30,30),
        Placeholder = "Input Text",
        OnEnter = function()end,
        Multline = false,
    })

    local panel = vgui.Create("DTextEntry",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetFont(data.Font)
    panel:SetText(data.Text)
    panel:SetTextColor(data.TextColor)
    panel:SetPlaceholderText(data.Placeholder)
    panel:SetMultiline(data.Multline)

    panel.GThemeType = "Entry"
    panel.ProcessID = "Entry"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    RiceUI.Process("panel",panel,data)
    RiceUI.Process("label",panel,data)

    return panel
end

return Element