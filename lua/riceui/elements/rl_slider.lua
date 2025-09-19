local Element = {}
Element.Editor = {Category = "interact"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 20,
        y = 10,
        w = 300,
        h = 20,
        Min = 0,
        Max = 100,
        Decimals = 0,
        Step = 1
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetText("")
    panel.ProcessID = "Slider"
    panel.Min = 0
    panel.Max = 100
    panel.Value = 50
    panel.Decimals = 0
    panel.SlideFraction = 0.5
    panel.ShowTextStart = 0
    panel.ShowTextEnd = 0

    function panel:GetMax() return panel.Max end
    function panel:GetMin() return panel.Min end

    function panel:GetValue()
        return self.Value
    end

    function panel:OnValueChanged(value)
    end

    function panel:SetValue(value)
        value = math.Round(math.Clamp(value, self.Min, self.Max), self.Decimals)

        local h = self:GetTall()
        local x = math.Remap(value, self.Min, self.Max, h / 2, self:GetWide() - h / 2)
        self.SlideFraction = x / self:GetWide()

        self:SetValueInternal(value)
    end

    function panel:SetValueInternal(value)
        value = math.Round(math.Clamp(value, self.Min, self.Max), self.Decimals)

        self.Value = value

        self:OnValueChanged(value)
    end

    function panel:OnMouseWheeled(delta)
        self.ShowTextEnd = SysTime() + 0.5
        self.ShowTextStart = SysTime()

        self:SetValue(self:GetValue() + delta)
    end

    function panel:GetCursorValue()
        local h = self:GetTall()
        local x = self:CursorPos()
        self.SlideFraction = math.Clamp(x, h / 2, self:GetWide() - h / 2) / self:GetWide()

        self.ShowTextEnd = SysTime() + 0.5
        self.ShowTextStart = SysTime()

        self:SetValueInternal(math.Remap(x, h / 2, self:GetWide() - h / 2, self.Min, self.Max))
    end

    function panel:OnMousePressed()
        self:GetCursorValue()

        self:MouseCapture(true)
        self.Sliding = true
    end

    function panel:OnMouseReleased()
        self:MouseCapture(false)
        self.Sliding = false
    end

    function panel:Think()
        if not self.Sliding then return end

        self:GetCursorValue()
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element