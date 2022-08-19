local Theme = {}

Theme.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(70,70,70,255))
end

Theme.TextColor = Color(250, 250, 250)
Theme.TextFont = "OPPOSans_30"

return "ModernDarkScrollBar", Theme