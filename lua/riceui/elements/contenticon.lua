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
    panel:SetName(data.Name)
    panel.ProcessID = "Panel"

    function panel:SetMaterial(name)
        if not isstring(name) then
            self.Image:SetMaterial(name)
            self.m_MaterialName = name:GetName()

            return
        end

        self.m_MaterialName = name
        local mat = Material(name)

        -- Look for the old style material
        if not mat or mat:IsError() then
            name = name:Replace("entities/", "VGUI/entities/")
            name = name:Replace(".png", "")
            mat = Material(name)
        end

        -- Couldn't find any material.. just return
        if not mat or mat:IsError() then return end
        self.Image:SetMaterial(mat)
    end

    panel:SetMaterial(data.Material)


    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element