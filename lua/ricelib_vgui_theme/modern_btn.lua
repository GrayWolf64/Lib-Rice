local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(220,220,220,255)
    local r = 7

    if h <= 25 then r = 5 end
    if self:IsHovered() and self:GetClassName() == "Label" then color = Color(255,255,255,255) end

    draw.RoundedBox(RL_hudScaleY(r), 0, 0, w, h, Color(150,150,150,255))
    draw.RoundedBox(RL_hudScaleY(r), RL_hudScaleX(1), RL_hudScaleY(1), w-RL_hudScaleX(2), h-RL_hudScaleY(2), color)
end

Theme.TextColor = Color(20, 20, 20)
Theme.TextFont = "OPPOSans_30"

return "ModernLightButton", Theme