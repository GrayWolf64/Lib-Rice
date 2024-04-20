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

--[[
    https://gitlab.com/sleeppyy/xenin-framework/-/blob/master/laux/xeninui/libs/shadows.laux?ref_type=heads

	Created by Patrick Ratzow (sleeppyy).

	Credits goes to Metamist for his previously closed source library Wyvern,
		CupCakeR for various improvements, the animated texture VGUI panel, and misc.
]]
local scrW, scrH = ScrW(), ScrH()
local resStr = scrW .. "" .. scrH

local renderTarget = GetRenderTarget("bshadows_original_" .. resStr, scrW, scrH)
local shadowMaterial = CreateMaterial("bshadows", "UnlitGeneric", {
    ["$translucent"] = 1,
    ["$vertexalpha"] = 1,
    ["alpha"] = 1,
    ["$color"] = "0 0 0",
    ["$color2"] = "0 0 0"
})

startShadow = function()
    render.PushRenderTarget(renderTarget)
    render.OverrideAlphaWriteEnable(true, true)
    render.Clear(0, 0, 0, 0)
    render.OverrideAlphaWriteEnable(false, false)

    cam.Start2D()
end

endShadow = function(intensity, spread, blur, opacity, direction, distance, scissor)
    opacity = opacity or 255
    direction = direction or 0
    distance = distance or 0
    _shadowOnly = _shadowOnly or false

    if blur > 0 then
        render.OverrideAlphaWriteEnable(true, true)
        render.BlurRenderTarget(renderTarget, spread, spread, blur)
        render.OverrideAlphaWriteEnable(false, false)
    end

    render.PopRenderTarget()

    shadowMaterial:SetFloat("$alpha", opacity / 255)
    shadowMaterial:SetTexture("$basetexture", renderTarget)
    render.SetMaterial(shadowMaterial)

    local xOffset = math.sin(math.rad(direction)) * distance
    local yOffset = math.cos(math.rad(direction)) * distance
    for i = 1, math.ceil(intensity) do
        if istable(scissor) then
            local startX, startY, sizeW, sizeH = unpack(scissor)

            render.SetScissorRect(startX, startY, startX + sizeW, startY + sizeH, true)
        end

        render.DrawScreenQuadEx(xOffset, yOffset, scrW, scrH)
        render.SetScissorRect(0, 0, 0, 0, false)
    end

    cam.End2D()
end

RiceUI.Render = {
    DrawShadowEx = drawShadowEx,
    DrawShadow = drawShadow,
    DrawIndicator = drawIndicator,
    ShadowText = shadowText,

    StartShadow = startShadow,
    EndShadow = endShadow
}