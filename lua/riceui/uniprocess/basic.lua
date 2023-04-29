RiceUI.DefineUniProcess("center",function(pnl) pnl:Center() end)
RiceUI.DefineUniProcess("dock",function(pnl,data) pnl:Dock(data) end)
RiceUI.DefineUniProcess("Margin",function(pnl,data) pnl:DockMargin(data[1],data[2] or 0,data[3] or 0,data[4] or 0) end)
RiceUI.DefineUniProcess("Root",function(pnl) pnl:MakePopup() end)
RiceUI.DefineUniProcess("Clipping",function(pnl,data) pnl:NoClipping(data) end)

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