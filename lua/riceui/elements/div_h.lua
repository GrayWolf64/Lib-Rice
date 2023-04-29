local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        L_Width=100,
        L_Min=100,
        R_Min=100,
        DivWidth = 4,
    })

    local panel = vgui.Create("DHorizontalDivider",parent)
    panel:Dock(FILL)
    panel:SetDividerWidth( data.DivWidth )
    panel:SetLeftMin( data.L_Min )
    panel:SetRightMin( data.R_Min )
    panel:SetLeftWidth( data.L_Width )

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    if panel.Left then
        local left = RiceUI.SimpleCreate(panel.Left,parent)
        panel:SetLeft(left)
    end

    if panel.Right then
        local right = RiceUI.SimpleCreate(panel.Right,parent)
        panel:SetRight(right)
    end

    return panel
end

return Element