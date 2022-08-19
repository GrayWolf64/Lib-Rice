local Theme = {}

Theme.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(230,230,230,255))
end

Theme.TextColor = Color(20, 20, 20)
Theme.TextFont = "OPPOSans_30"

return "ModernScrollBar", Theme