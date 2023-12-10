local animations = {
    Frame_Close = function(panel)
        local x, y = panel:GetSize()

        panel:SetMouseInputEnabled(false)
        panel:SetKeyboardInputEnabled(false)
        panel:AlphaTo(0, 0.075, 0)
        panel:MoveBy(x / 2, y / 2, 0.4, 0, 0.3)
        panel:SizeTo(0, 0, 0.4, 0, 0.3, function(_, pnl)
            pnl:Remove()
        end)
    end,

    FadeOut = function(panel)
        panel:AlphaTo(0, 0.075, 0, function(_, pnl) pnl:Remove() end)
    end
}

RiceUI.DefineMixin("RiceUI_Animation", function(self, type)
    local animator = animations[type]

    if animator == nil then
        animator = animations.FadeOut
    end

    animator(self)
end)