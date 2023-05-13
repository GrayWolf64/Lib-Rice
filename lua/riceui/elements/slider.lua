local Element = {}
Element.Editor = {Category="interact"}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 20,
        y = 10,
        w = 300,
        h = 20,
        Min = 0,
        Max = 100,
        Decimals = 0,
        Theme={ThemeName="modern",ThemeType="Slider",Color="white"},
    })

    local panel = vgui.Create("DSlider",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetSlideX(0)
    panel.GThemeType = "Slider"
    panel.ProcessID = "Slider"

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    panel.Knob.Paint = function()end

    function panel:GetMax() return panel.Max end
    function panel:GetMin() return panel.Min end

    function panel:GetValue()
        return math.Round(math.Remap(panel:GetSlideX(),0,1,panel.Min,panel.Max),panel.Decimals)
    end

    function panel:OnMouseWheeled(dlt)
        self:SetSlideX(math.Clamp(self:GetSlideX() + dlt/100,0,1))
    end

    return panel
end

return Element