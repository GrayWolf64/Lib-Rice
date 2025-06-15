

print(1)local Element = {}

Element.Editor = {
    Category = "input"
}

function Element.Create(data, parent, root)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 200,
        h = 30,

        RowHeight = 32,
        RowFont = "RiceUI_M_20",

        Font = "RiceUI_M_20",
        Text = "选择器",
    })

    local panel = RiceUI.SimpleCreate({type = "rl_button",
        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        ProcessID = "ComboBox",

        Theme = {},

        Think = function(self)
        end
    }, parent, root)

    function panel:CreateOptions()
        if not self.Options then return end

        local x, y = self:LocalToScreen()

        local menu = RiceUI.SimpleCreate({type = "rl_panel",
            Root = true,

            w = self:GetWide(),

            OnFocusChanged = function(self, gained)
                if not gained then self:Remove() end
            end,

            x = x,
            y = y - RICEUI_SIZE_4,
            h = 0,
        }, self, self)

        local row
        local selectedRow
        for _, option in ipairs(self.Options) do
            row = RiceUI.SimpleCreate({type = "rl_button",
                Dock = TOP,
                Margin = {4, 4, 4, 0},
                h = data.RowHeight,

                Text = option[1],
                Font = data.RowFont,

                ThemeNT = {
                    Style = "ComboChoice"
                },

                DoClick = function(pnl)
                    self:SetValue(option[2], true, option[1])
                    self.Menu:Remove()
                end
            }, menu, menu)

            if option[2] == self.Selected then
                row.Selected = true

                selectedRow = row
            end
        end

        row:InvalidateParent(true)

        if selectedRow then
            menu:SetY(y - selectedRow:GetY())
        end

        local _, tall = menu:ChildrenSize()

        menu:RiceUI_SizeTo{
            H = tall + RICEUI_SIZE_4,
            Time = RiceUI.Animation.GetTime("Fast")
        }

        RiceUI.ApplyTheme(self)

        self.Menu = menu
    end

    function panel:AddChoice(name, value)
        if not self.Options then self.Options = {} end

        table.insert(self.Options, {name, value})

        if self.Selected and value == self.Selected then
            self.Text = name
        end
    end

    function panel:GetFont()
        return self.Font
    end

    function panel:SetValue(value, select, name)
        self.Selected = value

        self:OnValueChanged(value)

        if name then
            self.Text = name
        else
            if not self.Options then return end

            for _, option in ipairs(self.Options) do
                if option[2] == value then
                    self.Text = option[1]

                    break
                end
            end
        end

        if select then
            self:OnSelected(self.Text, value)
        end
    end

    function panel:GetValue()
        return self.Selected
    end

    function panel:OnValueChanged(val)
    end

    function panel:GetSelected()
        return self.Selected
    end

    function panel:OnSelected(text, val)
    end

    panel.DoClick = panel.CreateOptions

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element