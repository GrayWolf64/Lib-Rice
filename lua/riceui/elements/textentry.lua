local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 200,
        h = 30,
        Font = "OPPOSans_25",
        Text = "",
        TextColor = Color(30,30,30),
        Placeholder = "Input Text",
    })

    local panel = vgui.Create("DTextEntry",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetFont(data.Font)
    panel:SetText(data.Text)
    panel:SetTextColor(data.TextColor)
    panel:SetPlaceholderText(data.Placeholder)

    RiceUI.Process("panel",panel,data)
    RiceUI.Process("label",panel,data)

    return panel
end

return main