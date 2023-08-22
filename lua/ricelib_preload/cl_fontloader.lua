local ratioW  = ScrW() / 1920
local testStr = "Innovation in China 中国智造，慧及全球 0123456789"

local function mkFontData(font, size, weight)
    return {
        font = font,
        size = size,
        weight = weight,
        antialias = true,
        additive = false,
        outline = false,
        extended = true
    }
end

function RL.VGUI.RegisterFont(fontName, codeName, dataEx)
    for i = 1, 10 do
        local data = mkFontData(fontName, i * 10 * ratioW, 500)
        table.Merge(data, (dataEx or {}))

        surface.CreateFont(codeName .. "_".. i * 10, data)
    end
end

function RL.VGUI.RegisterFontFixed(fontName, codeName, dataEx)
    for i = 1, 10 do
        local data = mkFontData(fontName, i * 10, 500)
        table.Merge(data, (dataEx or {}))

        surface.CreateFont(codeName .. "_" .. i * 10, data)
    end
end

function RL.VGUI.RegisterFontAdv(fontName, codeName, dataEx)
    for i = 1, 60 do
        local data = mkFontData(fontName, i * 5 * ratioW, 500)
        table.Merge(data, (dataEx or {}))

        surface.CreateFont(codeName .. "_" .. i * 5, data)
    end
end

function RL.VGUI.RegisterFontFixedAdv(fontName, codeName, dataEx)
    for i = 1, 60 do
        local data = mkFontData(fontName, i * 5, 500)
        table.Merge(data, (dataEx or {}))

        surface.CreateFont(codeName .. "_" .. i * 5, data)
    end
end

function RL.VGUI.RegisterFont_New(data)
    local codeName, fontName = data.CodeName, data.FontName or "OPlusSans 3.0"

    for i = 1, 100 do
        local base = mkFontData(fontName, i * 2 * ratioW, 500)
        local FontData = RL.table.Inherit(base, data)

        if data.Debug then print(i * 2 * ratioW, FontData.size) end

        surface.CreateFont(codeName .. "_" .. i * 2, FontData)
    end
end

concommand.Add("RiceLib_VGUI_FontView",function(_, _, args)
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(1800, 900))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib VGUI Font Viewer " .. args[1])
    frame:SetTheme("ModernDark")

    local panel, bar, barGrip = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("ModernDark")

    RL.VGUI.RegisterFontAdv(args[1], "FontView" .. args[1])

    for i = 1, 20 do
        local button = vgui.Create("DLabel", panel)
        button:Dock(TOP)
        button:DockMargin(0, RL.hudScaleY(5), 0, 0)
        button:SetText(" " .. tostring(i * 5) .. " " .. testStr)
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i * 5 + 10))
        button:SetFont("FontView" .. args[1] .. "_" .. i * 5)

        panel:AddItem(button)
    end
end)

concommand.Add("RiceLib_VGUI_FontView_Raw",function(_, _, args)
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(1800, 900))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib VGUI Font Viewer " .. args[1])
    frame:SetTheme("ModernDark")

    local panel, bar, barGrip = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("ModernDark")

    for i = 1, 20 do
        local button = vgui.Create("DLabel", panel)
        button:Dock(TOP)
        button:DockMargin(0, RL.hudScaleY(5), 0, 0)
        button:SetText(" " .. tostring(i * 5) .. " " .. testStr)
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i * 5 + 10))
        button:SetFont(args[1] .. "_" .. i * 5)

        panel:AddItem(button)
    end
end)

concommand.Add("RiceLib_VGUI_FontView_New",function(_, _, args)
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
        button:SetText(" " .. tostring(i * 5) .. " " .. testStr)
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i * 5 + 10))
        button:SetFont(args[1] .. "_" .. i * 5)

        panel:AddItem(button)
    end
end)