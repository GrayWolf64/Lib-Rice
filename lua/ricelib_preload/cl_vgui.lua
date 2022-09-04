//省事函数
function RL.VGUI.GetRoot(vgui)
    local parent = vgui:GetParent()

    if not parent then return vgui end

    if parent:GetClassName() == "CGModBase" then return vgui end

    return RL.VGUI.GetRoot(parent)
end

function RL.VGUI.Icon(name)
    return Material("rl_icons/"..name..".png")
end

function RL.VGUI.IconRaw(name)
    return "rl_icons/"..name..".png"
end

local blur = Material("pp/blurscreen")

function RL.VGUI.blurPanel(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, 6 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

function RL.VGUI.FadeIn(panel,time,func)
    local func = func or function()end

    panel:AlphaTo(0,time/2,0,function()
        panel:Clear()
        panel:AlphaTo(255,time/2,0)

        func()
    end)
end

function RL.VGUI.Notify(Text,FontSize,X,Y,Time)
    local notify = vgui.Create("DNotify", Panel)
    notify:SetPos(X,Y)
    notify:SetLife(Time)
    notify:SetSize(ScrW(),ScrH())

    local panel = vgui.Create("DPanel",notify)
    panel.Paint = function(self)
        RL.VGUI.blurPanel(self,6)
    end
    
    local label = RL.VGUI.ModernLabel(Text,panel,FontSize,5,0,Color(255,255,255,255))
    label:SizeToContents()
    panel:SetSize(label:GetWide()+10,label:GetTall())

    notify:AddItem(panel)

    return notify,label
end