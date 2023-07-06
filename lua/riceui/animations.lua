RiceUI = RiceUI or {}
RiceUI.Animation = {}

function RiceUI.Animation.ExpandFromPos(pnl, data)
    RL.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    pnl:SetAlpha(255)
    pnl:SetSize(0, 0)
    pnl:SetPos(data.StartX, data.StartY)
    pnl:SizeTo(RL.hudScaleX(data.SizeW), RL.hudScaleY(data.SizeH), data.time, data.delay, data.ease, data.callback)
    pnl:MoveTo(data.EndX, data.EndY, data.time, data.delay, data.ease)
    pnl.AnimData = data
end

function RiceUI.Animation.ExpandFromCursor(pnl, data)
    RL.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    pnl:SetAlpha(255)
    local x, y = gui.MousePos()

    if IsValid(data.Parent) then
        local ox, oy = data.Parent:GetPos()
        x = x + ox
        y = y + oy
    end

    pnl:SetSize(0, 0)
    pnl:SetPos(x, y)
    pnl:SizeTo(RL.hudScaleX(data.SizeW), RL.hudScaleY(data.SizeH), data.time, data.delay, data.ease, data.callback)
    pnl:MoveTo(data.EndX, data.EndY, data.time, data.delay, data.ease)

    pnl.AnimData = data
    pnl.AnimData.StartX = x
    pnl.AnimData.StartY = y
end

function RiceUI.Animation.ShrinkToPos(pnl, data)
    RL.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    pnl:SizeTo(0, 0, data.time, data.delay, data.ease, data.callback)
    pnl:MoveTo(data.PosX, data.PosY, data.time, data.delay, data.ease)
end

function RiceUI.Animation.Shrink(pnl, data)
    RL.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    pnl:SizeTo(0, 0, data.time, data.delay, data.ease, data.callback)
    pnl:MoveTo(pnl.AnimData.StartX, pnl.AnimData.StartY, data.time, data.delay, data.ease)
end

function RiceUI.Animation.FadeIn(Pnl,dur,delay,ease)
    delay = delay or 0
    ease = ease or 0.3

    Pnl:SetVisible(true)
    local Anim = Pnl:NewAnimation(dur,delay,ease)

    Anim.Think = function(_, pnl, fraction)
        pnl:SetAlpha(255 * fraction)
    end
end

function RiceUI.Animation.FadeOut(Pnl,dur,delay,ease)
    delay = delay or 0
    ease = ease or 0.3

    local Anim = Pnl:NewAnimation(dur,delay,ease,function(_, pnl)
        pnl:SetVisible(false)
    end)

    Anim.Think = function(_, pnl, fraction)
        pnl:SetAlpha(255 - 255 * fraction)
    end
end

function RiceUI.Animation.FadeInOut(Pnl,data)
    local dur, delay, ease, func = data.dur, data.delay, data.ease, data.func

    delay = delay or 0
    ease = ease or 0.3

    local Anim = Pnl:NewAnimation(dur / 2,delay,ease,function(_, pnl)
        RiceUI.Animation.FadeIn(Pnl, dur / 2, delay, ease)

        func(pnl)
    end)

    Anim.Think = function(_, pnl, fraction)
        pnl:SetAlpha(255 - 255 * fraction)
    end
end