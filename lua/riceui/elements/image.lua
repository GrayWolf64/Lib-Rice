local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "vgui/cursors/hand"
    })

    local panel = vgui.Create("DImageButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetImage(data.Image)

    RiceUI.Process("panel",panel,data)
    RiceUI.Process("button",panel,data)

    return panel
end

return main