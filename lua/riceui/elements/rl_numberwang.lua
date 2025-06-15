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
        ThemeNT = data.ThemeNT,

        ProcessID = "RL_NumberWang",

        children = {
            {type = "rl_panel",
                ThemeNT = {
                    Class = "NoDraw"
                },

                Dock = RIGHT,
                w = 24,

                children = {
                    {type = "rl_button",
                        Dock = TOP,
                        Margin = {0, 4, 0, 0},
                        h = data.h / 2,

                        ID = "NumberWang",
                        Value = data.Step,

                        Scale = 1,
                        Ang = 180,

                        ThemeNT = {
                            Style = "NumberWang_Button"
                        }
                    },
                    {type = "rl_button",
                        Dock = BOTTOM,
                        Margin = {0, 0, 0, 4},
                        h = data.h / 2,

                        ID = "NumberWang",
                        Value = -data.Step,

                        Ang = 0,

                        ThemeNT = {
                            Style = "NumberWang_Button"
                        }
                    }
                }
            }
        }
    }, parent)

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
        local val =  dlt * self.Step

        if input.IsKeyDown(KEY_LCONTROL) then
            val = math.Round(val / 10, self.Dec)
        end

        self:SetValue(math.Clamp(self.Value + val, self.Min, self.Max), true)
    end

    function panel:OnChange()
        local val = self:GetFloat() or 0

        self:SetValue(math.Clamp(math.Round(val, self.Dec or 0), self.Min, self.Max), true)
    end

    function panel:SetValue(val, doValueChange)
        self.Value = math.Clamp(math.Round(val or 0, self.Dec or 0), self.Min, self.Max)

        if doValueChange then self:OnValueChanged(val) end
    end

    function panel:GetValue()
        return self.Value
    end

    --[[function panel:GetText()
        return tostring(self.Value)
    end]]

    function panel:OnValueChanged(val)
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element