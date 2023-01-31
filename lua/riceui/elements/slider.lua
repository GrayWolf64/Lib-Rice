local function main(data,parent)
    table.Inherit(data,{
        x = 20,
        y = 10,
        w = 300,
        h = 20,
        Min = 0,
        Max = 100,
        Decimals = 0,
    })

    local panel = vgui.Create("DSlider",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetSlideX(0)
    panel.Min = data.Min
    panel.Max = data.Max
    panel.Decimals = data.Decimals
    panel.GThemeType = "Slider"
    panel.NoGTheme = data.NoGTheme

    panel.Knob.Paint = function()end

    function panel:GetMax() return panel.Max end
    function panel:GetMin() return panel.Min end

    function panel:GetValue()
        return math.Round(math.Remap(panel:GetSlideX(),0,1,panel.Min,panel.Max),panel.Decimals)
    end

    RiceUI.Process("panel",panel,data)

    return panel
end

return main