local Element = {}
Element.Editor = {Category="display"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        Font = "OPPOSans_30",
        Color = Color(30,30,30),
        Text = "HelloWorld!, 你好中国",
    })

    local panel = vgui.Create("DLabel",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetFont(data.Font)
    panel:SetColor(data.Color)
    panel:SetText(data.Text)
    panel:SizeToContents()
    panel.ProcessID = "Label"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    RiceUI.Process("label",panel,data)

    return panel
end

return Element