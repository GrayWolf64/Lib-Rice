local WEIGHT  = 500
local ratioW  = ScrW() / 1920
local testStr = "Innovation in China 中国智造，慧及全球 0123456789"

--- Makes font data to be used with `RegisterFont` function family
-- @local
-- @param font Font name
-- @param size Font size
-- @param weight Font weight
-- @return table Font data
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

--- Prototype for `RegisterFont` function family
-- @local
-- @param fontName Name of the font to register
-- @param codeName Code name of the font
-- @param dataEx Font data to override
-- @param ratio A magic number, can be `ScrW() / 1920`
-- @param sizeMul A magic number
-- @param maxIter Create the font for `n` times
local function pRegisterFont(fontName, codeName, dataEx, ratio, sizeMul, maxIter)
    for i = 1, maxIter do
        local data = mkFontData(fontName, i * sizeMul * ratio, WEIGHT)
        table.Merge(data, dataEx or {})

        surface.CreateFont(codeName .. "_".. i * sizeMul, data)
    end
end

function RL.VGUI.RegisterFont(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, ratioW, 10, 10)
end

function RL.VGUI.RegisterFontFixed(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, 1, 10, 10)
end

function RL.VGUI.RegisterFontAdv(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, ratioW, 5, 60)
end

function RL.VGUI.RegisterFontFixedAdv(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, 1, 5, 60)
end

function RL.VGUI.RegisterFont_New(data)
    local codeName, fontName = data.CodeName, data.FontName or "OPlusSans 3.0"

    for i = 1, 100 do
        local base = mkFontData(fontName, i * 2 * ratioW, WEIGHT)
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