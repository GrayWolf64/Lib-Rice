RiceUI = RiceUI or {}
RiceUI.Animation = {}

function RiceUI.Animation.ExpandFromPos(pnl,data)
    RL.table.Inherit(data,{time=0.35, delay=0, ease=0.3, callback=function()end})

    pnl:SetAlpha(255)

    pnl:SetSize(0,0)
    pnl:SetPos(data.StartX,data.StartY)
    pnl:SizeTo(RL.hudScaleX(data.SizeW), RL.hudScaleY(data.SizeH), data.time, data.delay, data.ease, data.callback)
    pnl:MoveTo(data.EndX, data.EndY, data.time, data.delay, data.ease)

    pnl.AnimData = data
end

function RiceUI.Animation.ShrinkToPos(pnl,data)
    RL.table.Inherit(data,{time=0.35, delay=0, ease=0.3, callback=function()end})

    pnl:SizeTo(0, 0, data.time, data.delay, data.ease, data.callback)
    pnl:MoveTo(data.PosX, data.PosY, data.time, data.delay, data.ease)
end

function RiceUI.Animation.Shrink(pnl,data)
    RL.table.Inherit(data,{time=0.35, delay=0, ease=0.3, callback=function()end})

    pnl:SizeTo(0, 0, data.time, data.delay, data.ease, data.callback)
    pnl:MoveTo(pnl.AnimData.StartX, pnl.AnimData.StartY, data.time, data.delay, data.ease)
end