local Element = {}

function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        spaceX = 0,
        spaceY = 0,
    })

    local panel = vgui.Create("DIconLayout",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetSpaceX(data.spaceX)
    panel:SetSpaceY(data.spaceY)
    panel.GThemeType = "Panel"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

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

    return panel
end

return Element