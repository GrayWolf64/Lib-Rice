local weight  = 500
local ratio_w  = ScrW() / 1920

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
        local data = mkFontData(fontName, i * sizeMul * ratio, weight)
        table.Merge(data, dataEx or {})

        surface.CreateFont(codeName .. "_" .. i * sizeMul, data)
    end
end

--- Register 10 fonts with different sizes
-- @param fontName Name of the font to register
-- @param codeName Code name of the font
-- @param dataEx Font data to override
function RiceLib.VGUI.RegisterFont(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, ratio_w, 10, 10)
end

--- Register 10 fonts with different sizes, but don't vary from monitor to monitor
-- @see RiceLib.VGUI.RegisterFont
function RiceLib.VGUI.RegisterFontFixed(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, 1, 10, 10)
end

--- Register 60 fonts with different sizes
-- @param fontName Name of the font to register
-- @param codeName Code name of the font
-- @param dataEx Font data to override
function RiceLib.VGUI.RegisterFontAdv(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, ratio_w, 5, 60)
end

--- Register 60 fonts with different sizes, but don't vary from monitor to monitor
-- @see RiceLib.VGUI.RegisterFontAdv
function RiceLib.VGUI.RegisterFontFixedAdv(fontName, codeName, dataEx)
    pRegisterFont(fontName, codeName, dataEx, 1, 5, 60)
end

-- !!! RiceLib.VGUI.RegisterFont_New has moved to RiceUI font module !!!