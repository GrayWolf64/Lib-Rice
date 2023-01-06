local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "vgui/cursors/hand"
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(data.x,data.y)
    panel:SetSize(data.w,data.h)
    panel:SetText("")

    if file.Exists("riceui/web_image"..util.SHA256(data.Image),"DATA") then
        panel.Mat = Material("riceui/web_image"..util.SHA256(data.Image))
    else
        http.Fetch(panel.Image,function(body)
            file.Write("riceui/web_image"..util.SHA256(data.Image),body)

            panel.Mat = Material("riceui/web_image"..util.SHA256(data.Image))
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

    RiceUI.Process("panel",panel,data)
    RiceUI.Process("button",panel,data)

    return panel
end

return main