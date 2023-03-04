local function main(data,parent)
    table.Merge(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("DPanel",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel.Paint = function(self,w,h)
        surface.SetDrawColor(150,0,255)
        surface.DrawRect(0,0,w,h)
    end

    local delay = CurTime()+5
    panel.Think = function()
        if delay < CurTime() then panel:Remove() end
    end

    RiceUI.Process("error",panel,data)

    return panel
end

return main