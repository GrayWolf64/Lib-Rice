local Element = {}
Element.Editor = {Category="input"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 120,
        h = 30,
        Theme = {ThemeName = "modern",ThemeType="NumberWang",Color="white",TextColor="white"},
        Step = 1,
    })

    local panel = RiceUI.SimpleCreate({type="entry", x=data.x, y=data.y, w=data.w, h=data.h, Theme = data.Theme,
        children = {
            {type="rl_panel",Theme={},Paint=function()end,w=25,Dock=RIGHT,
                children = {
                    {type="rl_button",Dock=TOP,h=data.h/2,ID="NumberWang",Value=data.Step,Theme=table.Merge(table.Copy(data.Theme),{Scale=1,Ang=180,ThemeType="NumberWang_Button"})},
                    {type="rl_button",Dock=TOP,h=data.h/2,ID="NumberWang",Value=-data.Step,Theme=table.Merge(table.Copy(data.Theme),{Ang=0,ThemeType="NumberWang_Button"})}
                }
            }
        }
    },parent)
    panel.GThemeType = "RL_NumberWang"
    panel.ProcessID = "RL_NumberWang"

    panel:SetPlaceholderText("")
    panel:SetNumeric(true)
    panel:SetValue(0)

    function panel:RiceUI_Event(event,id,pnl)
        if id == "NumberWang" then
            panel:SetValue(panel:GetFloat() + pnl.Value)
        end

        if panel:GetParent().RiceUI_Event then
            panel:GetParent().RiceUI_Event(name,id,data)
        end
    end

    function panel:OnMouseWheeled(dlt)
        panel:SetValue(panel:GetFloat() + dlt * panel.Step)
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element