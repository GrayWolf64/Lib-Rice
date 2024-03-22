local Element = {}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        w = 300,
        h = 300,
        Theme = {ThemeName = "modern", ThemeType = "Panel", Color = "white", TextColor = "white", Shadow = true},

        RemoveOnLoseFocus = true
    })

    local panel = vgui.Create("DPanel")
    panel:SetSize(RiceLib.hudScale(data.w,0))
    panel.ProcessID = "RL_Popup"

    function panel:OnFocusChanged(gained)
        if not IsValid(self.Parent) then self:DoRemove() return end
        if not self.RemoveOnLoseFocus then return end
        if not gained then
            self:DoRemove()
        end
    end

    function panel:DoRemove()
        self:SizeTo(-1, 0, 0.3, 0, 0.3, function()
            self:Remove()
        end)
    end

    function panel:Layout()
        local x,y = self.Parent:LocalToScreen()
        local px,py = x + self.Parent:GetWide() / 2, y + self.Parent:GetTall()

        self:SetPos(px - self:GetWide() / 2, py + RiceLib.hudScaleY(10))
    end

    function panel.RiceUI_Event(self,name,id,data)
        if panel.Parent.RiceUI_Event then
            panel.Parent:RiceUI_Event(name,id,data)
        end
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    panel:MakePopup()
    panel:Layout()
    panel:SizeTo(-1, RiceLib.hudScaleY(data.h), 0.3, 0, 0.3)

    return panel
end

return Element