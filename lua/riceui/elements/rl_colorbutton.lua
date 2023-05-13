local Element = {}
Element.Editor = {Category="input"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 30,
        h = 30,
        Theme = {ThemeName="modern",ThemeType="ColorButton",Color="white",TextColor="white"},
    })

    local panel = RiceUI.SimpleCreate({type="rl_button", x=data.x, y=data.y, w=data.w, h=data.h, Theme = data.Theme},parent)
    panel.GThemeType = "RL_ColorButton"
    panel.ProcessID = "RL_ColorButton"

    function panel:DoClick()

    end

    function panel:RiceUI_Event(event,id,pnl)
        if event == "ColorButton_PickerSeleted" then
            self.Value = id

            return
        end

        if self:GetParent().RiceUI_Event then
            self:GetParent():RiceUI_Event(name,id,pnl)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element