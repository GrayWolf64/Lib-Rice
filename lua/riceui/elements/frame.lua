local Element = {}

function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("DFrame",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element