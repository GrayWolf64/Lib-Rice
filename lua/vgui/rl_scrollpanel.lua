local PANEL = {}

function PANEL:Init()

	self.pnlCanvas = vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )

		self:PerformLayoutInternal()
		self:InvalidateParent()

	end

	-- Create the scroll bar
	self.VBar = vgui.Create( "RL_ScrollBar", self )
	self.VBar:Dock( RIGHT )

	self:SetPadding( 0 )
	self:SetMouseInputEnabled( true )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackground( false )

end

derma.DefineControl( "RL_ScrollPanel", "", PANEL, "DScrollPanel" )
