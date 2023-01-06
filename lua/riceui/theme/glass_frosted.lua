local tbl = {}

function tbl.Panel(pnl,w,h)
    surface.SetDrawColor(255,255,255,50)
    surface.DrawOutlinedRect(0,0,w,h,RL.hudScaleX(5))
    
    RL.VGUI.blurPanel(pnl,pnl.Theme.BlurSize or 5)
end

function tbl.Raw(pnl,w,h)
    RL.VGUI.blurPanel(pnl,pnl.Theme.BlurSize or 5)
end

function tbl.Button(pnl,w,h)
    surface.SetDrawColor(255,255,255,50)
    surface.DrawOutlinedRect(0,0,w,h,RL.hudScaleX(2))
    
    RL.VGUI.blurPanel(pnl,pnl.Theme.BlurSize or 5)
end

return tbl