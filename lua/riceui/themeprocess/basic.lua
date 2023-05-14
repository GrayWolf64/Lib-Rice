RiceUI.DefineThemeProcess("Label",function(pnl)
    pnl:SetColor(RiceUI.GetColorBase(pnl.ThemeMeta,pnl,"Text"))
end)

RiceUI.DefineThemeProcess("RL_Frame",function(pnl)
    pnl.Title:SetColor(RiceUI.GetColorBase(pnl.ThemeMeta,pnl,"Text"))
end)

RiceUI.DefineThemeProcess("ScrollPanel",function(pnl)
    pnl:RefreshVBar()
end)