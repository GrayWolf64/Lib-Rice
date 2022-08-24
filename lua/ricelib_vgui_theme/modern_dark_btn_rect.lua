local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(60,60,60,255)

    if self:IsHovered() and self:GetClassName() == "Label" then color = Color(90,90,90,255) end

    draw.RoundedBox(0, 0, 0, w, h, color)
end

Theme.TextColor = Color(250, 250, 250)
Theme.TextFont = "OPPOSans_30"

return "ModernDarkButtonRect", Theme