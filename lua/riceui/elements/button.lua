local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 100,
        h = 50,
        Font = "OPSans_30",
        Color = Color(30,30,30),
        Text = "按钮",
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetFont(data.Font)
    panel:SetColor(data.Color)
    panel:SetText(data.Text)
    panel.GThemeType = "Button"
    panel.NoGTheme = data.NoGTheme

    RiceUI.Process("panel",panel,data)
    RiceUI.Process("button",panel,data)

    return panel
end

return main