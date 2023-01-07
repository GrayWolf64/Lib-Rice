local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local x,y = RL.hudScale(data.x,data.y)
    local w,h = RL.hudScale(data.w,data.h)

    local panel = RL.VGUI.ScrollPanel(parent,x,y,w,h)

    RiceUI.Process("panel",panel,data)

    return panel
end

return main