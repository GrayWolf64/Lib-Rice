local animations = {
    FrameClose = function(panel)
        local x, y = panel:GetSize()
        local w, h = panel:GetSize()

        panel:SetMouseInputEnabled(false)
        panel:SetKeyboardInputEnabled(false)
        panel:AlphaTo(0, 0.075, 0)
        panel:MoveBy(RiceLib.hudScaleX(32), RiceLib.hudScaleY(32), 0.4, 0, 0.3)
        panel:SizeTo(w - RiceLib.hudScaleX(64), h - RiceLib.hudScaleY(64), 0.4, 0, 0.3, function(_, pnl)
            pnl:Remove()
        end)
    end,

    FadeOut = function(panel, callback)
        callback = callback or function(_, pnl) pnl:Remove() end

        panel:AlphaTo(0, 0.075, 0, callback)
    end,

    FadeIn = function(panel, callback)
        callback = callback or function(_, pnl) end

        panel:AlphaTo(255, 0.075, 0, callback)
    end,
}

RiceUI.DefineMixin("RiceUI_Animation", function(self, type, callback)
    local animator = animations[type]

    if animator == nil then
        animator = animations.FadeOut
    end

    animator(self, callback)
end)