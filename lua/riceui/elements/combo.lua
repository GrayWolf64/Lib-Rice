local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        Font = "OPPOSans_20"
    })

    local panel = vgui.Create("DComboBox",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetValue(data.Value)
    panel:SetFont(data.Font)
    panel.OnSelect = data.OnSelect or function()end
    
    if data.options then
        for _,value in ipairs(data.options) do
            panel:AddChoice(value)
        end
    end

    RiceUI.Process("panel",panel,data)

    return panel
end

return main