local styles = {}

local function drawBox(self, w, h, Color)
    draw.RoundedBox(10, 0, 0, w, h, Color)
end

styles.Default = function(self, w ,h)
    drawBox(self, w, h, self.ThemeColors.Fill.Card.Primary)
end

RiceUI.ThemeNT.DefineStyle("modern_nt", "Panel", styles)