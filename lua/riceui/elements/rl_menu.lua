local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        w = 300,
        Font = "OPSans_30",
        Theme = {ThemeName = "modern",ThemeType = "Panel",Color = "white",TextColor = "white"},
        Choice = {
            {"Option1",function() end},
            {"Option2",function() end},
            {"Option3",function() end}
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

    function panel:Layout()
        for _,v in ipairs(self.Choice) do
            local pnl = RiceUI.SimpleCreate({type = "rl_button",
                Theme = {ThemeType = "Button_TextLeft"},
                Text = v[1],
                Font = self.Font,
                Dock = TOP,
                h = self.ChoiceH,

                DoClick = function(self)
                    local func = v[2] or function() end

                    func(self)

                    panel:Remove()
                end
            },self)

            RiceUI.ApplyTheme(pnl,self.Theme)
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