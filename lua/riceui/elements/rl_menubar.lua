local Element = {}
Element.Editor = {Category="interact"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        Options = {},
    })

    local panel = vgui.Create("rl_panel",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel.GThemeType = "MenuBar"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    panel.Layout = RiceUI.SimpleCreate({type="layout",Dock=FILL})

    for k,v in pairs(panel.Options) do
        local btn = panel.Layout:Add("DButton")

        function btn:DoClick()
            panel.RiceUI_Event("MenuBar_Select",k,v)
        end
    end

    return panel
end

return Element