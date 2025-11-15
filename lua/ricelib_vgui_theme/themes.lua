local function THEME(name, theme)
    RiceLib.VGUI.Theme[name] = theme

    RiceLib.Info("Installed " .. name, "RiceLib VGUI Theme")
end

THEME("Default", {
    Paint = function(self, w, h)
        local color = Color(150, 150, 150, 150)

        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(200, 200, 200, 150) end

        draw.RoundedBox(0, 0, 0, w, h, color)
    end,
    TextColor = Color(255, 255, 255),
    TextFont = "OPPOSans_30"
})

THEME("GlassDark", {
    Paint = function(self, w, h)
        local color = Color(40,40,40,150)

        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(60,60,60,150) end

        draw.RoundedBox(RL_hudScaleX(5), 0, 0, w, h, color)
    end,
    TextColor = Color(200, 200, 200),
    TextFont = "OPPOSans_30"
})

THEME("GlassFrosted", {
    Paint = function(self, w, h)
        surface.SetDrawColor(255,255,255,50)
        surface.DrawOutlinedRect(0,0,w,h,RiceLib.hudScaleX(5))

        RiceLib.VGUI.blurPanel(self,self.BlurSize or 5)
    end,
    TextColor = Color(30, 30, 30),
    TextFont = "OPPOSans_30"
})

THEME("ModernLightButton", {
    Paint = function(self, w, h)
        local color = Color(220,220,220,255)
        local r = 7

        if h <= 25 then r = 5 end
        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(255,255,255,255) end

        draw.RoundedBox(RL_hudScaleY(r), 0, 0, w, h, Color(150,150,150,255))
        draw.RoundedBox(RL_hudScaleY(r), RL_hudScaleX(1), RL_hudScaleY(1), w-RL_hudScaleX(2), h-RL_hudScaleY(2), color)
    end,
    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("ModernDarkButtonRect", {
    Paint = function(self, w, h)
        local color = Color(60,60,60,255)

        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(90,90,90,255) end

        draw.RoundedBox(0, 0, 0, w, h, color)
    end,
    TextColor = Color(250, 250, 250),
    TextFont = "OPPOSans_30"
})

THEME("ModernDarkButton", {
    Paint = function(self, w, h)
        local color = Color(60,60,60,255)
        local r = 7

        if h <= 25 then r = 5 end

        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(90,90,90,255) end

        draw.RoundedBox(RL_hudScaleY(r), 0, 0, w, h, color)
    end,
    TextColor = Color(250, 250, 250),
    TextFont = "OPPOSans_30"
})

THEME("ModernDarkRect", {
    Paint = function(self, w, h)
        local color = Color(40,40,40,255)

        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(60,60,60,255) end

        draw.RoundedBox(0, 0, 0, w, h, color)
    end,
    TextColor = Color(250, 250, 250),
    TextFont = "OPPOSans_30"
})

THEME("ModernDarkScrollBar", {
    Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(70,70,70,255))
    end,
    TextColor = Color(250, 250, 250),
    TextFont = "OPPOSans_30"
})

THEME("ModernDark", {
    Paint = function(self, w, h)
        local color = Color(40,40,40,255)

        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(60,60,60,255) end

        draw.RoundedBox(RL_hudScaleX(7), 0, 0, w, h, color)
    end,
    TextColor = Color(250, 250, 250),
    TextFont = "OPPOSans_30"
})

THEME("ModernScrollBar", {
    Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(230,230,230,255))
    end,
    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("ModernShadow", {
    Paint = function(self, w, h)
        local color = Color(240,240,240,255)

        draw.RoundedBox(RL_hudScaleX(7), 0, 2, w, h-2, Color(0,0,0,150))
        draw.RoundedBox(RL_hudScaleX(7), 2, 0, w-2, h-2, color)
    end,
    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("ModernButton", {
    MainColor = Color(230,230,230,255),
    HoverColor = Color(255,255,255,255),
    OutlineColor = Color(150,150,150,255),

    Paint = function(self, w, h)
        local color = self.Theme.MainColor
        local r = 7

        if h <= 25 then r = 5 end
        if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

        draw.RoundedBox(RL_hudScaleY(r), 0, 0, w, h, self.Theme.OutlineColor)
        draw.RoundedBox(RL_hudScaleY(r), RL_hudScaleX(1), RL_hudScaleY(1), w-RL_hudScaleX(2), h-RL_hudScaleY(2), color)
    end,

    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("ModernRect", {
    MainColor = Color(230,230,230,255),
    HoverColor = Color(255,255,255,255),

    Paint = function(self, w, h)
        local color = self.Theme.MainColor

        if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

        draw.RoundedBox(0, 0, 0, w, h, color)
    end,

    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("ModernVC", {
    MainColor = Color(240,240,240,255),
    HoverColor = Color(255,255,255,255),
    Curver = 7,
    Paint = function(self, w, h)
        local color = self.Theme.MainColor

        if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

        draw.RoundedBox(RL_hudScaleX(self.Theme.Curver), 0, 0, w, h, color)
    end,
    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("Modern", {
    MainColor = Color(240,240,240,255),
    HoverColor = Color(255,255,255,255),
    Paint = function(self, w, h)
        local color = self.Theme.MainColor

        if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

        draw.RoundedBox(RL_hudScaleX(7), 0, 0, w, h, color)
    end,
    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("ModernLight", {
    Paint = function(self, w, h)
        local color = Color(230,230,230,255)

        if self:IsHovered() and self:GetClassName() == "Label" then color = Color(255,255,255,255) end

        draw.RoundedBox(RL_hudScaleX(7), 0, 0, w, h, color)
    end,
    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})

THEME("OutlineRect", {
    MainColor = Color(230,230,230,255),
    HoverColor = Color(250,250,250,255),
    OutlineColor = Color(150,150,150,255),
    Paint = function(self, w, h)
        local color = self.Theme.MainColor

        if self:IsHovered() and self:GetClassName() == "Label" then color = self.Theme.HoverColor end

        surface.SetDrawColor(color)
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(self.Theme.OutlineColor)
        surface.DrawOutlinedRect(0,0,w,h,RiceLib.hudScaleX(self.OutlineSize or 1))
    end,
    TextColor = Color(20, 20, 20),
    TextFont = "OPPOSans_30"
})