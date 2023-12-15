RiceLib.VGUI = RiceLib.VGUI or {}

local function reload_themes()
    local themes_folder = "ricelib_vgui_theme/"
    local files = file.Find(themes_folder .. "*.lua", "LUA")

    if SERVER then
        for _, v in ipairs(files) do AddCSLuaFile(themes_folder .. v) end
    else
        for _, v in ipairs(files) do
            local name, theme = include(themes_folder .. v)
            if not name or not theme then return end

            RiceLib.VGUI.RegisterTheme(name, theme)

            RiceLib.Message("Loaded " .. name, "RiceLib VGUI Theme")
        end
    end
end

if CLIENT then
    local function get_root(vgui)
        local parent = vgui:GetParent()
        if not parent then return vgui end
        if parent:GetClassName() == "CGModBase" then return vgui end

        return get_root(parent)
    end

    local blur_passes = 6
    local blur_mat = Material"pp/blurscreen"

    local function blurPanel(panel, amount)
        local x, y = panel:LocalToScreen(0, 0)
        surface.SetMaterial(blur_mat)
        surface.SetDrawColor(color_white:Unpack())

        for i = 1, blur_passes do
            blur_mat:SetFloat("$blur", (i / 3) * (amount or blur_passes))
            blur_mat:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
        end
    end

    local function blurBackground(self, amount)
        blurPanel(self, amount)

        DisableClipping(DisableClipping(true))
    end

    local function FadeIn(panel, time, func)
        func = func or function() end

        panel:AlphaTo(0, time / 2, 0, function()
            panel:Clear()
            panel:AlphaTo(255, time / 2, 0)
            func()
        end)
    end

    local function Notify(text, fontSize, x, y, lifeTime)
        local notify = vgui.Create("DNotify", Panel)
        notify:SetPos(x, y)
        notify:SetLife(lifeTime)
        notify:SetSize(ScrW(), ScrH())
        local panel = vgui.Create("DPanel", notify)

        panel.Paint = function(self) blurPanel(self) end

        local label = RiceLib.VGUI.ModernLabel(text, panel, fontSize, 5, 0, color_white)
        label:SizeToContents()
        panel:SetSize(label:GetWide() + 10, label:GetTall())
        notify:AddItem(panel)

        return notify, label
    end

    local function dock_margin(l, t, r, b)
        local left, up = RL_hudScale(l or 0, t or 0)
        local right, down = RL_hudScale(r or 0, b or 0)

        return left, up, right, down
    end

    local function TextWide(font, text)
        surface.SetFont(font)

        return select(1, surface.GetTextSize(text))
    end

    local function TextHeight(font, text)
        surface.SetFont(font)

        return select(2, surface.GetTextSize(text))
    end

    RiceLib.VGUI.GetRoot        = get_root
    RiceLib.VGUI.Icon           = function(name) return Material("rl_icons/" .. name .. ".png") end
    RiceLib.VGUI.IconRaw        = function(name) return "rl_icons/" .. name .. ".png" end
    RiceLib.VGUI.blurPanel      = blurPanel
    RiceLib.VGUI.blurBackground = blurBackground
    RiceLib.VGUI.FadeIn         = FadeIn
    RiceLib.VGUI.Notify         = Notify
    RiceLib.VGUI.DM             = dock_margin
    RiceLib.VGUI.TextWide       = TextWide
    RiceLib.VGUI.TextHeight     = TextHeight
    RiceLib.VGUI.Theme          = RiceLib.VGUI.Theme or {}
    RiceLib.VGUI.ColorTheme     = RiceLib.VGUI.ColorTheme or {}
    RiceLib.VGUI.GlobalTheme    = RiceLib.VGUI.GlobalTheme or {}
    RiceLib.VGUI.ThemeSet       = RiceLib.VGUI.ThemeSet or "SciFi"

    function RiceLib.VGUI.RegisterTheme(name, theme)
        if not theme.Paint then return end

        RiceLib.VGUI.Theme[name] = theme
    end

    function RiceLib.VGUI.RegisterColorTheme(name, theme)
        RiceLib.VGUI.ColorTheme[name] = theme
    end

    function RiceLib.VGUI.SetGlobalTheme(name)
        if not RiceLib.VGUI.Theme[name] then return end

        RiceLib.VGUI.GlobalTheme = RiceLib.VGUI.Theme[name]
    end

    function RiceLib.VGUI.SetThemeSet(name)
        if not RiceLib.VGUI.Theme[name] then return end

        RiceLib.VGUI.ThemeSet = name
    end

    function RiceLib.VGUI.ThemeSetTextColor(name)
        return RiceLib.VGUI.Theme[RiceLib.VGUI.ThemeSet..(name or "")].TextColor or Color(255,255,255)
    end

    function RiceLib.VGUI.ThemeSetTextFont(name)
        return RiceLib.VGUI.Theme[RiceLib.VGUI.ThemeSet..(name or "")].TextFont or Color(255,255,255)
    end

    local meta = FindMetaTable("Panel")

    function meta:SetTheme(name)
        if not RiceLib.VGUI.Theme[name] then return end

        self.Paint = RiceLib.VGUI.Theme[name].Paint
        self.Theme = table.Copy(RiceLib.VGUI.Theme[name])

        pcall(function(panel) panel:SetTextColor(RiceLib.VGUI.Theme[name].TextColor) end,self)
        pcall(function(panel) panel:SetFont(RiceLib.VGUI.Theme[name].TextFont) end,self)

        pcall(function(panel)
            local bar = panel:GetVBar()

            bar:SetTheme(name)
            bar.btnGrip:SetTheme(name.."ScrollBar")
        end, self)
    end

    function meta:ThemeColorOverride(main, hover, text, outline)
        self.Theme.MainColor = main or self.Theme.MainColor
        self.Theme.HoverColor = hover or self.Theme.HoverColor
        self.Theme.TextColor = text or self.Theme.TextColor
        self.Theme.OutlineColor = outline or self.Theme.OutlineColor

        if text then pcall(function(panel) panel:SetTextColor(text) end, self) end
    end

    function meta:SetColorTheme(name)
        self:ThemeColorOverride(unpack(RiceLib.VGUI.ColorTheme[name]))
    end

    function meta:UseThemeSet(name)
        self:SetTheme(RiceLib.VGUI.ThemeSet..(name or ""))
    end

    function meta:UseGlobalTheme()
        self.Paint = RiceLib.VGUI.GlobalTheme.Paint

        pcall(function(panel) panel:SetTextColor(RiceLib.VGUI.GlobalTheme.TextColor) end,self)
        pcall(function(panel) panel:SetFont(RiceLib.VGUI.GlobalTheme.TextFont) end,self)
    end

    RiceLib.VGUI.SetGlobalTheme("Default")

    concommand.Add("ricelib_vgui_reloadtheme", function()
        reload_themes()
    end)
end

reload_themes()