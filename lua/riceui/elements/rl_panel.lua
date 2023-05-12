local Element = {}
Element.Editor = {Category="base"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        Theme= {ThemeName = "modern",ThemeType="Panel",Color="white",TextColor="white"}
    })

    local panel = vgui.Create("DPanel",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))

    function panel.ChildCreated()
        if !panel.GTheme then return end

        local Theme = RiceUI.GetTheme(panel.GTheme.name)

        for _,child in ipairs(panel:GetChildren()) do
            if !child.GThemeType then continue end
            if child.NoGTheme then continue end

            if Theme[child.GThemeType] then
                child.Paint = Theme[child.GThemeType]
                child.Theme = child.Theme or {}
                table.Merge(child.Theme,panel.GTheme.Theme)
            end
        end
    end

    function panel.RiceUI_Event(self,name,id,data)
        if panel:GetParent().RiceUI_Event then
            panel:GetParent():RiceUI_Event(name,id,data)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element