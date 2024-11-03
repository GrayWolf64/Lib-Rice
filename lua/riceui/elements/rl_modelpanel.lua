local Element = {}

Element.Editor = {
    Category = "display"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 16,
        y = 16,
        w = 512,
        h = 384,
    })

    local panel = vgui.Create("DAdjustableModelPanel", parent)
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    if data.Model then panel:SetModel(data.Model) end

    local angle = Angle( 45, 0, 0 )
    panel:SetLookAng( angle )
    panel:SetCamPos( Vector( 0, 0, 0 ) + angle:Forward() * -50 )

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element