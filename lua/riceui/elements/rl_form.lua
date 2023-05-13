local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        w = 300,
        h = 40,
        Font = "OPSans_30",
        Theme = {ThemeName = "modern",ThemeType="Panel",Color="white",TextColor="white"},
        GTheme= {name = "modern",Theme = {ThemeName = "modern",Color="white",TextColor="white"}},
    })

    local panel = vgui.Create("DButton")
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetPos(gui.MouseX(),gui.MouseY())
    panel:SetText("")
    panel.ProcessID = "RL_Form"
    panel:DockPadding(0,RL.hudScaleY(data.h),0,0)

    function panel.ChildCreated()
        if !panel.GTheme then return end

        local Theme = RiceUI.GetTheme(panel.GTheme.name)

        for _,child in ipairs(panel:GetChildren()) do
            if !child.GThemeType then continue end
            if child.NoGTheme then continue end

            if Theme[child.GThemeType] then
                table.Merge(child.Theme,panel.GTheme.Theme)

                child.Paint = Theme[child.Theme.ThemeType or child.GThemeType]
                child.Theme = child.Theme or {}
            end
        end
    end

    function panel:DoClick()
        self.Expand = not self.Expand

        if self.Expand then
            self:SizeTo(-1,data.h,0.3,0,0.3)
        else
            local h = 0
            for _,v in ipairs(self:GetChildren()) do
                h = h + v:GetTall()
            end

            self:SizeTo(-1,h,0.3,0,0.3)
        end
    end

    function panel.RiceUI_Event(self,name,id,data)
        if panel:GetParent().RiceUI_Event then
            panel:GetParent():RiceUI_Event(name,id,data)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    panel:Layout()
    panel:MakePopup()

    return panel
end

return Element