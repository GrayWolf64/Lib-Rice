local Theme = {}

Theme.Paint = function(self, w, h)
    local color = Color(240,240,240,255)

    draw.RoundedBox(RL_hudScaleX(7), 0, 2, w, h-2, Color(0,0,0,150))
    draw.RoundedBox(RL_hudScaleX(7), 2, 0, w-2, h-2, color)
end

Theme.TextColor = Color(20, 20, 20)
Theme.TextFont = "OPPOSans_30"

return "ModernShadow", Theme