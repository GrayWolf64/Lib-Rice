local test_str = "Innovation in China 中国智造，慧及全球 0123456789"

concommand.Add("ricelib_font_viewer", function(_, _, args)
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(1800, 900))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib Font Viewer " .. args[1])
    frame:SetTheme("ModernDark")

    local panel, bar, barGrip = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("ModernDark")

    RL.VGUI.RegisterFontAdv(args[1], "FontView" .. args[1])

    for i = 1, 20 do
        local button = vgui.Create("DLabel", panel)
        button:Dock(TOP)
        button:DockMargin(0, RL.hudScaleY(5), 0, 0)
        button:SetText(" " .. tostring(i * 5) .. " " .. test_str)
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i * 5 + 10))
        button:SetFont("FontView" .. args[1] .. "_" .. i * 5)

        panel:AddItem(button)
    end
end)

concommand.Add("ricelib_font_viewer_raw",function(_, _, args)
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(1800, 900))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib Font Viewer " .. args[1])
    frame:SetTheme("ModernDark")

    local panel, bar, barGrip = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("ModernDark")

    for i = 1, 20 do
        local button = vgui.Create("DLabel", panel)
        button:Dock(TOP)
        button:DockMargin(0, RL.hudScaleY(5), 0, 0)
        button:SetText(" " .. tostring(i * 5) .. " " .. test_str)
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i * 5 + 10))
        button:SetFont(args[1] .. "_" .. i * 5)

        panel:AddItem(button)
    end
end)

concommand.Add("ricelib_font_viewer_new",function(_, _, args)
    local frame = RiceUI.SimpleCreate({type = "rl_frame",
        Center = true,
        Root = true,

        w = 1800,
        h = 900,
    })

    for i = 1, 20 do
        local button = vgui.Create("DLabel", panel)
        button:Dock(TOP)
        button:DockMargin(0, RL.hudScaleY(5), 0, 0)
        button:SetText(" " .. tostring(i * 5) .. " " .. test_str)
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i * 5 + 10))
        button:SetFont(args[1] .. "_" .. i * 5)

        panel:AddItem(button)
    end
end)

concommand.Add("ricelib_vgui_theme_viewer", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(500, 500))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib VGUI Theme Viewer")
    frame:SetTheme("ModernDark")

    local panel = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("ModernDark")

    for k in SortedPairs(RL.VGUI.Theme) do
        local button = vgui.Create("DButton", panel)
        button:Dock(TOP)
        button:DockMargin(0, RL.hudScaleY(5), 0, 0)
        button:SetText(k)
        button:SetTheme(k)
        button:SetTall(RL.hudScaleY(50))

        panel:AddItem(button)
    end
end)

concommand.Add("ricelib_vgui_colortheme_viewer", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(500, 500))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib VGUI ColorTheme Viewer")
    frame:SetTheme("Modern")
    frame:SetColorTheme("Dark1")

    local panel = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("Modern")
    panel:SetColorTheme("Dark1")

    for k in SortedPairs(RL.VGUI.ColorTheme) do
        local button = vgui.Create("DButton", panel)
        button:Dock(TOP)
        button:DockMargin(0, RL.hudScaleY(5), 0, 0)
        button:SetText(k)
        button:SetTheme("Modern")
        button:SetTall(RL.hudScaleY(50))
        button:SetColorTheme(k)

        panel:AddItem(button)
    end
end)