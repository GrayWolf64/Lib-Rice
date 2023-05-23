local Element = {}
Element.Editor = {Category="base"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        Theme = {ThemeName = "modern",ThemeType="Panel",Color="white",TextColor="white"}
    })

    local panel = vgui.Create("DPanel",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel.ProcessID = "Panel"
    panel.IsBase = true

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

    function panel.RiceUI_Event(self,name,id,data)
        if panel:GetParent().RiceUI_Event then
            panel:GetParent():RiceUI_Event(name,id,data)
        end

        for _,pnl in ipairs(self:GetChildren()) do
            if pnl.IsBase then continue end
            if pnl.RiceUI_Event == nil then continue end

            pnl:RiceUI_Event(name,id,data)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element