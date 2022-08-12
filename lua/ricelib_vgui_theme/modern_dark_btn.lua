local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(60,60,60,255)
    local r = 7

    if h <= 25 then r = 5 end

    if self:IsHovered() and self:GetClassName() == "Label" then color = Color(90,90,90,255) end

    draw.RoundedBox(RL_hudScaleY(r), 0, 0, w, h, color)
end

Theme.TextColor = Color(250, 250, 250)
Theme.TextFont = "OPPOSans_30"

return "ModernDarkButton", Theme