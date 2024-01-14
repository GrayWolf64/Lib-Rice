RiceUI.DefineUniProcess("center", function(pnl)
    pnl:Center()
end)

RiceUI.DefineUniProcess("dock", function(pnl, data)
    pnl:Dock(data)
end)

RiceUI.DefineUniProcess("Margin", function(pnl, data)
    pnl:DockMargin(data[1], data[2] or 0, data[3] or 0, data[4] or 0)
end)

RiceUI.DefineUniProcess("Padding", function(pnl, data)
    pnl:DockPadding(data[1], data[2] or 0, data[3] or 0, data[4] or 0)
end)

RiceUI.DefineUniProcess("Root", function(pnl)
    pnl:MakePopup()
end)

RiceUI.DefineUniProcess("Clipping", function(pnl, data)
    pnl:NoClipping(data)
end)

RiceUI.DefineUniProcess("Alpha", function(pnl, data)
    pnl:SetAlpha(data)
end)

RiceUI.DefineUniProcess("Paint", function(pnl, data)
    pnl.Paint = data
end)

RiceUI.DefineUniProcess("PaintManually", function(pnl, data) pnl:SetPaintedManually(data) end)

RiceUI.DefineUniProcess("OnTop", function(pnl, data)
    if not data then return end
    pnl:SetDrawOnTop(true)
    pnl:MakePopup()
    pnl:DoModal()
end)

RiceUI.DefineUniProcess("DrawOnTop", function(panel, data)
    if not data then return end

    panel:SetDrawOnTop(true)
end)

RiceUI.DefineUniProcess("Theme", function(pnl, data)
    if data.NT then return end
    if not data.ThemeName then return end

    pnl.Paint = RiceUI.GetTheme(data.ThemeName)[data.ThemeType]
end)

RiceUI.DefineUniProcess("Column", {
    ListView = function(pnl, data)
        for i, v in ipairs(data) do
            pnl:AddColumn(v)
        end
    end
})

RiceUI.DefineUniProcess("Line", {
    ListView = function(pnl, data)
        for i, v in ipairs(data) do
            pnl:AddLine(unpack(v))
        end
    end
})

RiceUI.DefineUniProcess("Choice", {
    Combo = function(pnl, data)
        for i, v in ipairs(data) do
            pnl:AddChoice(unpack(v))
        end
    end,

    RL_Combo = function(pnl, data)
        for i, v in ipairs(data) do
            pnl:AddChoice(unpack(v))
        end
    end
})

RiceUI.DefineUniProcess("Numeric", {
    Entry = function(pnl, data)
        pnl:SetNumeric(data)
    end
})

RiceUI.DefineUniProcess("Font", {
    Label = function(pnl, data)
        pnl:SetFont(data)
    end,

    Button = function(pnl, data)
        pnl:SetFont(data)
    end,

    RL_Combo = function(pnl, data)
        pnl:SetFont(data)
    end,
})

RiceUI.DefineUniProcess("Anim", function(pnl, data)
    for _, AnimData in ipairs(data) do
        if AnimData.type == "alpha" then
            pnl:AlphaTo(AnimData.alpha, AnimData.time, AnimData.delay or 0, AnimData.CallBack or function() end)
        end

        if AnimData.type == "move" then
            pnl:MoveTo(AnimData.x or 0, AnimData.y or 0, AnimData.time, AnimData.delay or 0, AnimData.ease or 0.3, AnimData.CallBack or function() end)
        end

        if AnimData.type == "resize" then
            pnl:SizeTo(AnimData.w or 0, AnimData.h or 0, AnimData.time, AnimData.delay or 0, AnimData.ease or 0.3, AnimData.CallBack or function() end)
        end
    end
end)

RiceUI.DefineUniProcess("Value", {
    Slider = function(pnl, data)
        pnl:SetSlideX(math.Remap(data, pnl.Min, pnl.Max, 0, 1))
    end,

    ColorMixer = function(pnl, data)
        pnl:SetColor(data)
    end,

    RL_NumberWang = function(pnl, data)
        pnl:SetValue(data)
        pnl:SetText(data)
    end,

    RL_NumberCounter = function(pnl, data)
        pnl:SetValue(data)
        pnl:SetText(data)
    end
})

RiceUI.DefineUniProcess("OffsetProfile", function(pnl, data)
    pnl:SetPos(RiceLib.hudOffset(100, 100, data))
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