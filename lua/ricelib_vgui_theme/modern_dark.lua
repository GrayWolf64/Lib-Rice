local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(40,40,40,255)

    if self:IsHovered() and self:GetClassName() == "Label" then color = Color(60,60,60,255) end

    draw.RoundedBox(RL_hudScaleX(7), 0, 0, w, h, color)
end

Theme.TextColor = Color(250, 250, 250)
Theme.TextFont = "OPPOSans_30"

return "ModernDark", Theme