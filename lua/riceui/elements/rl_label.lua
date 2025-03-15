    local Element = {}
Element.Editor = {Category = "interact"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 100,
        h = 50,

        Font = "RiceUI_M_28",
        Text = "按钮",

        ThemeNT = {
            Class = "Label"
        }
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetText("")
    panel.DoubleClickTimer = 0
    panel.GThemeType = "Label"
    panel.ProcessID = "Label"

    function panel:DoClick()
    end

    function panel:OnMouseReleased()
        self.Depressed = false

        self:MouseCapture(false)
    end

    function panel:OnMousePressed(keyCode)
        if keyCode == MOUSE_LEFT then
            if self.DoubleClickTimer > RealTime() then self:DoDoubleClick() return end
            self.DoubleClickTimer = RealTime() + 0.2

            if self.ClickSound then surface.PlaySound(self.ClickSound) end

            self:DoClick()
        end

        if keyCode == MOUSE_RIGHT then self:DoRightClick() end
        if keyCode == MOUSE_MIDDLE then self:DoMiddleClick() end

        self.Depressed = true

        self:MouseCapture(true)
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element