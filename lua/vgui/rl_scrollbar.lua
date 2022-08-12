local PANEL = {}

function PANEL:Init()

	self.Offset = 0
	self.Scroll = 0
	self.CanvasSize = 1
	self.BarSize = 1
    self.a_length = 0.5 -- animation length.
    self.a_ease = 0.25 -- easing animation IN and OUT.
    self.a_amount = 30 -- scroll amount.

	self.btnUp = vgui.Create( "DButton", self )
	self.btnUp:SetText( "" )
	self.btnUp.DoClick = function( self ) self:GetParent():AddScroll( -1 ) end
	self.btnUp.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonUp", panel, w, h ) end

	self.btnDown = vgui.Create( "DButton", self )
	self.btnDown:SetText( "" )
	self.btnDown.DoClick = function( self ) self:GetParent():AddScroll( 1 ) end
	self.btnDown.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonDown", panel, w, h ) end

	self.btnGrip = vgui.Create( "DScrollBarGrip", self )

	self:SetSize( 15, 15 )
	self:SetHideButtons( false )

end

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

function PANEL:AddScroll( dlta )

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

derma.DefineControl( "RL_ScrollBar", "Smooth Scrollbar", PANEL, "DScrollPanel" )
