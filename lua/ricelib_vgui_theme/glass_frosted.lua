local Theme = {}

Theme.Paint = function(self, w, h)
    surface.SetDrawColor(255,255,255,50)
    surface.DrawOutlinedRect(0,0,w,h,RiceLib.hudScaleX(5))

    RiceLib.VGUI.blurPanel(self,self.BlurSize or 5)
end

Theme.TextColor = Color(30, 30, 30)
Theme.TextFont = "OPPOSans_30"

return "GlassFrosted", Theme