local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 300,
        h = 50,
    })

    local panel = vgui.Create("DProgress",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel.GThemeType = "Panel"
    panel:SetFraction(0)

    RiceUI.Process("panel",panel,data)

    return panel
end

return main