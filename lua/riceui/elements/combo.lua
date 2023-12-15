local Element = {}

function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        Font = "OPPOSans_20"
    })

    local panel = vgui.Create("DComboBox",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetValue(data.Value)
    panel:SetFont(data.Font)

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    if data.options then
        for _,value in ipairs(data.options) do
            panel:AddChoice(value)
        end
    end

    return panel
end

return Element