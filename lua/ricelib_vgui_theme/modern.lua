local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(230,230,230,255)

    if self:IsHovered() and self:GetClassName() == "Label" then color = Color(255,255,255,255) end

    draw.RoundedBox(RL_hudScaleX(7), 0, 0, w, h, color)
end

Theme.TextColor = Color(20, 20, 20)
Theme.TextFont = "OPPOSans_30"

return "Modern", Theme