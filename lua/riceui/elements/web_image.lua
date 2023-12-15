local Element = {}
Element.Editor = {Category = "display"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "https://i.328888.xyz/2023/05/11/iYF9pU.png"
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RiceLib.hudScale(data.x,data.y))
    panel:SetSize(RiceLib.hudScale(data.w,data.h))
    panel:SetText("")

    function panel:SetImage(url)
        self.Image = url
        self.Mat = RiceUI.GetWebImage(self.Image, function(mat)
            if self == nil then return end

            self.Mat = mat
        end)
    end

    panel.Paint = function(self,w,h)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawRect(0,0,w,h)

        if !panel.Mat then return end
        if panel.Mat:IsError() then return end

        surface.SetMaterial(panel.Mat)
        surface.DrawTexturedRect(0,0,w,h)
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    panel:SetImage(data.Image)

    return panel
end

return Element