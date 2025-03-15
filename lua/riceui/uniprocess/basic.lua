RiceUI.DefineUniProcess("center", function(panel)
    panel:Center()
end)

RiceUI.DefineUniProcess("dock", function(panel, data)
    panel:Dock(data)
end)

RiceUI.DefineUniProcess("Margin", function(panel, data)
    panel:DockMargin(data[1], data[2] or 0, data[3] or 0, data[4] or 0)
end)

RiceUI.DefineUniProcess("Padding", function(panel, data)
    panel:DockPadding(data[1], data[2] or 0, data[3] or 0, data[4] or 0)
end)

RiceUI.DefineUniProcess("ZPos", function(panel, data)
    panel:SetZPos(data)
end)

RiceUI.DefineUniProcess("Root", function(panel)
    panel:MakePopup()
end)

RiceUI.DefineUniProcess("Clipping", function(panel, data)
    panel:NoClipping(data)
end)

RiceUI.DefineUniProcess("Alpha", function(panel, data)
    panel:SetAlpha(data)
end)

RiceUI.DefineUniProcess("Paint", function(panel, data)
    panel.Paint = data
end)

RiceUI.DefineUniProcess("PaintManually", function(panel, data) panel:SetPaintedManually(data) end)

RiceUI.DefineUniProcess("OnTop", function(panel, data)
    if not data then return end
    panel:SetDrawOnTop(true)
    panel:MakePopup()
    panel:DoModal()
end)

RiceUI.DefineUniProcess("DrawOnTop", function(panel, data)
    if not data then return end

    panel:SetDrawOnTop(true)
end)

RiceUI.DefineUniProcess("Theme", function(panel, data)
    if not data.ThemeName then return end

    panel.Paint = RiceUI.GetTheme(data.ThemeName)[data.ThemeType]
end)

RiceUI.DefineUniProcess("Column", {
    ListView = function(panel, data)
        for i, v in ipairs(data) do
            panel:AddColumn(v)
        end
    end
})

RiceUI.DefineUniProcess("Line", {
    ListView = function(panel, data)
        for i, v in ipairs(data) do
            panel:AddLine(unpack(v))
        end
    end
})

RiceUI.DefineUniProcess("Choice", {
    Combo = function(panel, data)
        for i, v in ipairs(data) do
            panel:AddChoice(unpack(v))
        end
    end,

    ComboBox = function(panel, data)
        for i, v in ipairs(data) do
            panel:AddChoice(unpack(v))
        end
    end
})

RiceUI.DefineUniProcess("Numeric", {
    Entry = function(panel, data)
        panel:SetNumeric(data)
    end
})

RiceUI.DefineUniProcess("Font", {
    Label = function(panel, fontName)
        panel:SetFont(RiceUI.Font.Get(fontName))
        if not panel.NoResize then panel:SizeToContents() end
    end,

    Button = function(panel, fontName) panel:SetFont(RiceUI.Font.Get(fontName)) end,
    RL_Combo = function(panel, fontName) panel:SetFont(RiceUI.Font.Get(fontName)) end,
})

RiceUI.DefineUniProcess("Anim", function(panel, data)
    for _, AnimData in ipairs(data) do
        if AnimData.type == "alpha" then
            panel:AlphaTo(AnimData.alpha, AnimData.time, AnimData.delay or 0, AnimData.CallBack or function() end)
        end

        if AnimData.type == "move" then
            panel:MoveTo(AnimData.x or 0, AnimData.y or 0, AnimData.time, AnimData.delay or 0, AnimData.ease or 0.3, AnimData.CallBack or function() end)
        end

        if AnimData.type == "resize" then
            panel:SizeTo(AnimData.w or 0, AnimData.h or 0, AnimData.time, AnimData.delay or 0, AnimData.ease or 0.3, AnimData.CallBack or function() end)
        end
    end
end)

RiceUI.DefineUniProcess("Value", {
    Slider = function(panel, data)
        panel:SetSlideX(math.Remap(data, panel.Min, panel.Max, 0, 1))
    end,

    ColorMixer = function(panel, data)
        panel:SetColor(data)
    end,

    RL_NumberWang = function(panel, data)
        panel:SetValue(data)
        panel:SetText(data)
    end,

    RL_NumberCounter = function(panel, data)
        panel:SetValue(data)
        panel:SetText(data)
    end
})

RiceUI.DefineUniProcess("OffsetProfile", function(panel, data)
    local x, y = RiceLib.hudOffset(100, 100, data)
    if not RiceLib.UI.ValidOffset(data) then return end

    if panel.DoOffsetProfile then
        panel:DoOffsetProfile(x, y)

        return
    end

    panel:SetPos(x, y)
end)

RiceUI.DefineUniProcess("ConVar", {
    Slider = function(panel, data)
        local convar = GetConVar(data)

        function panel:OnValueChanged(val)
            RunConsoleCommand(data, val)
        end

        panel:SetSlideX(math.Remap(convar:GetFloat(), panel.Min, panel.Max, 0, 1))
    end,

    Switch = function(panel, data)
        local convar = GetConVar(data)
        if not convar then return end

        function panel:OnValueChanged(val)
            local num = 0
            if val then num = 1 end

            RunConsoleCommand(data, num)
        end

        panel:SetValue(convar:GetBool())
    end,

    RL_NumberWang = function(panel, data)
        local convar = GetConVar(data)

        function panel:OnValueChanged(val)
            RunConsoleCommand(data, val)
        end

        panel:SetValue(convar:GetFloat())
    end,

    Entry = function(panel, data)
        local convar = GetConVar(data)

        function panel:OnValueChanged(val)
            RunConsoleCommand(data, val)
        end

        panel:SetValue(convar:GetString())
    end,
})