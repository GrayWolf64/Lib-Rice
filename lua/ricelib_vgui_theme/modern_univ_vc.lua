local Theme = {}

Theme.MainColor = Color(240,240,240,255)
Theme.HoverColor = Color(255,255,255,255)
Theme.Curver = 7

Theme.Paint = function(self, w, h)
    local color = self.Theme.MainColor

    if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

    draw.RoundedBox(RL_hudScaleX(self.Theme.Curver), 0, 0, w, h, color)
end

Theme.TextColor = Color(20, 20, 20)
Theme.TextFont = "OPPOSans_30"

return "ModernVC", Theme