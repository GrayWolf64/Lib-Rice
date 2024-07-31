local ANIMATION_RATE = 1
local Speeds = {
    Normal = 0.3,
    Fast = 0.2,
    Instant = 0.1
}

local function setRate(rate)
    ANIMATION_RATE = rate
end

local function getTime(time)
    return Speeds[time] * ANIMATION_RATE
end

local function expandFromPos(panel, data)
    if not IsValid(panel) then return end

    RiceLib.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    panel:SetAlpha(255)
    panel:SetSize(0, 0)
    panel:SetPos(data.StartX, data.StartY)
    panel:SizeTo(RiceLib.hudScaleX(data.SizeW), RiceLib.hudScaleY(data.SizeH), data.time, data.delay, data.ease, data.callback)
    panel:MoveTo(data.EndX, data.EndY, data.time, data.delay, data.ease)
    panel.AnimData = data
end

local function expandFromCursor(panel, data)
    if not IsValid(panel) then return end

    RiceLib.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    panel:SetAlpha(255)
    local x, y = gui.MousePos()

    if IsValid(data.Parent) then
        local ox, oy = data.Parent:GetPos()
        x = x + ox
        y = y + oy
    end

    panel:SetSize(0, 0)
    panel:SetPos(x, y)
    panel:SizeTo(RiceLib.hudScaleX(data.SizeW), RiceLib.hudScaleY(data.SizeH), data.time, data.delay, data.ease, data.callback)
    panel:MoveTo(data.EndX, data.EndY, data.time, data.delay, data.ease)
    panel.AnimData = data
    panel.AnimData.StartX = x
    panel.AnimData.StartY = y
end

local function shrinkToPos(panel, data)
    if not IsValid(panel) then return end

    RiceLib.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    panel:SizeTo(0, 0, data.time, data.delay, data.ease, data.callback)
    panel:MoveTo(data.PosX, data.PosY, data.time, data.delay, data.ease)
end

local function shrink(panel, data)
    if not IsValid(panel) then return end

    RiceLib.table.Inherit(data, {
        time = 0.35,
        delay = 0,
        ease = 0.3,
        callback = function() end
    })

    panel:SizeTo(0, 0, data.time, data.delay, data.ease, data.callback)
    panel:MoveTo(panel.AnimData.StartX, panel.AnimData.StartY, data.time, data.delay, data.ease)
end

local function fadeIn(panel, dur, delay, ease)
    if not IsValid(panel) then return end

    delay = delay or 0
    ease = ease or 0.3
    panel:SetVisible(true)
    local Anim = panel:NewAnimation(dur, delay, ease)

    Anim.Think = function(_, panel, fraction)
        panel:SetAlpha(255 * fraction)
    end
end

local function fadeOut(panel, dur, delay, ease)
    if not IsValid(panel) then return end

    delay = delay or 0
    ease = ease or 0.3

    local Anim = panel:NewAnimation(dur, delay, ease, function(_, panel)
        panel:SetVisible(false)
    end)

    Anim.Think = function(_, panel, fraction)
        panel:SetAlpha(255 - 255 * fraction)
    end
end

local function fadeInOut(panel, data)
    if not IsValid(panel) then return end

    local dur, delay, ease, func = data.dur, data.delay, data.ease, data.func
    delay = delay or 0
    ease = ease or 0.3

    local Anim = panel:NewAnimation(dur / 2, delay, ease, function(_, panel)
        fadeIn(panel, dur / 2, delay, ease)
        func(panel)
    end)

    Anim.Think = function(_, panel, fraction)
        panel:SetAlpha(255 - 255 * fraction)
    end
end

RiceUI.Animation = {
    ExpandFromPos = expandFromPos,
    ExpandFromCursor = expandFromCursor,
    ShrinkToPos = shrinkToPos,
    Shrink = shrink,
    FadeIn = fadeIn,
    FadeOut = fadeOut,
    FadeInOut = fadeInOut,

    SetRate = setRate,
    GetTime = getTime
}