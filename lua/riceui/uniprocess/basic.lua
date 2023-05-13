RiceUI.DefineUniProcess("center",function(pnl) pnl:Center() end)
RiceUI.DefineUniProcess("dock",function(pnl,data) pnl:Dock(data) end)
RiceUI.DefineUniProcess("Margin",function(pnl,data) pnl:DockMargin(data[1],data[2] or 0,data[3] or 0,data[4] or 0) end)
RiceUI.DefineUniProcess("Padding",function(pnl,data) pnl:DockPadding(data[1],data[2] or 0,data[3] or 0,data[4] or 0) end)
RiceUI.DefineUniProcess("Root",function(pnl) pnl:MakePopup() end)
RiceUI.DefineUniProcess("Clipping",function(pnl,data) pnl:NoClipping(data) end)
RiceUI.DefineUniProcess("Alpha",function(pnl,data) pnl:SetAlpha(data) end)
RiceUI.DefineUniProcess("Paint",function(pnl,data) pnl.Paint = data end)

RiceUI.DefineUniProcess("Theme",function(pnl,data)
    if !data.ThemeName then return end

    pnl.Paint = RiceUI.GetTheme(data.ThemeName)[data.ThemeType]
end)

RiceUI.DefineUniProcess("Column",{
    ListView = function(pnl,data)
        for i,v in ipairs(data) do
            pnl:AddColumn(v)
        end
    end
})

RiceUI.DefineUniProcess("Line",{
    ListView = function(pnl,data)
        for i,v in ipairs(data) do
            pnl:AddLine(unpack(v))
        end
    end
})

RiceUI.DefineUniProcess("Choice",{
    Combo = function(pnl,data)
        for i,v in ipairs(data) do
            pnl:AddChoice(unpack(v))
        end
    end,

    RL_Combo = function(pnl,data)
        for i,v in ipairs(data) do
            pnl:AddChoice(unpack(v))
        end
    end
})

RiceUI.DefineUniProcess("Numeric",{
    Entry = function(pnl,data)
        pnl:SetNumeric(data)
    end
})

RiceUI.DefineUniProcess("Font",{
    Label = function(pnl,data)
        pnl:SetFont(data)
    end,

    Button = function(pnl,data)
        pnl:SetFont(data)
    end,

    RL_Combo = function(pnl,data)
        pnl:SetFont(data)
    end,
})

RiceUI.DefineUniProcess("Anim",function(pnl,data)
    for _,AnimData in ipairs(data) do
        if AnimData.type == "alpha" then
            pnl:AlphaTo(AnimData.alpha,AnimData.time,AnimData.delay or 0,AnimData.CallBack or function()end)
        end

        if AnimData.type == "move" then
            pnl:MoveTo(AnimData.x or 0,AnimData.y or 0,AnimData.time,AnimData.delay or 0,AnimData.ease or -1,AnimData.CallBack or function()end)
        end
    end
end)

RiceUI.DefineUniProcess("Value",{
    Slider = function(pnl,data)
        pnl:SetSlideX(math.Remap(data,pnl.Min,pnl.Max,0,1))
    end
})