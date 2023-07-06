local Element = {}

Element.Editor = {
    Category = "interact"
}

function Element.Create(data, parent)
    RL.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "rl_icons/circle-play.png",
        Color = Color(255, 255, 255),
        Color_Hover = Color(64, 158, 255),
        Angle = 0
    })

    local panel = vgui.Create("DButton", parent)
    panel:SetPos(RL.hudScale(data.x, data.y))
    panel:SetSize(RL.hudScale(data.w, data.h))
    panel:SetText("")
    panel.ProcessID = "ImageButton"

    function panel:SetImage(img)
        panel.Mat = Material(img, "noclamp smooth")
    end

    panel.Mat = Material(data.Image)

    function panel:Paint(w, h)
        surface.SetDrawColor(self.Color)

        if self:IsHovered() then
            surface.SetDrawColor(self.Color_Hover)
        end

        surface.SetMaterial(self.Mat)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, self.Angle)
    end

    function panel:DoClick()
        if self:GetParent().RiceUI_Event then
            self:GetParent().RiceUI_Event("Button_Click", self.ID, self)
        end
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))
    panel:SetImage(panel.Image)

    return panel
end

return Element