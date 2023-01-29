local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        DefaultX = 100,
        DefaultX = 100,
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetText("")
    panel:SetCursor("sizeall")
    panel:SetMouseInputEnabled(true)
    panel.Profile = data.Profile
    panel.DefaultX = data.DefaultX
    panel.DefaultY = data.DefaultY

    function panel:Paint(w,h)
        if not RICELIB_PLAYERCHAT then return end

        if self.Dragging then return end

        surface.SetDrawColor(0,255,0,255)
        surface.DrawOutlinedRect(0,0,w,h,2)
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
        if code == MOUSE_RIGHT then
            parent:SetPos(RL.hudScale(self.DefaultX,self.DefaultY))

            RL.Clear_HUDOffset(self.Profile,0,0)

            return
        end

        local screenX, screenY = parent:GetPos()

        self.Dragging = { gui.MouseX() - screenX, gui.MouseY() - screenY }
        self:MouseCapture( true )
    end

    function panel:OnMouseReleased()
        self.Dragging = nil
        self:MouseCapture( false )

        RL.Change_HUDOffset(self.Profile,parent:GetX(),parent:GetY())
    end

    RiceUI.Process("panel",panel,data)

    return panel
end

return main