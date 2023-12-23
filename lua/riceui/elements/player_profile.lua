local Element = {}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        ShadowAlpha = 0,
    })

    local panel = vgui.Create("AvatarImage",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetPlayer(data.ply,data.w)

    --local old_Paint = panel.Paint
    function panel:Paint()
        RiceUI.Render.DrawShadowEx(self.ShadowAlpha,self,true,true,true,true)

        --old_Paint()
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element