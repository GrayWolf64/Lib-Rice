local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local x,y = RL.hudScale(data.x,data.y)
    local w,h = RL.hudScale(data.w,data.h)

    local _,panel = RL.VGUI.ModernComboBox(data.Text or "",parent,data.FontSize or 30,x,y,w,h,RL.hudScaleX(data.cw),data.OnSelect,data.DarkMode)
    panel:SetValue(data.Value)

    if data.options then
        for _,value in ipairs(data.options) do
            panel:AddChoice(value)
        end
    end

    RiceUI.Process("panel",panel,data)

    return panel
end

return main