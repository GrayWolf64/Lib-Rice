local function main(panel,data)
    if data.Root then
        panel:SetPos(RL.hudScale(data.x,data.y))

        panel:MakePopup()
    end

    if data.Center then panel:Center() end
    if data.Paint then panel.Paint = data.Paint end
    if data.PaintOver then panel.PaintOver = data.PaintOver end
    if data.Think then panel.Think = data.Think end
    if data.Callback then data.callback(panel,data) end
    if data.Alpha then panel:SetAlpha(data.Alpha) end
    if data.Theme then panel.Theme = data.Theme end
    if data.Dock then panel:Dock(data.Dock) end
    if data.Margin then panel:DockMargin(data.Margin[1],data.Margin[2] or 0,data.Margin[3] or 0,data.Margin[4] or 0) end

    if !data.Anim then return end
    for _,AnimData in ipairs(data.Anim) do
        if AnimData.type == "alpha" then
            panel:AlphaTo(AnimData.alpha,AnimData.time,AnimData.delay or 0,AnimData.CallBack or function()end)
        end

        if AnimData.type == "move" then
            panel:MoveTo(AnimData.x or 0,AnimData.y or 0,AnimData.time,AnimData.delay or 0,AnimData.ease or -1,AnimData.CallBack or function()end)
        end
    end
end

return main