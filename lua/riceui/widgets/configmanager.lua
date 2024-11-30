RiceUI.DefineWidget("RiceLib_ConfigManager_Number", function(data, parent)
    local entry = data.Entry

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 32,

        ThemeNT = {
            Class = "NoDraw"
        },

        ConfigEntry = entry,

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "rl_numberwang",
                Dock = RIGHT,
                w = 196,

                Min = entry.Min,
                Max = entry.Max,
                Dec = entry.Dec,
                Step = entry.Step,

                Value = entry:GetValue(),
                OnValueChanged = function(self, val)
                    entry:SetValue(val)
                end
            }
        }
    }, parent)
end)

RiceUI.DefineWidget("RiceLib_ConfigManager_Bool", function(data, parent)
    local entry = data.Entry

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 32,

        ThemeNT = {
            Class = "NoDraw"
        },

        ConfigEntry = entry,

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "switch",
                Dock = RIGHT,
                w = 64,

                Value = entry:GetValue(),
                OnValueChanged = function(self, val)
                    entry:SetValue(val)
                end
            }
        }
    }, parent)
end)

RiceUI.DefineWidget("RiceLib_ConfigManager_Keybind", function(data, parent)
    local entry = data.Entry

    if entry:GetValue() == 0 and RiceLib.Keybinds.GetKey(entry.Command) then
        entry:SetValue(RiceLib.Keybinds.GetKey(entry.Command))
    end

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 40,

        ThemeNT = {
            Class = "NoDraw"
        },

        ConfigEntry = entry,

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "rl_keybinder",
                Dock = RIGHT,
                w = 64,

                Command = entry.Command,

                Value = entry:GetValue(),
                OnValueChanged = function(self, val)
                    entry:SetValue(val)
                end
            }
        }
    }, parent)
end)