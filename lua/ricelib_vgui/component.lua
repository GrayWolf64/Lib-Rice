function RL.VGUI.Button(Text,Panel,Font,FontSize,X,Y,W,H,DoClickFun,...)
    local var = {...}
    DoClickFun = DoClickFun or function() end

    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end

    local btn = vgui.Create("DButton", Panel)
    btn:SetPos(RL_hudScale(X,Y))
    btn:SetSize(RL_hudScale(W,H))
    btn:SetText(Text)
    btn:SetFont(Font..FontSize or "OPSans_"..FontSize)
    btn.DoClick = function()
        DoClickFun(unpack(var))
    end

    return btn
end

function RL.VGUI.ImageButton(Icon,Panel,X,Y,W,H,DoClickFun,...)
    local var = {...}
    DoClickFun = DoClickFun or function() end

    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end

    local btn = vgui.Create("DImageButton", Panel)
    btn:SetPos(RL_hudScale(X,Y))
    btn:SetSize(RL_hudScale(W,H))
    btn:SetImage(Icon)
    btn.DoClick = function()
        DoClickFun(unpack(var))
    end

    return btn
end

function RL.VGUI.Toggle(Panel,X,Y,W,H,Fun)
    Fun = Fun or function() end

    local CB = vgui.Create("DCheckBox", Panel)
    CB:SetPos(RL_hudScale(X,Y))
    CB:SetSize(RL_hudScale(W,H))
    CB:SetColor(Color(180,180,180,255))
    CB.toggleColor = Color(220,220,220,255)
    CB.togglePos = 2
    function CB:OnChange(bool)
        self:doToggle(bool)

        Fun(bool)
    end
    function CB:Paint(w,h)
        local r = 7

        if h <= 25 then r = 5 end

        draw.RoundedBox(RL.hudScaleY(r),0,0,w,h,self:GetColor())
        draw.RoundedBox(RL.hudScaleY(r),self.togglePos,2,h-2,h-4,CB.toggleColor)
    end
    function CB:doToggle(bool)
        local anim = self:NewAnimation( self.a_length or 0.25, 0, self.a_ease or 0.25 )

        if bool then
            anim.StartPos = 2
            anim.TargetPos = self:GetWide() - self:GetTall()
            
            self:ColorTo(Color(0,200,0),0.15,0.05)
        else
            anim.StartPos = self:GetWide() - self:GetTall()
            anim.TargetPos = 2

            self:ColorTo(Color(180,180,180,255),0.15,0.05)
        end
    
        anim.Think = function( anim, _, fraction )
            self.togglePos = Lerp( fraction, anim.StartPos, anim.TargetPos )
        end
    end

    return CB
end

function RL.VGUI.LabelToggle(Text,Panel,FontSize,X,Y,W,H,CW,Fun)
    Fun = Fun or function() end

    local body = vgui.Create("DPanel", Panel)
    body:SetSize(RL_hudScale(W,H))
    body:SetPos(RL_hudScale(X,Y))
    body.Paint = function() end

    local CB = vgui.Create("DCheckBox", body)
    CB:Dock(RIGHT)
    CB:SetSize(RL_hudScale(CW,H))
    CB:SetColor(Color(180,180,180,255))
    CB.toggleColor = Color(220,220,220,255)
    CB.togglePos = 2
    function CB:OnChange(bool)
        self:doToggle(bool)

        Fun(bool)
    end
    function CB:Paint(w,h)
        local r = 7

        if h <= 25 then r = 5 end

        draw.RoundedBox(RL.hudScaleY(r),0,0,w,h,self:GetColor())
        draw.RoundedBox(RL.hudScaleY(r),self.togglePos,2,h-2,h-4,CB.toggleColor)
    end
    function CB:doToggle(bool)
        local anim = self:NewAnimation( self.a_length or 0.25, 0, self.a_ease or 0.25 )

        if bool then
            anim.StartPos = 2
            anim.TargetPos = self:GetWide() - self:GetTall()
            
            self:ColorTo(Color(0,200,0),0.15,0.05)
        else
            anim.StartPos = self:GetWide() - self:GetTall()
            anim.TargetPos = 2

            self:ColorTo(Color(180,180,180,255),0.15,0.05)
        end
    
        anim.Think = function( anim, _, fraction )
            self.togglePos = Lerp( fraction, anim.StartPos, anim.TargetPos )
        end
    end

    local label = RL.VGUI.ModernLabel(Text,body,FontSize,X,Y)
    label:Dock(LEFT)

    return body,CB,label
end

function RL.VGUI.Slider(Panel,X,Y,W,H,Min,Max,Decimal,Val,Fun)
    Fun = Fun or function() end

    local sld = vgui.Create("RL_Slider",Panel)
    sld:SetPos(RL.hudScale(X,Y))
    sld:SetSize(RL.hudScale(W,H))
    sld.Decimals = Decimal
    sld:SetMin(Min)
    sld:SetMax(Max)
    sld:SetValue(Val)
    function sld:OnValueChanged(val)
        Fun(val)
    end

    return sld
end

function RL.VGUI.LabelSlider(Text,Panel,FontSize,X,Y,W,H,CW,CH,Min,Max,Decimal,Val,Fun)
    Fun = Fun or function() end

    local body = vgui.Create("DPanel", Panel)
    body:SetSize(RL_hudScale(W,H))
    body:SetPos(RL_hudScale(X,Y))
    body.Paint = function() end

    local sld = vgui.Create("RL_Slider",body)
    sld:SetPos(RL.hudScale(W-CW,H/2-CH/2))
    sld:SetSize(RL.hudScale(CW,CH))
    sld.Decimals = Decimal
    sld:SetMin(Min)
    sld:SetMax(Max)
    sld:SetValue(Val)
    function sld:OnValueChanged(val)
        Fun(val)
    end

    local label = RL.VGUI.ModernLabel(Text,body,FontSize,X,Y)
    label:Dock(LEFT)

    return body,sld,label
end