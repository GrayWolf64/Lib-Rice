local Element = {}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        w = 300,
        Font = "OPSans_30",
        Theme = {ThemeName = "modern", ThemeType = "Panel", Color = "white", TextColor = "white", Shadow = true},
        Choice = {
            {"Option1",function() end},
            {"Option2",function() end},
            {"-",function() end},
            {"Option3",function() end}
        },
        ChoiceH = 40,
        Padding = {0,5,0,0},
    })

    local panel = vgui.Create("DPanel",parent)
    panel:SetSize(RiceLib.hudScaleX(data.w),0)
    panel:SetPos(gui.MouseX(),gui.MouseY())
    panel.ProcessID = "RL_Menu"
    panel.DrawBorder = true

    function panel:OnFocusChanged(gained)
        if not gained then
            self:Remove()
        end
    end

    function panel:Layout()
        for _,v in ipairs(self.Choice) do
            if v[1] == "-" then
                local pnl = RiceUI.SimpleCreate({type = "rl_panel",
                    Theme = {ThemeType = "Spacer"},
                    Dock = TOP,
                    h = RiceLib.hudScaleY(10),
                },self)

                RiceUI.ApplyTheme(pnl,self.Theme)

                continue
            end

            local pnl = RiceUI.SimpleCreate({type = "rl_button",
                Theme = {ThemeType = "TransButton_TextLeft"},

                Text = v[1],
                Font = self.Font,

                Dock = TOP,
                Margin = {5,0,5,0},

                h = self.ChoiceH,

                DoClick = function(self)
                    local func = v[2] or function() end

                    func(self)

                    panel:Remove()
                end
            },self)

            RiceUI.ApplyTheme(pnl,self.Theme)
        end

        if self.AutoWide then
            local far = 0

            for _,choice in ipairs(self.Choice) do
                local wide = RiceLib.VGUI.TextWide(self.Font,choice[1])
                if wide < far then continue end

                far = wide
            end

            self:SetWide(far + RiceLib.hudOffsetX(30))
        end

        local h = RiceLib.hudScaleY(10)
        for _, v in ipairs(self:GetChildren()) do
            h = h + v:GetTall()
        end

        self:SizeTo(-1,h,0.1,0,0.3)
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