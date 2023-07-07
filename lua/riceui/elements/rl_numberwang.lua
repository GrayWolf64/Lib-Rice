local Element = {}

Element.Editor = {
    Category = "input"
}

function Element.Create(data, parent)
    RL.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 120,
        h = 30,

        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_NumberWang",

            Color = "white",
            TextColor = "white"
        },

        Step = 1,
        Min = 0,
        Max = 100,
    })

    local panel = RiceUI.SimpleCreate({type = "entry",
        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        UseNewTheme = true,
        Theme = data.Theme,

        children = {
            {type = "rl_panel",
                Theme = {Corner = {false,true,false,true}},
                Paint = function() end,

                w = 25,
                Dock = RIGHT,

                children = {
                    {type = "rl_button",
                        Dock = TOP,
                        h = data.h / 2,

                        ID = "NumberWang",
                        Value = data.Step,

                        Theme = {
                            Scale = 1,
                            Ang = 180,
                            ThemeType = "NumberWang_Button"
                        }
                    },
                    {type = "rl_button",
                        Dock = TOP,
                        h = data.h / 2,

                        ID = "NumberWang",
                        Value = -data.Step,

                        Theme = {
                            Ang = 0,
                            ThemeType = "NumberWang_Button"
                        }
                    }
                }
            }
        }
    }, parent)

    panel.ProcessID = "RL_NumberWang"
    panel.IsBase = true
    panel.Value = 0
    panel:SetPlaceholderText("")
    panel:SetUpdateOnType(true)
    panel:SetNumeric(true)
    panel:SetCursor("sizens")

    function panel:RiceUI_Event(event, id, pnl)
        if id == "NumberWang" then
            self:SetValue(self.Value + pnl.Value)
        end

        if self:GetParent().RiceUI_Event then
            self:GetParent():RiceUI_Event(name, id, data)
        end
    end

    function panel:OnMouseWheeled(dlt)
        self:SetValue(math.Clamp(self.Value + dlt * self.Step, self.Min, self.Max))
    end

    function panel:OnChange()
        self:SetValue(math.Clamp(self:GetFloat() or 0, self.Min, self.Max))
    end

    function panel:SetValue(val)
        self.Value = math.Clamp(val, self.Min, self.Max)

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