local Element = {}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("DHTML",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))

    if data.HTML ~= nil then panel:SetHTML(data.HTML) end
    if data.URL ~= nil then panel:SetURL(data.URL) end

    panel.ProcessID = "HTML"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element