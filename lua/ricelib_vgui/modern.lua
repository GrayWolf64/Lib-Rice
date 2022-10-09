// 现代VGUI组件
function RL.VGUI.ModernLabel(Text,Panel,FontSize,X,Y,color)
    if isnumber(FontSize) then
        FontSize = tostring(FontSize)
    end

    if string.StartWith(Text,"#") then Text = RL.Language.Get(string.sub(Text,2)) or Text end

    local lb = vgui.Create("DLabel",Panel)
    lb:SetText(Text)
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
    btn:SetText("")
    btn:SetTheme("ModernButton")
    btn.Font = "OPPOSans_"..FontSize
    btn.Text = Text
    btn.DoClick = function()
        DoClickFun(unpack(var))
    end
    btn.PaintOver = function(self,w,h)
        draw.SimpleText(self.Text,self.Font,w/2,h/2,self:GetTextColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
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

    local label = RL.VGUI.ModernLabel(Text,body,FontSize,0,0)
    label:Dock(LEFT)

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

function RL.VGUI.ModernComboBox(Text,Panel,FontSize,X,Y,W,H,CW,Fun,DarkMode)
    Fun = Fun or function() end

    local darkmode = "Dark"
    if not DarkMode then darkmode = "Light" end

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
    CB:SetTheme("OutlineRect")
    CB:SetColorTheme(darkmode.."3")

    function CB:OnSelect(index,value)
        Fun(value)
    end
    function CB:OnMenuOpened(menu)
        menu.Paint = function() end

        for i=1,menu:ChildCount() do
            local child = menu:GetChild(i)
            child:SetTheme("ModernRect")
            child:SetColorTheme(darkmode.."2")
            child:SetFont("OPPOSans_"..tonumber(FontSize)-10)
            child:SizeToContents()
        end
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