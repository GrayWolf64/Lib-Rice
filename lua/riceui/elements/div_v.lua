local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        T_Height=100,
        T_Min=100,
        B_Min=100,
        DivWidth = 4,
    })

    local panel = vgui.Create("DVerticalDivider",parent)
    panel:Dock(FILL)
    panel:SetDividerWidth( data.DivWidth )
    panel:SetTopMin( data.T_Min )
    panel:SetBottomMin( data.B_Min )
    panel:SetTopHeight( data.T_Height )

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    if panel.Top then
        panel:SetTop(RiceUI.SimpleCreate(panel.Top))
    end

    if panel.Buttom then
        panel:SetBottom(RiceUI.SimpleCreate(panel.Bottom))
    end

    return panel
end

return Element