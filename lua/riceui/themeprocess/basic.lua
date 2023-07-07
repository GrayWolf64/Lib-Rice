RiceUI.DefineThemeProcess("Label",function(pnl)
    pnl:SetColor(RiceUI.GetColorBase(pnl.ThemeMeta, pnl, "Text"))
end)

RiceUI.DefineThemeProcess("RL_Frame",function(pnl)
    pnl.Title:SetColor(RiceUI.GetColorBase(pnl.ThemeMeta, pnl, "Text"))
end)

RiceUI.DefineThemeProcess("ScrollPanel",function(pnl)
    pnl:RefreshVBar()
end)

RiceUI.DefineThemeProcess("Switch",function(pnl)
    pnl.Color = RiceUI.GetColorBase(pnl.ThemeMeta, pnl, "Focus")

    if not pnl.Value then return end

    pnl:SetColor(pnl.Color)
end)