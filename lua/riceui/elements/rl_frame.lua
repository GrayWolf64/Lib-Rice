local function main(data,parent)
    table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
    })

    local panel = vgui.Create("DButton",parent)
    panel:SetPos(RL.hudScale(data.x,data.y))
    panel:SetSize(RL.hudScale(data.w,data.h))
    panel:SetText("")
    panel:SetCursor("arrow")
    panel.Paint = RiceUI.GetTheme("modern").RL_Frame
    panel.Theme = {Color = "white1"}

    function panel:Think()
        local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
        local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

        if ( self.Dragging ) then

            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]

            self:SetPos( x, y )

        end
    end

    function panel:OnMousePressed()
        local screenX, screenY = self:LocalToScreen( 0, 0 )

        if (gui.MouseY() < ( screenY + self.Title:GetTall()+5 ) ) then
            self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
            self:MouseCapture( true )
            return
        end
    end

    function panel:OnMouseReleased()
        self.Dragging = nil
        self:MouseCapture( false )
    end

    panel.Title = RiceUI.SimpleCreate({type="label",Font="OPPOSans_20",Text=data.Text or "标题",x=5,y=5,Color = Color(25,25,25)},panel)
    panel.CloseButton = RiceUI.SimpleCreate({type="button",Font=panel.Title:GetFont(),Text="X",x=data.w-52.5,y=2.5,w=50,h=panel.Title:GetTall()+5,
        Paint = RiceUI.GetTheme("modern").TransButton,
        Theme={Color="closeButton"},
        DoClick = function()
            panel:Remove()
        end
    },panel)

    function panel.CloseButton:Resize()
        self:SetTall(panel.Title:GetTall()+5)
    end

    RiceUI.Process("panel",panel,data)

    return panel
end

return main