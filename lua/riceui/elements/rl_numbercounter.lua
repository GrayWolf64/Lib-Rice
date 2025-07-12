local Element = {}

Element.Editor = {
    Category = "input"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 120,
        h = 30,

        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_NumberCounter",

            Color = "white",
            TextColor = "white"
        },

        Step = 1,
        Min = 0,
        Max = 100,
        Dec = 2,
    })

    local panel = RiceUI.SimpleCreate({type = "entry",
        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        UseNewTheme = true,
        Theme = data.Theme,

        ProcessID = "RL_NumberWang",

        children = {
            {type = "rl_button",
                Dock = LEFT,
                Margin = {8, 0, 0, 0},
                w = data.h / 2,

                ID = "NumberWang",
                Value = -data.Step,

                Theme = {
                    Scale = 1,
                    Ang = -90,
                    ThemeType = "NumberWang_Button"
                }
            },
            {type = "rl_button",
                Dock = RIGHT,
                Margin = {0, 0, 8, 0},
                w = data.h / 2,

                ID = "NumberWang",
                Value = data.Step,

                Theme = {
                    Ang = 90,
                    ThemeType = "NumberWang_Button"
                }
            }
        }
    }, parent)

    panel.ProcessID = "RL_NumberCounter"
    panel.IsBase = true
    panel.Value = 0
    panel:SetPlaceholderText("")
    panel:SetUpdateOnType(true)
    panel:SetNumeric(true)
    panel:SetCursor("sizens")

    function panel:RiceUI_Event(event, id, pnl)
        if id == "NumberWang" then
            self:SetValue(math.Clamp(self.Value + pnl.Value, self.Min, self.Max))
        end

        if self:GetParent().RiceUI_Event then
            self:GetParent():RiceUI_Event(name, id, data)
        end
    end

    function panel:OnMouseWheeled(dlt)
        local val =  dlt * self.Step

        if input.IsKeyDown(KEY_LCONTROL) then
            val = math.Round(val / 10, self.Dec)
        end

        self:SetValue(math.Clamp(self.Value + val, self.Min, self.Max))
    end

    function panel:OnChange()
        local val = self:GetFloat() or 0

        self:SetValue(math.Clamp(math.Round(val, self.Dec) or 0, self.Min, self.Max))
    end

    function panel:SetValue(val)
        self.Value = math.Clamp(math.Round(val, self.Dec), self.Min, self.Max)

        self:OnValueChanged(val)
    end

    function panel:GetValue()
        return self.Value
    end

    function panel:OnValueChanged(val)
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element