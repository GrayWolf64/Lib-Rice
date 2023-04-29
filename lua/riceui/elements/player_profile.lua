local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("AvatarImage",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetPlayer(data.ply,data.w)

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    RiceUI.Process("panel",panel,data)

    return panel
end

return Element