local Element = {}
Element.Editor = {Category = "display"}

function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("DPanel",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel.vCamPos = Vector(0, 0, 0)
    panel.vCamAng = Angle(0, 0, 0)
    panel.vCamFOV = 75

    function panel:Paint(w, h)
        self:RenderBackground(w, h)

        cam.Start3D(self.vCamPos, self.vCamAng, self.vCamFOV)
            local x, y = self:LocalToScreen()

            render.SetScissorRect(x, y, x + w, y + h, true)

            self:RenderScene()

            render.SetScissorRect(0, 0, 0, 0, false)
        cam.End3D()
    end

    function panel:RenderBackground()
    end

    function panel:RenderScene()
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element