local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = RL.VGUI.ScrollPanel(parent,data.x,data.y,data.w,data.h)

    RiceUI.Process("panel",panel,data)

    return panel
end

return main