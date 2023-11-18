RL.VGUI = RL.VGUI or {}

function RL.VGUI.ReloadTheme()
    local themes_folder = "ricelib_vgui_theme/"

    if SERVER then
        local files = file.Find(themes_folder .. "*.lua", "LUA")

        for _, v in ipairs(files) do AddCSLuaFile(themes_folder .. v) end
    else
        local files = file.Find(themes_folder .. "*.lua", "LUA")

        for _, v in ipairs(files) do
            local name, theme = include(themes_folder .. v)
            if not name or not theme then return end

            RL.VGUI.RegisterTheme(name, theme)

            RL.Message("Loaded " .. name, "RiceLib VGUI Theme")
        end
    end
end

if CLIENT then
    RL.VGUI.Theme = RL.VGUI.Theme or {}
    RL.VGUI.ColorTheme = RL.VGUI.ColorTheme or {}
    RL.VGUI.GlobalTheme = RL.VGUI.GlobalTheme or {}
    RL.VGUI.ThemeSet = RL.VGUI.ThemeSet or "SciFi"

    function RL.VGUI.RegisterTheme(name, theme)
        if not theme.Paint then return end

        RL.VGUI.Theme[name] = theme
    end

    function RL.VGUI.RegisterColorTheme(name, theme)
        RL.VGUI.ColorTheme[name] = theme
    end

    function RL.VGUI.SetGlobalTheme(name)
        if not RL.VGUI.Theme[name] then return end

        RL.VGUI.GlobalTheme = RL.VGUI.Theme[name]
    end

    function RL.VGUI.SetThemeSet(name)
        if not RL.VGUI.Theme[name] then return end

        RL.VGUI.ThemeSet = name
    end

    function RL.VGUI.ThemeSetTextColor(name)
        return RL.VGUI.Theme[RL.VGUI.ThemeSet..(name or "")].TextColor or Color(255,255,255)
    end

    function RL.VGUI.ThemeSetTextFont(name)
        return RL.VGUI.Theme[RL.VGUI.ThemeSet..(name or "")].TextFont or Color(255,255,255)
    end

    local meta = FindMetaTable("Panel")

    function meta:SetTheme(name)
        if not RL.VGUI.Theme[name] then return end

        self.Paint = RL.VGUI.Theme[name].Paint
        self.Theme = table.Copy(RL.VGUI.Theme[name])

        pcall(function(panel) panel:SetTextColor(RL.VGUI.Theme[name].TextColor) end,self)
        pcall(function(panel) panel:SetFont(RL.VGUI.Theme[name].TextFont) end,self)

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
        self:ThemeColorOverride(unpack(RL.VGUI.ColorTheme[name]))
    end

    function meta:UseThemeSet(name)
        self:SetTheme(RL.VGUI.ThemeSet..(name or ""))
    end

    function meta:UseGlobalTheme()
        self.Paint = RL.VGUI.GlobalTheme.Paint

        pcall(function(panel) panel:SetTextColor(RL.VGUI.GlobalTheme.TextColor) end,self)
        pcall(function(panel) panel:SetFont(RL.VGUI.GlobalTheme.TextFont) end,self)
    end

    RL.VGUI.SetGlobalTheme("Default")

    concommand.Add("ricelib_vgui_reloadtheme", function()
        RL.VGUI.ReloadTheme()
    end)
end

RL.VGUI.ReloadTheme()