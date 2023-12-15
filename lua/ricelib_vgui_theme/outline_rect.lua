local Theme = {}

Theme.MainColor = Color(230,230,230,255)
Theme.HoverColor = Color(250,250,250,255)
Theme.OutlineColor = Color(150,150,150,255)

Theme.Paint = function(self, w, h)
    local scale = RL_hudScaleX(2)
    local color = self.Theme.MainColor

    if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

    surface.SetDrawColor(color)
    surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(self.Theme.OutlineColor)
    surface.DrawOutlinedRect(0,0,w,h,RiceLib.hudScaleX(self.OutlineSize or 1))
end

Theme.TextColor = Color(20, 20, 20)
Theme.TextFont = "OPPOSans_30"

return "OutlineRect", Theme