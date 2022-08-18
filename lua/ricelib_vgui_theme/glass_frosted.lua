local Theme = {}
local mat = Material("pp/blurscreen")

Theme.Paint = function(self, w, h)
    surface.SetMaterial(mat)

    surface.SetDrawColor(255,255,255,50)
    surface.DrawOutlinedRect(0,0,w,h,RL.hudScaleX(5))

    surface.SetDrawColor(255,255,255,25)
    for i = 1, 32 do
        surface.DrawTexturedRect(-self:GetX()+math.cos(360/i)*4,-self:GetY()+math.sin(360/i)*4,ScrW(),ScrH())
    end

    surface.SetDrawColor(255,255,255,5)
    surface.DrawRect(0,0,w,h)
end

Theme.TextColor = Color(30, 30, 30)
Theme.TextFont = "OPPOSans_30"

return "GlassFrosted", Theme