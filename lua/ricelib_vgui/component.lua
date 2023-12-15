function RiceLib.VGUI.Button(text, panel, font, fontSize, x, y, w, h, doClickFunc, ...)
    doClickFunc = doClickFunc or function() end

    if isnumber(fontSize) then
        fontSize = tostring(fontSize)
    end

    local button = vgui.Create("DButton", panel)
    button:SetPos(RL_hudScale(x, y))
    button:SetSize(RL_hudScale(w, h))
    button:SetText(text)
    button:SetFont(font .. fontSize or "OPSans_" .. fontSize)

    local vararg = {...}
    button.DoClick = function()
        doClickFunc(unpack(vararg))
    end

    return button
end

function RiceLib.VGUI.ImageButton(icon, panel, x, y, w, h, doClickFunc, ...)
    doClickFunc = doClickFunc or function() end

    if isnumber(fontSize) then
        fontSize = tostring(fontSize)
    end

    local button = vgui.Create("DImageButton", panel)
    button:SetPos(RL_hudScale(x, y))
    button:SetSize(RL_hudScale(w, h))
    button:SetImage(icon)

    local vararg = {...}
    button.DoClick = function()
        doClickFunc(unpack(vararg))
    end

    return button
end

function RiceLib.VGUI.Toggle(panel, x, y, w, h, func)
    func = func or function() end

    local checkBox = vgui.Create("DCheckBox", panel)
    checkBox:SetPos(RL_hudScale(x, y))
    checkBox:SetSize(RL_hudScale(w, h))
    checkBox:SetColor(Color(180, 180, 180, 255))
    checkBox.toggleColor = Color(220, 220, 220, 255)
    checkBox.togglePos = 2

    function checkBox:OnChange(bool)
        self:doToggle(bool)

        func(bool)
    end

    function checkBox:Paint(w, h)
        local r = 7

        if h <= 25 then r = 5 end

        draw.RoundedBox(RiceLib.hudScaleY(r), 0, 0, w, h, self:GetColor())
        draw.RoundedBox(RiceLib.hudScaleY(r), self.togglePos, 2, h - 2, h - 4, checkBox.toggleColor)
    end

    function checkBox:doToggle(bool, setvalue)
        local anim = self:NewAnimation( self.a_length or 0.25, 0, self.a_ease or 0.25 )

        if bool then
            anim.StartPos = 2
            anim.TargetPos = self:GetWide() - self:GetTall()

            self:ColorTo(Color(0, 200, 0), 0.15, 0.05)
        else
            anim.StartPos = self:GetWide() - self:GetTall()
            anim.TargetPos = 2

            self:ColorTo(Color(180, 180, 180, 255), 0.15, 0.05)
        end

        anim.Think = function(anim, panel, fraction)
            self.togglePos = Lerp(fraction, anim.StartPos, anim.TargetPos)
        end
    end

    return checkBox
end

function RiceLib.VGUI.LabelToggle(text, panel, fontSize, x, y, w, h, cWidth, func)
    func = func or function() end

    local body = vgui.Create("DPanel", panel)
    body:SetSize(RL_hudScale(w, h))
    body:SetPos(RL_hudScale(x, y))
    body.Paint = function() end

    local checkBox = vgui.Create("DCheckBox", body)
    checkBox:Dock(RIGHT)
    checkBox:SetSize(RL_hudScale(cWidth, h))
    checkBox:SetColor(Color(180, 180, 180, 255))
    checkBox.toggleColor = Color(220, 220, 220, 255)
    checkBox.togglePos = 2

    function checkBox:OnChange(bool)
        self:doToggle(bool)

        func(bool)
    end

    function checkBox:Paint(w, h)
        local r = 7

        if h <= 25 then r = 5 end

        draw.RoundedBox(RiceLib.hudScaleY(r), 0, 0, w, h, self:GetColor())
        draw.RoundedBox(RiceLib.hudScaleY(r), self.togglePos, 2, h - 2, h - 4, checkBox.toggleColor)
    end

    function checkBox:doToggle(bool, setvalue)
        local anim = self:NewAnimation( self.a_length or 0.25, 0, self.a_ease or 0.25 )

        if bool then
            anim.StartPos = 2
            anim.TargetPos = self:GetWide() - self:GetTall()

            self:ColorTo(Color(0, 200, 0), 0.15, 0.05)
        else
            anim.StartPos = self:GetWide() - self:GetTall()
            anim.TargetPos = 2

            self:ColorTo(Color(180, 180, 180, 255), 0.15, 0.05)
        end

        anim.Think = function( anim, panel, fraction )
            self.togglePos = Lerp( fraction, anim.StartPos, anim.TargetPos )
        end
    end

    local label = RiceLib.VGUI.ModernLabel(text, body, fontSize, x, y)
    label:Dock(LEFT)

    return body, checkBox, label
end

function RiceLib.VGUI.Slider(panel, x, y, w, h, min, max, decimal, val ,func)
    func = func or function() end

    local slider = vgui.Create("RL_Slider", panel)
    slider:SetPos(RiceLib.hudScale(x, y))
    slider:SetSize(RiceLib.hudScale(w, h))
    slider.Decimals = decimal
    slider:SetMin(min)
    slider:SetMax(max)
    slider:SetValue(val)
    function slider:OnValueChanged(val)
        func(val)
    end

    return slider
end

function RiceLib.VGUI.LabelSlider(text, panel, fontSize, x, y, w, h, cWidth, cHeight, min, max, decimal, val, func)
    func = func or function() end

    local body = vgui.Create("DPanel", panel)
    body:SetSize(RL_hudScale(w, h))
    body:SetPos(RL_hudScale(x, y))
    body.Paint = function() end

    local slider = vgui.Create("RL_Slider", body)
    slider:SetPos(RiceLib.hudScale(w - cWidth, h / 2 - cHeight / 2))
    slider:SetSize(RiceLib.hudScale(cWidth, cHeight))
    slider.Decimals = decimal
    slider:SetMin(min)
    slider:SetMax(max)
    slider:SetValue(val)
    function slider:OnValueChanged(val)
        func(val)
    end

    local label = RiceLib.VGUI.ModernLabel(text, body, fontSize, x, y)
    label:Dock(LEFT)

    return body, slider, label
end