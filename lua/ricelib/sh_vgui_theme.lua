RL.VGUI = RL.VGUI or {}
RL.VGUI.Theme = {}
RL.VGUI.GlobalTheme = {}
RL.VGUI.ThemeSet = "SciFi"

function RL.VGUI.ReloadTheme()
    if SERVER then
        local files,_ = file.Find("ricelib_vgui_theme/*.lua", "LUA")
        
        for _, v in ipairs(files) do AddCSLuaFile("ricelib_vgui_theme/"..v) end
    else
        local files,_ = file.Find("ricelib_vgui_theme/*.lua", "LUA")
    
        for _, v in ipairs(files) do
            local Name,Theme = include("ricelib_vgui_theme/" .. v)
            if !Name or !Theme then return end

            print("[RiceLib VGUI Theme] Loaded [" .. Name .. "]")
            
            RL.VGUI.RegisterTheme(Name,Theme)
        end
    end
end

if SERVER then
    
else
    function RL.VGUI.RegisterTheme(Name,Theme)
        if !Theme.Paint then return end

        RL.VGUI.Theme[Name] = Theme
    end

    function RL.VGUI.SetGlobalTheme(Name)
        if !RL.VGUI.Theme[Name] then return end

        RL.VGUI.GlobalTheme = RL.VGUI.Theme[Name]
    end

    function RL.VGUI.SetThemeSet(Name)
        if !RL.VGUI.Theme[Name] then return end

        RL.VGUI.ThemeSet = Name
    end

    function RL.VGUI.ThemeSetTextColor(Name)
        return RL.VGUI.Theme[RL.VGUI.ThemeSet..(Name or "")].TextColor or Color(255,255,255)
    end

    function RL.VGUI.ThemeSetTextFont(Name)
        return RL.VGUI.Theme[RL.VGUI.ThemeSet..(Name or "")].TextFont or Color(255,255,255)
    end

    local meta = FindMetaTable("Panel")
    
    function meta:SetTheme(Name)
        if !RL.VGUI.Theme[Name] then return end

        self.Paint = RL.VGUI.Theme[Name].Paint

        pcall(function(panel) panel:SetTextColor(RL.VGUI.Theme[Name].TextColor) end,self)
        pcall(function(panel) panel:SetFont(RL.VGUI.Theme[Name].TextFont) end,self)
    end

    function meta:UseThemeSet(Name)
        self:SetTheme(RL.VGUI.ThemeSet..(Name or ""))
    end

    function meta:UseGlobalTheme()
        self.Paint = RL.VGUI.GlobalTheme.Paint

        pcall(function(panel) panel:SetTextColor(RL.VGUI.GlobalTheme.TextColor) end,self)
        pcall(function(panel) panel:SetFont(RL.VGUI.GlobalTheme.TextFont) end,self)
    end

    RL.VGUI.SetGlobalTheme("Default")
end

RL.VGUI.ReloadTheme()