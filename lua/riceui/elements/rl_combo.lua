local Element = {}
Element.Editor = {Category="interact"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 200,
        h = 30,
        Font = "OPSans_20",
        Text = "选择器",
        Theme = {ThemeName="modern",ThemeType="Combo",Color="white",TextColor="white"},
    })

    local panel = RiceUI.SimpleCreate({type="rl_button", Text=data.Text, x=data.x, y=data.y, w=data.w, h=data.h, Theme = data.Theme},parent)
    panel.GThemeType = "Combo"
    panel.ProcessID = "RL_Combo"
    panel.a_pointang = 0
    panel.d_Choice = {}

    function panel:DoAnim()
        self.OnAnim = true

        local anim = self:NewAnimation(0.3,0,0.2,function(anim,pnl)
            pnl.IsOpen = !pnl.IsOpen

            self.OnAnim = false
        end)

        anim.Think = function(_,pnl,fraction)
            if self.IsOpen then
                panel.a_pointang = -180 + (180 * fraction)

                return
            end

            panel.a_pointang = -180 * fraction
        end
    end

    function panel:CloseMenu()
        self.Menu:SizeTo(-1,0,0.3,0,0.2,function(anim,pnl)
            pnl:Remove()
        end)
    end

    function panel:DoClick()
        if self.OnAnim then return end

        self:DoAnim()

        if self.IsOpen then
            self:CloseMenu()

            return
        end

        self.Menu = RiceUI.SimpleCreate({type = "rl_panel",Clipping = true,w=self:GetWide(),h=0,
            Theme = table.Merge(table.Copy(self.Theme),{ThemeType="Panel"})
        },self:GetParent())
        local x,y = self:GetPos()
        self.Menu:SetPos(x,y+self:GetTall())

        for _,data in ipairs(self.d_Choice) do
            local choice = RiceUI.SimpleCreate({type="rl_button",Text=data[1],dock=TOP,h=self:GetTall(),Font=self.Font,ID=data[1],
                Theme=table.Merge(table.Copy(self.Theme),{ThemeType="Choice"}),

                DoClick = function()
                    self.OnAnim = true
                    self:RiceUI_Event("ComboSelect",data[1])
                    self:CloseMenu()
                    self:DoAnim()
                end
            },self.Menu)

            if data[1] == self.Value then choice.Selected = true end
        end

        self.Menu:SizeTo(-1,#self.d_Choice*self:GetTall(),0.3,0,0.2)
    end

    function panel:SetValue(value)
        self.Value = value
    end

    function panel:AddChoice(value,data,select)
        table.insert(panel.d_Choice,{value,data,select})
    end

    function panel:RiceUI_Event(event,id,pnl)
        if event == "ComboSelect" then
            self.Value = id
        end
    end

    function panel:GetSelected()
        return self.Value
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element