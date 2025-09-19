RiceUI.DefineWidget("labeled_switch", function(data, parent, root)
    data = RiceLib.table.Inherit(data, {type = "rl_panel",
        ThemeNT = {
            Class = "NoDraw"
        },

        ChildrenIgnoreRoot = true,
        children = {
            {type = "label",
                Dock = LEFT,

                Text = data.Text,
                Font = data.Font
            },

            {type = "rl_switch",
                ID = "Switch",

                Dock = RIGHT,
                w = data.SwitchW,

                Value = data.Value,
                OnValueChanged = function(self, val)
                    data.OnValueChanged(self:GetParent(), val)
                end
            }
        }
    })

    data.widget = nil

    RiceUI.SimpleCreate(data, parent, root)
end)

RiceUI.DefineWidget("rl_vectorinput", function(data, parent, root)
    data = RiceLib.table.Inherit(data, {type = "rl_panel",
        w = 512,
        h = 32,

        ThemeNT = {
            Class = "NoDraw"
        },

        OnValueChange = function(self, key, value)
            self.Value[key] = value

            self:OnValueChanged(self.Value)
        end,

        OnValueChanged = function(self, value)
        end,

        ChildrenIgnoreRoot = true,
        children = {
            {type = "rl_numberwang",
                ID = "X",

                Dock = LEFT,

                Min = -math.huge,
                Max = math.huge,

                OnValueChanged = function(self, val)
                    self:GetParent():OnValueChange("x", val)
                end,
            },

            {type = "rl_numberwang",
                ID = "Y",

                Dock = LEFT,
                Margin = {8, 0, 0, 0},

                Min = -math.huge,
                Max = math.huge,

                OnValueChanged = function(self, val)
                    self:GetParent():OnValueChange("y", val)
                end,
            },

            {type = "rl_numberwang",
                ID = "Z",

                Dock = LEFT,
                Margin = {8, 0, 0, 0},

                Min = -math.huge,
                Max = math.huge,

                OnValueChanged = function(self, val)
                    self:GetParent():OnValueChange("z", val)
                end,
            },
        }
    })

    data.widget = nil

    local widget = RiceUI.SimpleCreate(data, parent, root)
    local value = Vector(data.Value or vector_origin)

    widget:GetElement("X"):SetValue(value.x)
    widget:GetElement("Y"):SetValue(value.y)
    widget:GetElement("Z"):SetValue(value.z)
end)