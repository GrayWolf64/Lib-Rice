RiceUI = RiceUI or {}
RiceUI.Render = {}

function RiceUI.Render.DrawShadow(themeMeta, pnl)
    RiceUI.Render.DrawShadowEx(RiceUI.GetShadowAlpha(themeMeta, pnl), pnl, true, true, true, true)
end

local gradient = Material("gui/gradient")

function RiceUI.Render.DrawShadowEx(alpha, pnl, Left, Right, Top, Bottom)
    local x, y = pnl:LocalToScreen()
    local w, h = pnl:GetSize()
    local sw, sh = RL.hudScale(8, 8)
    DisableClipping(true)
    surface.SetDrawColor(0, 0, 0, alpha)
    surface.SetMaterial(gradient)

    if Left then
        render.SetScissorRect(x, y, x - w, y + h, true)
        surface.DrawTexturedRectRotated(-sw / 4, h / 2, sw, h, 180)
    end

    if Right then
        render.SetScissorRect(x + w, y, x + w + sw, y + h, true)
        surface.DrawTexturedRectRotated(w + sw / 4, h / 2, sw, h, 0)
    end

    if Top then
        render.SetScissorRect(x, y, x + w, y - h, true)
        surface.DrawTexturedRectRotated(w / 2, -sh / 4, sh, w, 90)
    end

    if Bottom then
        render.SetScissorRect(x, y + h, x + w, y + h + sh, true)
        surface.DrawTexturedRectRotated(w / 2, h + sh / 4, sh, w, -90)
    end

    render.SetScissorRect(0, 0, 0, 0, false)
    DisableClipping(false)
end

function RiceUI.Render.DrawIndicator(w, h)
    surface.SetDrawColor(0, 255, 0)
    surface.DrawOutlinedRect(0, 0, w, h, RL.hudScaleY(2))
end

function RiceUI.Render.ShadowText(Text, Font, X, Y, color, Align_X, Align_Y, shadowAlpha)
    local offsetx, offsety = RL.hudScale(2, 2)
    color = color or color_white
    Align_X = Align_X or TEXT_ALIGN_LEFT
    Align_Y = Align_Y or TEXT_ALIGN_TOP
    draw.SimpleText(Text, Font, X + offsetx, Y + offsety, Color(0, 0, 0, shadowAlpha or 50), Align_X, Align_Y)
    draw.SimpleText(Text, Font, X, Y, color, Align_X, Align_Y)
end