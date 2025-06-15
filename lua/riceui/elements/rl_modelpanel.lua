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

        CamAngle = Angle( 45, 0, 0 ),
        CamPos = Angle( 45, 0, 0 ):Forward() * -50
    })

    local panel
    if data.Static then
        panel = vgui.Create("DModelPanel", parent)
    else
        panel = vgui.Create("DAdjustableModelPanel", parent)
    end

    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    if data.Model then panel:SetModel(data.Model) end

    panel:SetLookAng( data.CamAngle )
    panel:SetCamPos( data.CamPos )

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element