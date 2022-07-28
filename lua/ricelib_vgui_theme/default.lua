local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(150, 150, 150, 150)

    if self:IsHovered() and self:GetClassName() == "Label" then color = Color(200, 200, 200, 150) end

    draw.RoundedBox(0, 0, 0, w, h, color)
end

Theme.TextColor = Color(255, 255, 255)
Theme.TextFont = "OPPOSans_30"

return "Default", Theme