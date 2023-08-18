RL.VGUI = RL.VGUI or {}
RL.VGUI.Theme = {}
RL.VGUI.ColorTheme = RL.VGUI.ColorTheme or {}
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

            RL.Message("Loaded " .. Name,"RiceLib VGUI Theme")

            RL.VGUI.RegisterTheme(Name,Theme)
        end
    end
end

if CLIENT then
    function RL.VGUI.RegisterTheme(Name,Theme)
        if !Theme.Paint then return end

        RL.VGUI.Theme[Name] = Theme
    end

    function RL.VGUI.RegisterColorTheme(Name,Theme)
        RL.VGUI.ColorTheme[Name] = Theme
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
        self.Theme = table.Copy(RL.VGUI.Theme[Name])

        pcall(function(panel) panel:SetTextColor(RL.VGUI.Theme[Name].TextColor) end,self)
        pcall(function(panel) panel:SetFont(RL.VGUI.Theme[Name].TextFont) end,self)

        pcall(function(panel)
            local bar = panel:GetVBar()

            bar:SetTheme(Name)
            bar.btnGrip:SetTheme(Name.."ScrollBar")
        end,self)
    end

    function meta:ThemeColorOverride(Main,Hover,Text,Outline)
        self.Theme.MainColor = Main or self.Theme.MainColor
        self.Theme.HoverColor = Hover or self.Theme.HoverColor
        self.Theme.TextColor = Text or self.Theme.TextColor
        self.Theme.OutlineColor = Outline or self.Theme.OutlineColor

        if Text then pcall(function(panel) panel:SetTextColor(Text) end,self) end
    end

    function meta:SetColorTheme(Name)
        self:ThemeColorOverride(unpack(RL.VGUI.ColorTheme[Name]))
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

    concommand.Add("RiceLib_VGUI_ReloadTheme",function()
        RL.VGUI.ReloadTheme()
    end)

    concommand.Add("RiceLib_VGUI_ThemeView",function()
        local frame = vgui.Create("DFrame")
        frame:SetSize(RL.hudScale(500,500))
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("RiceLib VGUI Theme Viewer")
        frame:SetTheme("ModernDark")

        local panel = RL.VGUI.ScrollPanel(frame)
        panel:Dock(FILL)
        panel:SetTheme("ModernDark")

        for k,v in SortedPairs(RL.VGUI.Theme) do
            local button = vgui.Create("DButton",panel)
            button:Dock(TOP)
            button:DockMargin(0,RL.hudScaleY(5),0,0)
            button:SetText(k)
            button:SetTheme(k)
            button:SetTall(RL.hudScaleY(50))

            panel:AddItem(button)
        end
    end)

    concommand.Add("RiceLib_VGUI_ColorThemeView",function()
        local frame = vgui.Create("DFrame")
        frame:SetSize(RL.hudScale(500,500))
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("RiceLib VGUI ColorTheme Viewer")
        frame:SetTheme("Modern")
        frame:SetColorTheme("Dark1")

        local panel = RL.VGUI.ScrollPanel(frame)
        panel:Dock(FILL)
        panel:SetTheme("Modern")
        panel:SetColorTheme("Dark1")

        for k,v in SortedPairs(RL.VGUI.ColorTheme) do
            local button = vgui.Create("DButton",panel)
            button:Dock(TOP)
            button:DockMargin(0,RL.hudScaleY(5),0,0)
            button:SetText(k)
            button:SetTheme("Modern")
            button:SetTall(RL.hudScaleY(50))
            button:SetColorTheme(k)

            panel:AddItem(button)
        end
    end)
end

RL.VGUI.ReloadTheme()