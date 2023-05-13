local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        w = 300,
        Font = "OPSans_30",
        Theme = {ThemeName = "modern",ThemeType="Panel",Color="white",TextColor="white"},
        GTheme= {name = "modern",Theme = {ThemeName = "modern",Color="white",TextColor="white"}},
        Choice = {
            {"Option1",function()end},
            {"Option2",function()end},
            {"Option3",function()end}
        },
        ChoiceH = 40,
    })

    local panel = vgui.Create("DPanel")
    panel:SetSize(RL.hudScaleX(data.w),0)
    panel:SetPos(gui.MouseX(),gui.MouseY())
    panel.ProcessID = "RL_Menu"

    function panel:OnFocusChanged(gained)
        if not gained then self:Remove() end
    end

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

    function panel:Layout()
        for _,v in ipairs(self.Choice) do
            RiceUI.SimpleCreate({type="rl_button",Theme={ThemeType="Button_TextLeft"},Text=v[1],Font=self.Font,Dock=TOP,h=self.ChoiceH,
                DoClick = function(self)
                    local func = v[2] or function()end

                    func(self)

                    panel:Remove()
                end
            },self)
        end

        self:SizeTo(-1,#self.Choice * self.ChoiceH,0.1,0,0.3)
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