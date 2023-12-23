local gradient = Material"gui/gradient"
local hudScale = RiceLib.hudScale
local hudScaleY = RiceLib.hudScaleY

local function doOneSide(bDraw, startX, startY, endX, endY, x, y, w, h, ang)
    if not bDraw then return end

    render.SetScissorRect(startX, startY, endX, endY, true)
    surface.DrawTexturedRectRotated(x, y, w, h, ang)
end

local function drawShadowEx(alpha, panel, left, right, top, bottom)
    local x, y = panel:LocalToScreen()
    local w, h = panel:GetSize()
    local sw, sh = hudScale(8, 8)
    DisableClipping(true)
    surface.SetDrawColor(0, 0, 0, alpha)
    surface.SetMaterial(gradient)

    doOneSide(left, x, y, x - w, y + h, -sw / 4, h / 2, sw, h, 180)
    doOneSide(right, x + w, y, x + w + sw, y + h, w + sw / 4, h / 2, sw, h, 0)
    doOneSide(top, x, y, x + w, y - h, w / 2, -sh / 4, sh, w, 90)
    doOneSide(bottom, x, y + h, x + w, y + h + sh, w / 2, h + sh / 4, sh, w, -90)

    render.SetScissorRect(0, 0, 0, 0, false)
    DisableClipping(false)
end

local function drawShadow(themeMeta, panel)
    drawShadowEx(RiceUI.GetShadowAlpha(themeMeta, panel), panel, true, true, true, true)
end


local function drawIndicator(w, h)
    surface.SetDrawColor(0, 255, 0)
    surface.DrawOutlinedRect(0, 0, w, h, hudScaleY(2))
end

local function shadowText(text, font, x, y, color, alignX, alignY, shadowAlpha)
    local offsetX, offsetY = hudScale(2, 2)
    local shadowColor = color_black
    shadowColor.a = shadowAlpha or 50

    color = color or color_white
    alignX = alignX or TEXT_ALIGN_LEFT
    alignY = alignY or TEXT_ALIGN_TOP

    draw.SimpleText(text, font, x + offsetX, y + offsetY, shadowColor, alignX, alignY)
    draw.SimpleText(text, font, x, y, color, alignX, alignY)
end

RiceUI.Render = {
    DrawShadowEx = drawShadowEx,
    DrawShadow = drawShadow,
    DrawIndicator = drawIndicator,
    ShadowText = shadowText
}