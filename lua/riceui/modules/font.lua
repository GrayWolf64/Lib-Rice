-- Use height for ratio should be better
local RATIO  = ScrH() / 1080

local function mkFontData(font, size, weight, codeSize)
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

-- Caches all the registerd font, but dont create them
local FontCaches = {}
local FontCreated = {}

-- For cached fonts
local function getFont(fontName)
    local fontData = FontCaches[fontName]

    if FontCreated[fontName] then return fontName end
    if not fontData then return fontName end

    surface.CreateFont(fontName, fontData)

    FontCreated[fontName] = true

    return fontName
end

local function registerFont(data)
    local fontName, fontFileName = data.CodeName, data.FontName or "OPlusSans 3.0"

    -- Start from size 16 like why anyone need font smaller then that
    for i = 8, 100 do
        local size = i * 2 * RATIO
        if data.Fixed then
            size = i * 2
        end

        local base = mkFontData(fontFileName, size, 500)
        local fontData = RiceLib.table.Inherit(base, data)
        local fontNameIndex = fontName .. "_" .. i * 2

        if data.Debug then
            print(size, fontData.size, fontNameIndex)
            print(fontName, fontFileName)
        end

        if data.EnableCaching then
            -- Caches the font until it has been used
            FontCaches[fontNameIndex] = fontData
        else
            surface.CreateFont(fontNameIndex, fontData)
        end
    end
end

concommand.Add("riceui_fontcaches", function()
    PrintTable(FontCaches)
end)

concommand.Add("riceui_fontcaches_simple", function()
    local fonts = table.Copy(table.GetKeys(FontCaches))
    table.sort(fonts)

    PrintTable(fonts)
end)

RiceUI.Font = {
    Get = getFont,
    Register = registerFont
}

RiceLib.VGUI.RegisterFont_New = registerFont