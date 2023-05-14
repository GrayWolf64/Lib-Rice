RiceUI = RiceUI or {}

/*

    Utils

*/

function RiceUI.GetTheme(name) return RiceUI.Theme[name] end

function RiceUI.GetColor(tbl,pnl,name,default)
    name = name or ""
    default = default or "white1"

    return pnl.Theme["Raw" .. name .. "Color"] or tbl[name .. "Color"][pnl.Theme.Color] or tbl[name .. "Color"][default]
end

function RiceUI.GetColorBase(tbl,pnl,name,default)
    name = name or ""
    default = default or "white"
    color = string.match(pnl.Theme[name .. "Color"] or "white","^[a-zA-Z]*")

    return pnl.Theme["Raw" .. name .. "Color"] or tbl[name .. "Color"][color] or tbl[name .. "Color"][default]
end

/*

    Main Theme System

*/

function RiceUI.RefreshTheme(pnl)
    local theme = pnl.Theme
    if theme.ThemeName == nil then return end

    pnl.Paint = RiceUI.GetTheme(theme.ThemeName)[theme.ThemeType]
end

function RiceUI.ApplyTheme(pnl, theme)
    if pnl.NoGTheme then return end

    if theme then
        if pnl.ProcessID == nil then return end

        pnl.Theme = pnl.Theme or {}
        pnl.ThemeMeta = RiceUI.GetTheme(theme.ThemeName)

        RL.table.Inherit(pnl.Theme, {
            ThemeType = pnl.ProcessID
        })

        RL.table.Inherit(pnl.Theme, theme, {
            ThemeName = 1,
            Color = 1,
            TextColor = 1
        })

        RiceUI.RefreshTheme(pnl)
        RiceUI.DoThemeProcess(pnl)
    end

    for _, v in ipairs(pnl:GetChildren()) do
        RiceUI.ApplyTheme(v, pnl.Theme)
    end
end

/*

    Theme Process

*/

RiceUI.ThemeProcess = {}

function RiceUI.DoThemeProcess(pnl)
    local ProcessSet = RiceUI.ThemeProcess[pnl.ProcessID]

    if ProcessSet == nil then return end

    for _,v in ipairs(ProcessSet) do
        v(pnl)
    end
end

function RiceUI.DefineThemeProcess(name,data)
    RiceUI.ThemeProcess[name] = RiceUI.ThemeProcess[name] or {}

    table.insert(RiceUI.ThemeProcess[name],data)
end

RL.IncludeDir("riceui/themeprocess",true)