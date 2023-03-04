local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        TitleColor = Color(25,25,25),
        CloseButtonColor = Color(255,255,255),
        ThemeName = "modern",
    })

    local panel = vgui.Create("DPanel",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel.GTheme = data.GTheme
    panel.ThemeName = data.ThemeName

    function panel.ChildCreated()
        if !panel.GTheme then return end

        local Theme = RiceUI.GetTheme(panel.GTheme.name)

        for _,child in ipairs(panel:GetChildren()) do
            if !child.GThemeType then continue end
            if child.NoGTheme then continue end

            if Theme[child.GThemeType] then
                child.Paint = Theme[child.GThemeType]
                child.Theme = panel.GTheme.Theme
            end
        end
    end

    RiceUI.Process("panel",panel,data)

    return panel
end

return main