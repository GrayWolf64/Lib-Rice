local Element = {}
Element.Editor = {Category="display"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 100,
        h = 30,
        Font = "OPPOSans_30",
        Color = Color(30,30,30),
        Text = "HelloWorld!, 你好中国",
        Wrap = false,
    })

    local panel = vgui.Create("DLabel",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetFont(data.Font)
    panel:SetColor(data.Color)
    panel:SetText(data.Text)
    if not data.NoResize then panel:SizeToContents() end
    panel.ProcessID = "Label"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    if panel.Wrap then
        panel:SetWrap(true)
        panel:SetAutoStretchVertical(true)
    end

    return panel
end

return Element