RiceUI = RiceUI or {}
RiceUI.Render = {}

local gradient = Material("gui/gradient")
function RiceUI.Render.DrawShadow(themeMeta,pnl)
    local w,h = pnl:GetSize()
    local sw,sh = RL.hudScale(8,8)

    DisableClipping(true)
        surface.SetDrawColor(0,0,0,RiceUI.GetShadowAlpha(themeMeta, pnl))
        surface.SetMaterial(gradient)

        surface.DrawTexturedRectRotated(-sw / 4,h / 2,sw,h,180)
        surface.DrawTexturedRectRotated(w + sw / 4,h / 2,sw,h,0)

        surface.DrawTexturedRectRotated(w / 2,-sh / 4,sh,w,90)
        surface.DrawTexturedRectRotated(w / 2,h + sh / 4,sh,w,-90)
    DisableClipping(false)
end

function RiceUI.Render.DrawShadowEx(alpha,pnl,Left,Right,Top,Bottom)
    local w,h = pnl:GetSize()
    local sw,sh = RL.hudScale(8,8)

    DisableClipping(true)
        surface.SetDrawColor(0,0,0,alpha)
        surface.SetMaterial(gradient)

        if Left then surface.DrawTexturedRectRotated(-sw / 4,h / 2,sw,h,180) end
        if Right then surface.DrawTexturedRectRotated(w + sw / 4,h / 2,sw,h,0) end

        if Top then surface.DrawTexturedRectRotated(w / 2,-sh / 4,sh,w,90) end
        if Bottom then surface.DrawTexturedRectRotated(w / 2,h + sh / 4,sh,w,-90) end
    DisableClipping(false)
end