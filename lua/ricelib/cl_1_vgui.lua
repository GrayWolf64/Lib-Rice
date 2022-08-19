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

// 现代VGUI组件
function RL.VGUI.ModernLabel(Text,Panel,FontSize,X,Y,color)
    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end

    local lb = Label(Text, Panel)
    lb:SetPos(RL_hudScale(X,Y))
    lb:SetFont("OPPOSans_"..FontSize)
    lb:SetColor(color or Color(30,30,30))
    lb:SizeToContents()

    return lb
end

function RL.VGUI.ModernButton(Text,Panel,FontSize,X,Y,W,H,DoClickFun,...)
    local var = {...}
    DoClickFun = DoClickFun or function() end

    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end

    local btn = vgui.Create("DButton", Panel)
    btn:SetPos(RL_hudScale(X,Y))
    btn:SetSize(RL_hudScale(W,H))
    btn:SetText(Text)
    btn:SetTheme("ModernButton")
    btn:SetFont("OPPOSans_"..FontSize)
    btn.DoClick = function()
        DoClickFun(unpack(var))
    end

    return btn
end

function RL.VGUI.ModernTextEntry(Text,Panel,FontSize,X,Y,W,H,CW,Fun)
    Fun = Fun or function() end

    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end
    
    local body = vgui.Create("DPanel", Panel)
    body:SetSize(RL_hudScale(W,H))
    body:SetPos(RL_hudScale(X,Y))
    body.Paint = function() end

    local label = RL.VGUI.ModernLabel(Text,body,FontSize,0,0):Dock(LEFT)

    local TE = vgui.Create("DTextEntry", body)
    TE:Dock(RIGHT)
    TE:SetWide(RL_hudScaleX(CW))
    TE:SetFont("OPPOSans_"..FontSize)
    TE.OnEnter = function(self,text)
        Fun(text)
    end

    return body,TE,label
end

function RL.VGUI.ModernCheckBox(Text,Panel,FontSize,X,Y,W,H,Fun)
    Fun = Fun or function() end

    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end
    
    local body = vgui.Create("DPanel", Panel)
    body:SetSize(RL_hudScale(W,H))
    body:SetPos(RL_hudScale(X,Y))
    body.Paint = function() end

    local CB = vgui.Create("DCheckBox", body)
    CB:Dock(LEFT)
    CB:SetWide(body:GetTall())
    CB:SetFont("OPPOSans_"..FontSize)
    function CB:PaintOver(w,h)
        if self:GetChecked() then
            surface.SetDrawColor(Color(0,190,0))
            surface.DrawRect(4,3,w-7,h-7)
        end
    end
    function CB:OnChange(bool)
        Fun(bool) 
    end

    local label = RL.VGUI.ModernLabel(Text,body,FontSize,0,0)
    label:Dock(LEFT)
    label:DockMargin(RL.hudScaleX(5),0,0,0)

    return body,CB,label
end

function RL.VGUI.ModernComboBox(Text,Panel,FontSize,X,Y,W,H,CW,Fun)
    Fun = Fun or function() end

    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end
    
    local body = vgui.Create("DPanel", Panel)
    body:SetSize(RL_hudScale(W,H))
    body:SetPos(RL_hudScale(X,Y))
    body.Paint = function() end

    local label = RL.VGUI.ModernLabel(Text,body,FontSize,0,0)
    label:Dock(LEFT)

    local CB = vgui.Create("DComboBox", body)
    CB:Dock(RIGHT)
    CB:SetWide(RL_hudScaleX(CW))
    CB:SetFont("OPPOSans_"..FontSize)
    function CB:OnSelect(index,value)
        Fun(value)
    end

    return body,CB,label
end

function RL.VGUI.ModernNumberWang(Text,Panel,FontSize,X,Y,W,H,CW,Fun)
    Fun = Fun or function() end

    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end
    
    local body = vgui.Create("DPanel", Panel)
    body:SetSize(RL_hudScale(W,H))
    body:SetPos(RL_hudScale(X,Y))
    body.Paint = function() end

    local label = RL.VGUI.ModernLabel(Text,body,FontSize,0,0):Dock(LEFT)

    local NW = vgui.Create("DNumberWang", body)
    NW:Dock(RIGHT)
    NW:SetWide(RL_hudScaleX(CW))
    NW:SetFont("OPPOSans_"..FontSize)
    function NW:OnValueChanged(value)
        Fun(value)
    end

    return body,NW,label
end

// VGUI Component
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
    btn:SetFont(Font..FontSize or "OPPOSans_"..FontSize)
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
    function CB:doToggle(bool,setvalue)
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
    
        anim.Think = function( anim, pnl, fraction )
            self.togglePos = Lerp( fraction, anim.StartPos, anim.TargetPos )
        end
    end

    return CB
end

function RL.VGUI.Slider(Panel,X,Y,W,H,Min,Max,Fun)
    Fun = Fun or function() end

    local sld = vgui.Create("RL_Slider",Panel)
    sld:SetPos(RL.hudScale(X,Y))
    sld:SetSize(RL.hudScale(W,H))
    sld:SetMin(Min)
    sld:SetMax(Max)
    function sld:OnValueChanged(val)
        Fun(val)
    end

    return sld
end

function RL.VGUI.ScrollPanel(Panel,X,Y,W,H)
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