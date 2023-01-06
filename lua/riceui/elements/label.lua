local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        Font = "OPPOSans_30",
        Color = Color(30,30,30),
        Text = "HelloWorld!, 你好中国",
    })

    local panel = vgui.Create("DLabel",parent)
    panel:SetPos(data.x,data.y)
    panel:SetFont(data.Font)
    panel:SetColor(data.Color)
    panel:SetText(data.Text)

    RiceUI.Process("label",panel,data)

    return panel
end

return main