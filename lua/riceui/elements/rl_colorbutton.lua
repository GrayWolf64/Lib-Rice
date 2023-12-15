local Element = {}
Element.Editor = {Category="input"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 30,
        h = 30,
        Theme = {ThemeName="modern",ThemeType="ColorButton",Color="white",TextColor="white"},
    })

    local panel = RiceUI.SimpleCreate({type="rl_button", x=data.x, y=data.y, w=data.w, h=data.h, Theme = data.Theme},parent)
    panel.ProcessID = "ColorButton"
    panel.Value = Color(255,0,0)

    function panel:DoClick()
        if IsValid(self.ColorPicker) then return end

        self.ColorPicker = RiceUI.SimpleCreate({type = "rl_popup",
            w = 300,
            h = 250,

            Parent = self,

            children = {
                {type = "color_mixer",
                    Value = self.Value,

                    Dock = FILL,
                    Margin = {10,10,10,10},

                    ValueChanged = function(_,val)
                        self.Value = val

                        self:OnValueChanged(val)
                    end
                }
            }
        })
    end

    function panel:OnValueChanged(val)
    end

    function panel:RiceUI_Event(event,id,pnl)
        if self:GetParent().RiceUI_Event then
            self:GetParent():RiceUI_Event(name,id,pnl)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element