local Element = {}
function Element.Create(data,parent)
    RL.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        DefaultX = 100,
        DefaultY = 100,
        RootName = "",
        EnableOnChat = true,
        Outline = true,
        NoGTheme = true,
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetText("")
    panel:SetCursor("sizeall")
    panel:SetMouseInputEnabled(true)

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    function panel:Paint(w,h)
        if not panel.Outline then return end

        local onChat = (panel.EnableOnChat and LocalPlayer():IsTyping())
        if not (onChat or (RiceUI.RootName == panel.RootName)) then return end

        if self.Dragging then return end

        surface.SetDrawColor(0,255,0,255)
        surface.DrawOutlinedRect(0,0,w,h,2)

        if self.Hint == nil then return end
        if not self:IsHovered() then return end

        draw.SimpleText(self.Hint,"OPSans_30",w / 2,h / 2,Color(0,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    function panel:Think()
        local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
        local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

        if self.Dragging then
            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]

            parent:SetPos( x, y )
        end
    end

    function panel:OnMousePressed(code)
        local onChat = (panel.EnableOnChat and LocalPlayer():IsTyping())
        if not (onChat or (RiceUI.RootName == panel.RootName)) then return end

        if code == MOUSE_RIGHT then
            parent:SetPos(RL.hudScale(self.DefaultX,self.DefaultY))

            RL.Clear_HUDOffset(self.Profile,self.DefaultX,self.DefaultY)

            return
        end

        local screenX, screenY = parent:GetPos()

        self.Dragging = { gui.MouseX() - screenX, gui.MouseY() - screenY }
        self:MouseCapture( true )
    end

    function panel:OnMouseReleased()
        if self.Profile == nil then return end

        self.Dragging = nil
        self:MouseCapture( false )

        RL.Change_HUDOffset(self.Profile,parent:GetX(),parent:GetY())
    end

    return panel
end

return Element