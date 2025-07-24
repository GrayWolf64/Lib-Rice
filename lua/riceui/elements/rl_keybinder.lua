local Element = {}

function Element.Create(data, parent, root)
    RiceLib.table.Inherit(data,{
        x = 16,
        y = 16,
        w = 64,
        h = 48,

        Font = "RiceUI_30"
    })

    local panel = RiceUI.SimpleCreate({type = "rl_button",
        Text = "",
        Font = data.Font,

        ThemeNT = {
            Style = "Keybinder"
        },

        SetValue = function(self, val)
            self.Value = val
        end,

        GetValue = function(self)
            return self.Value
        end,

        KeyTrapping = false,
        DoClick = function(self)
            input.StartKeyTrapping()
            self.KeyTrapping = true
        end,

        KeybindID = data.KeybindID,

        Think = function(self)
            if not input.IsKeyTrapping() then return end
            if not self.KeyTrapping then return end

            local key = input.CheckKeyTrapping()

            if key then
                self.KeyTrapping = false
                self.Value = key

                if self.KeybindID then
                    RiceLib.Keybinds.SetKey(self.KeybindID, key)
                end

                self:OnValueChanged(key)
            end
        end,

        OnValueChanged = function() end
    }, parent, root)

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element