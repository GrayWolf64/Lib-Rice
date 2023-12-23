local Element = {}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,

        Material =  "entities/weapon_pistol.png",
        Name = "Pistol",
    })

    local panel = vgui.Create("ContentIcon",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetMaterial(data.Material)
    panel:SetName(data.Name)
    panel.ProcessID = "Panel"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element