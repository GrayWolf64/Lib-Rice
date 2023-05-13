local Element = {}

function Element.Create(data,parent)
    local panel = vgui.Create("DMenu",parent)

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    if data.options then
        for _,value in ipairs(data.options) do
            panel:AddOption(value)
        end
    end

    return panel
end

return Element