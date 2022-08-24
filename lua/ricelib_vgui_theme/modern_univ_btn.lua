local Theme = {}

Theme.MainColor = Color(230,230,230,255)
Theme.HoverColor = Color(255,255,255,255)
Theme.OutlineColor = Color(150,150,150,255)

Theme.Paint = function(self, w, h)
    local color = self.Theme.MainColor
    local r = 7

    if h <= 25 then r = 5 end
    if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

    draw.RoundedBox(RL_hudScaleY(r), 0, 0, w, h, self.Theme.OutlineColor)
    draw.RoundedBox(RL_hudScaleY(r), RL_hudScaleX(1), RL_hudScaleY(1), w-RL_hudScaleX(2), h-RL_hudScaleY(2), color)
end

Theme.TextColor = Color(20, 20, 20)
Theme.TextFont = "OPPOSans_30"

return "ModernButton", Theme