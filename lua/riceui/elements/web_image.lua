local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "https://i.328888.xyz/2023/01/29/jM97x.jpeg"
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetText("")
    panel.Image = data.Image

    if file.Exists("riceui/web_image/"..util.SHA256(data.Image)..".png","DATA") then
        panel.Mat = Material("data/riceui/web_image/"..util.SHA256(data.Image)..".png")
    else
        http.Fetch(panel.Image,function(body)
            file.Write("riceui/web_image/"..util.SHA256(data.Image)..".png",body)

            panel.Mat = Material("data/riceui/web_image/"..util.SHA256(data.Image)..".png")
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