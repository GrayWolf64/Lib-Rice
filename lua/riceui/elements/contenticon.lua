local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,

        Material =  "entities/weapon_pistol.png",
        Name = "Pistol",
    })

    local panel = vgui.Create("ContentIcon",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetMaterial(data.Material)
    panel:SetName(data.Name)
    panel.ProcessID = "Panel"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element