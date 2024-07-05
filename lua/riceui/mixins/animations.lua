local animations = {
    FrameClose = function(panel)
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

local DEFAULT_EASEFUNCTION = math.ease.OutExpo

local function moveTo(self, args)
    RiceLib.table.Inherit(args, {
        Time = RiceUI.Animation.GetTime("Normal"),
        Delay = 0,
        EaseFunction = DEFAULT_EASEFUNCTION,
    })

    local x, y = args.X, args.Y

    x = x or self:GetX()
    y = y or self:GetY()

    local anim = self:NewAnimation(args.Time, args.Delay, 1, args.Callback)
    anim.StartPos = Vector(self:GetX(), self:GetY(), 0)
    anim.Think = function(animData, panel, fraction)
        local easedFraction = args.EaseFunction(fraction)
        local pos = LerpVector(easedFraction, animData.StartPos, Vector(x, y, 0))

        panel:SetPos(pos.x, pos.y)
        if panel:GetDock() > 0 then panel:InvalidateParent() end
    end
end

local function sizeTo(self, args)
    RiceLib.table.Inherit(args, {
        Time = RiceUI.Animation.GetTime("Normal"),
        Delay = 0,
        EaseFunction = DEFAULT_EASEFUNCTION,
    })

    local w, h = args.W or -1, args.H or - 1

    local anim = self:NewAnimation(args.Time, args.Delay, 1, args.Callback)
    --anim.StartSize = Vector(self:GetWide(), self:GetTall(), 0)
    anim.Think = function(animData, panel, fraction)
        if not anim.StartSize then
            local startW, startH = panel:GetSize()

            if w < 0 then w = self:GetWide() end
            if h < 0 then h = self:GetTall() end

            anim.StartSize = Vector( startW, startH, 0 )
        end

        local easedFraction = args.EaseFunction(fraction)
        local size = LerpVector(easedFraction, animData.StartSize, Vector(w, h, 0))

        panel:SetSize(size.x, size.y)
        if panel:GetDock() > 0 then panel:InvalidateParent() end
    end
end

RiceUI.DefineMixin("RiceUI_MoveTo", moveTo)
RiceUI.DefineMixin("RiceUI_SizeTo", sizeTo)