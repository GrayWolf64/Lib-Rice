local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(40,40,40,150)

    if self:IsHovered() and self:GetClassName() == "Label" then color = Color(60,60,60,150) end

    draw.RoundedBox(RL_hudScaleX(5), 0, 0, w, h, color)
end

Theme.TextColor = Color(200, 200, 200)
Theme.TextFont = "OPPOSans_30"

return "GlassDark", Theme