local Element = {}
Element.Editor = {Category="base"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        ThemeName = "modern_rect",
        Theme = {Color="white"},
    })

    local x,y = RL.hudScale(data.x,data.y)
    local w,h = RL.hudScale(data.w,data.h)

    local panel = RL.VGUI.ScrollPanel(parent,x,y,w,h)

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    function panel.ChildCreated()
        local VBar = panel:GetVBar()

        if !RiceUI.GetTheme(data.ThemeName).ScrollPanel_VBar then return end

        VBar.Paint = RiceUI.GetTheme(data.ThemeName).ScrollPanel_VBar
        VBar.Theme = data.Theme

        VBar.btnGrip.Paint = RiceUI.GetTheme(data.ThemeName).ScrollPanel_VBar_Grip
        VBar.btnGrip.Theme = data.Theme
    end

    return panel
end

return Element