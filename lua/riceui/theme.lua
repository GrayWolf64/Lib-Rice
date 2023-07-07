RiceUI = RiceUI or {}

--[[

    Utils

]]--

function RiceUI.GetTheme(name) return RiceUI.Theme[name] end

function RiceUI.GetColor(tbl,pnl,name,default)
    name = name or ""
    default = default or "white1"

    return pnl.Theme["Raw" .. name .. "Color"] or tbl[name .. "Color"][pnl.Theme.Color] or tbl[name .. "Color"][default]
end

function RiceUI.GetColorBase(tbl,pnl,name,default)
    name = name or ""
    default = default or "white"
    color = string.match(pnl.Theme.Color or "white","^[a-zA-Z]*")

    return pnl.Theme["Raw" .. name .. "Color"] or tbl[name .. "Color"][color] or tbl[name .. "Color"][default]
end

function RiceUI.GetShadowAlpha(tbl,pnl)
    color = string.match(pnl.Theme["Color"] or "white","^[a-zA-Z]*")

    return pnl.Theme["ShadowAlpha"] or tbl["ShadowAlpha"][color] or 50
end

--[[

    Main Theme System

]]--

function RiceUI.RefreshTheme(pnl)
    local theme = pnl.Theme
    if theme.ThemeName == nil then return end

    pnl.Paint = RiceUI.GetTheme(theme.ThemeName)[theme.ThemeType]
end

function RiceUI.ApplyTheme(pnl, theme)
    if pnl.NoGTheme then return end

    if (theme ~= nil and theme.NT) or (pnl.Theme ~= nil and pnl.Theme.NT) then
        RiceUI.ThemeNT.ApplyTheme(pnl, theme)

        return
    end

    if theme then
        if pnl.ProcessID == nil then return end

        pnl.Theme = pnl.Theme or {}
        pnl.ThemeMeta = RiceUI.GetTheme(theme.ThemeName)
        pnl.Colors = RiceUI.GetTheme(theme.ThemeName).Colors

        RL.table.Inherit(pnl.Theme, {
            ThemeType = pnl.Theme.TypeOverride or pnl.ProcessID
        }, RiceUI.ThemeParamaBlacklist)

        RL.table.Inherit(pnl.Theme, theme, {
            ThemeName = 1,
            Color = (not pnl.Theme.ColorOverride) or 1,
            TextColor = 1
        }, RiceUI.ThemeParamaBlacklist)

        RiceUI.RefreshTheme(pnl)
        RiceUI.DoThemeProcess(pnl)
    end

    for _, v in ipairs(pnl:GetChildren()) do
        RiceUI.ApplyTheme(v, pnl.Theme)
    end
end

--[[

    Theme Process

]]--

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

RiceUI.ThemeParamaBlacklist = {}

function RiceUI.AddThemeParamaBlacklist(name)
    RiceUI.ThemeParamaBlacklist[name] = true
end

RL.IncludeDir("riceui/themeprocess_parmablacklist",true)

--[[

    Themes loader

]]--

RiceUI.Theme = {}
RL.Functions.LoadFiles(RiceUI.Theme, "riceui/theme")

for k, v in pairs(RiceUI.Theme) do
    if not isfunction(v.OnLoaded) then continue end
    v.OnLoaded()
end

--[[

    Themes NT

    Currently abandoned 
    Some color feature used in old Theme System

]]--

RiceUI.ThemeNT = {}
RiceUI.ThemeNT.Themes = {}

function RiceUI.ThemeNT.DefineColors(ThemeName, Colors)
    RiceUI.ThemeNT.Themes[ThemeName].Colors = Colors
end

function RiceUI.ThemeNT.DefineStyle(ThemeName, ElementID, Styles)
    RiceUI.ThemeNT.Themes[ThemeName][ElementID] = Styles
end

function RiceUI.ThemeNT.LoadThemes()
    local path = ""

    for _, themeName in ipairs(RL.Files.GetDir("riceui/theme", "LUA")) do
        RiceUI.ThemeNT.Themes[themeName] = {}
        RiceUI.ThemeNT.Themes[themeName].Styles = {}

        path = "riceui/theme/" .. themeName

        for _, fileName in pairs(RL.Files.GetAll(path, "LUA")) do
            include(path .. "/" .. fileName)
        end
    end
end

function RiceUI.ThemeNT.RefreshTheme(pnl)
    local theme = pnl.Theme

    print(RiceUI.ThemeNT.Themes[theme.ThemeName][pnl.ProcessID][theme.Style or "Default"])
    print(theme.ThemeName,pnl.ProcessID,theme.Style or "Default")

    pnl.Paint = RiceUI.ThemeNT.Themes[theme.ThemeName][pnl.ProcessID][theme.Style or "Default"]
end

function RiceUI.ThemeNT.ApplyTheme(self, theme)
    if pnl.ProcessID == nil then return end

    pnl.Theme = pnl.Theme or {}

    RL.table.Inherit(pnl.Theme, theme, {
        ThemeName = 1,
        Color = 1
    }, RiceUI.ThemeParamaBlacklist)

    pnl.ThemeColors = RiceUI.ThemeNT.Themes[pnl.Theme.Color].Colors

    RiceUI.ThemeNT.RefreshTheme(pnl)

    for _, v in ipairs(pnl:GetChildren()) do
        RiceUI.ThemeNT.ApplyTheme(v, pnl.Theme)
    end
end

RiceUI.ThemeNT.LoadThemes()