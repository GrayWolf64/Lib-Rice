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

            {type = "switch",
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