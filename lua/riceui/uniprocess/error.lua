local function main(panel,data)
    if data.Root then
        panel:SetPos(RL.hudScale(data.x,data.y))

        panel:AlphaTo(0,0,2,function(_,self)self:Remove()end)
    end

    if data.Center then panel:Center() end
    if data.PaintOver then panel.PaintOver = data.paintOver end
    if data.Think then panel.Think = data.think end
end

return main