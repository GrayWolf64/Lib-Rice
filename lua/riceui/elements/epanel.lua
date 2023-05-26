local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("EditablePanel",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel.GThemeType = "Panel"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    function panel:ChildCreated()
        if self.UseNewTheme then
            RiceUI.ApplyTheme(self)

            return
        end

        if !self.GTheme then return end

        local Theme = RiceUI.GetTheme(self.GTheme.name)

        for _,child in ipairs(self:GetChildren()) do
            if !child.GThemeType then continue end
            if child.NoGTheme then continue end

            if Theme[child.GThemeType] then
                child.Paint = Theme[child.GThemeType]
                child.Theme = child.Theme or {}
                table.Merge(child.Theme,self.GTheme.Theme)
            end
        end
    end

    return panel
end

return Element