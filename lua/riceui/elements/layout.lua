local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        spaceX = 0,
        spaceY = 0,
    })

    local panel = vgui.Create("DIconLayout",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetSpaceX(data.spaceX)
    panel:SetSpaceY(data.spaceY)
    panel.GThemeType = "Panel"

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