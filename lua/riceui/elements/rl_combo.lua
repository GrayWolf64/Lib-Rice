local Element = {}

Element.Editor = {
    Category = "input"
}

function Element.Create(data, parent)
    RL.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 200,
        h = 30,

        Font = "OPSans_20",
        Text = "选择器",

        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_Combo",

            Color = "white",
            TextColor = "white"
        },
    })

    local panel = RiceUI.SimpleCreate({
        type = "rl_button",
        Text = data.Text,

        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        Theme = data.Theme
    }, parent)

    panel.GThemeType = "Combo"
    panel.ProcessID = "RL_Combo"
    panel.a_pointang = 0
    panel.d_Choice = {}
    panel.Openning = false

    function panel:DoAnim()
        self.OnAnim = true 
        self.Openning = not self.IsOpen

        local anim = self:NewAnimation(0.3, 0, 0.2, function(anim, pnl)
            self.IsOpen = not self.IsOpen
            self.OnAnim = false
        end)

        anim.Think = function(_, pnl, fraction)
            if self.IsOpen then
                self.a_pointang = -180 + (180 * fraction)

                return
            end

            self.a_pointang = -180 * fraction
        end
    end

    function panel:CloseMenu()
        self.Menu:SizeTo(-1, 0, 0.3, 0, 0.2, function(anim, pnl)
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

        self.Menu = RiceUI.SimpleCreate({type = "rl_panel",
            Clipping = false,

            w = self:GetWide(),
            h = 0,

            Padding = {0, 5, 0, 0},

            Theme = table.Merge(table.Copy(self.Theme), {
                ThemeType = "Panel",
                Corner = {false,false,true,true}
            })
        }, self:GetParent())

        local x, y = self:GetPos()
        self.Menu:SetPos(x, y + self:GetTall())

        for _, choice_data in ipairs(self.d_Choice) do
            local choice = RiceUI.SimpleCreate({type = "rl_button",
                ID = choice_data[1],
                Text = choice_data[1],
                Font = self.Font,

                Dock = TOP,
                Margin = {5, 0, 5, 0},
                h = self:GetTall(),

                Theme = table.Merge(table.Copy(self.Theme), {
                    ThemeType = "RL_Combo_Choice"
                }),

                DoClick = function()
                    self.OnAnim = true
                    self.Value = choice_data[1]
                    self:OnSelected(choice_data[1], choice_data)
                    self:CloseMenu()
                    self:DoAnim()
                end
            }, self.Menu)

            if choice_data[1] == self.Value then
                choice.Selected = true
            end
        end

        local h = RL.hudScaleY(10)

        for _, v in ipairs(self.Menu:GetChildren()) do
            h = h + v:GetTall()
        end

        self.Menu:SizeTo(-1, h, 0.3, 0, 0.3)
    end

    function panel:SetValue(value)
        self.Value = value
    end

    function panel:AddChoice(value, data, select)
        table.insert(panel.d_Choice, {value, data, select})
    end

    function panel:OnSelected()
    end

    function panel:GetSelected()
        return self.Value
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element