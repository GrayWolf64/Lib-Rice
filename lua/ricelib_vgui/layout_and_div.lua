function RL.VGUI.HDiv(panel, left, right, width, lmin, rmin, lw)
    local div = vgui.Create( "DHorizontalDivider", panel )
    div:Dock( FILL )
    div:SetLeft( left )
    div:SetRight( right )
    div:SetDividerWidth( RL.hudScaleX(width or 4) )
    div:SetLeftMin( RL.hudScaleX(lmin or 250) )
    div:SetRightMin( RL.hudScaleX(rmin or 100) )
    div:SetLeftWidth( RL.hudScaleX(lw or 250) )
end

function RL.VGUI.VDiv(panel, top, buttom, width, tmin, bmin, th)
    local div = vgui.Create( "DVerticalDivider", panel )
    div:Dock( FILL )
    div:SetTop( top )
    div:SetBottom( buttom )
    div:SetDividerHeight( RL.hudScaleY(width or 4) )
    div:SetTopMin( RL.hudScaleY(tmin or 150) )
    div:SetBottomMin( RL.hudScaleY(bmin or 100) )
    div:SetTopHeight( RL.hudScaleY(th or 150) )
end

function RL.VGUI.Layout(panel,spacex,spacey,x,y,w,h)
    local layout = vgui.Create("DIconLayout",panel)
    layout:SetPos(RL.hudScale(x,y))
    layout:SetSize(RL.hudScale(w,h))
    layout:SetSpaceX(RL.hudScaleX(spacex))
    layout:SetSpaceY(RL.hudScaleY(spacey))

    return layout
end

function RL.VGUI.DockLayout(panel,spacex,spacey,l,t,r,b)
    l,t,r,b = l or 0, t or 0, r or 0, b or 0

    local layout = vgui.Create("DIconLayout",panel)
    layout:Dock(FILL)
    layout:DockMargin(RL.hudOffsetX(l),RL.hudOffsetY(t),RL.hudOffsetX(r),RL.hudOffsetY(b))
    layout:SetSpaceX(RL.hudScaleX(spacex))
    layout:SetSpaceY(RL.hudScaleY(spacey))

    return layout
end

function RL.VGUI.ScrollPanel(Panel,X,Y,W,H)
    local X,Y,W,H = X or 0, Y or 0, W or 0, H or 0

    local panel = vgui.Create("DScrollPanel",Panel)
    panel:SetPos(RL.hudScale(X or 0,Y or 0))
    panel:SetSize(RL.hudScale(W or 0,H or 0))

    local bar = panel.VBar
    bar:SetHideButtons(true)

    bar.a_length = 0.5 -- animation length.
    bar.a_ease = 0.25 -- easing animation IN and OUT.
    bar.a_amount = 30 -- scroll amount.

    // Code From https://github.com/Minbird/Smooth_Scroll
    local function sign( num )
        return num > 0
    end
    
    local function getBiggerPos( signOld, signNew, old, new )
        if signOld != signNew then return new end
        if signNew then
            return math.max(old, new)
        else
            return math.min(old, new)
        end
    end
    
    local tScroll = 0
    local newerT = 0
    
    function bar:AddScroll( dlta )
    
        self.Old_Pos = nil
        self.Old_Sign = nil
    
        local OldScroll = self:GetScroll()

        dlta = dlta * self.a_amount
        
        local anim = self:NewAnimation( self.a_length, 0, self.a_ease )
        anim.StartPos = OldScroll
        anim.TargetPos = OldScroll + dlta + tScroll
        tScroll = tScroll + dlta
    
        local ctime = RealTime() -- does not work correctly with CurTime, when in single player game and in game menu (then CurTime get stuck). I think RealTime is better.
        local doing_scroll = true
        newerT = ctime
        
        anim.Think = function( anim, pnl, fraction )
            local nowpos = Lerp( fraction, anim.StartPos, anim.TargetPos )
            if ctime == newerT then
                self:SetScroll( getBiggerPos( self.Old_Sign, sign(dlta), self.Old_Pos, nowpos ) )
                tScroll = tScroll - (tScroll * fraction)
            end
            if doing_scroll then -- it must be here. if not, sometimes scroll get bounce.
                self.Old_Sign = sign(dlta)
                self.Old_Pos = nowpos
            end
            if ctime != newerT then doing_scroll = false end
        end
    
        return math.Clamp( self:GetScroll() + tScroll, 0, self.CanvasSize ) != self:GetScroll()
    
    end

    return panel,bar,bar.btnGrip
end