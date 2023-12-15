local PANEL = {}

function PANEL:Init()

    self.Decimals = 0
    self.c_Color = Color( 0, 190, 0, 255 )
    self.c_TextBackGroundColor = Color(50,50,50,255)
    self.c_BackGroundColor = Color(100,100,100,255)

    self.ValueMin = 0
    self.ValueMax = 100
    self.ValueOld = 0
    self:SetValue(self.ValueMin)

	self:SetMouseInputEnabled( true )
	self:SetSlideX( 0 )
	self:SetSlideY( 0.5 )
	self:SetLockY( 0.5 )

    function self.Knob.Paint( self, w, h )
        RiceLib.Draw.Circle(0+w/2,0+h/2,h/2,64,self:GetParent().c_Color)
        RiceLib.Draw.Circle(0+w/2,0+h/2,h/2-RiceLib.hudScaleY(2),64,Color(200,200,200,255))
    end
    function self:Paint(w,h)
        draw.RoundedBox(5,0,h/4,w,h/2,self.c_BackGroundColor)
        draw.RoundedBox(5,0,h/4,w*self:GetSlideX(),h/2,self.c_Color)

        if self:IsEditing() then
            local size = RiceLib.hudScaleX(#tostring(self:GetValue())*10)+RiceLib.hudScaleX(10)

            draw.RoundedBox(5,w*self:GetSlideX()-size/2,RiceLib.hudScaleY(-25),size,20,self.c_TextBackGroundColor)
            draw.SimpleText(self:GetValue(),"OPPOSans_20",w*self:GetSlideX(),RiceLib.hudScaleY(-5),Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
        end
    end

    self:NoClipping( true )

end

function PANEL:GetValue()
    return math.Round(math.Remap(self:GetSlideX(),0,1,self.ValueMin,self.ValueMax),self.Decimals)
end

function PANEL:Think()
    if self:IsEditing() then
        if self.ValueOld == self:GetValue() then return end

        self.ValueOld = self:GetValue()
        self:OnValueChanged(self:GetValue())
    end
end

function PANEL:OnValuesChangedInternal()
	self:InvalidateLayout()
end

function PANEL:SetValue(value)
    self:SetSlideX(math.Remap(value,self.ValueMin,self.ValueMax,0,1))
end

function PANEL:SetMin(min) self.ValueMin = min end
function PANEL:SetMax(max) self.ValueMax = max end

function PANEL:OnValueChanged(val)
end

derma.DefineControl( "RL_Slider", "More Modern Slider", PANEL, "DSlider" )