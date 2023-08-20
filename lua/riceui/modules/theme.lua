RiceUI = RiceUI or {}

--- Utility functions to help with themes
-- @section Util

--- Gets a named Theme
-- @param name Name of the Theme to obtain
-- @return table Theme
function RiceUI.GetTheme(name) return RiceUI.Theme[name] end

function RiceUI.GetColor(tab, self, name, default)
    name = name or ""
    default = default or "white1"

    return self.Theme["Raw" .. name .. "Color"] or tab[name .. "Color"][self.Theme.Color] or tab[name .. "Color"][default]
end

function RiceUI.GetColorBase(tab, self, name, default)
    name = name or ""
    default = default or "white"
    color = string.match(self.Theme.Color or "white", "^[a-zA-Z]*")

    return self.Theme["Raw" .. name .. "Color"] or tab[name .. "Color"][color] or tab[name .. "Color"][default]
end

function RiceUI.GetShadowAlpha(tab, self)
    color = string.match(self.Theme["Color"] or "white","^[a-zA-Z]*")

    return self.Theme.ShadowAlpha or tab.ShadowAlpha[color] or 50
end

--- `Main Theme System` related
-- @section MainThemeSystem

function RiceUI.RefreshTheme(self)
    local theme = self.Theme
    if theme.ThemeName == nil then return end

    self.Paint = RiceUI.GetTheme(theme.ThemeName)[theme.ThemeType]
end

function RiceUI.ApplyTheme(self, theme)
    if self.NoGTheme then return end

    if (theme ~= nil and theme.NT) or (self.Theme ~= nil and self.Theme.NT) then
        RiceUI.ThemeNT.ApplyTheme(self, theme)

        return
    end

    if theme then
        if self.ProcessID == nil then return end

        self.Theme = self.Theme or {}
        self.ThemeMeta = RiceUI.GetTheme(theme.ThemeName)
        self.Colors = RiceUI.GetTheme(theme.ThemeName).Colors

        RL.table.Inherit(self.Theme, {
            ThemeType = self.Theme.TypeOverride or self.ProcessID
        }, RiceUI.ThemeParamaBlacklist)

        RL.table.Inherit(self.Theme, theme, {
            ThemeName = 1,
            Color = (not self.Theme.ColorOverride) or 1,
            TextColor = 1
        }, RiceUI.ThemeParamaBlacklist)

        RiceUI.RefreshTheme(self)
        RiceUI.DoThemeProcess(self)
    end

    self.Colors = RiceUI.GetTheme(self.Theme.ThemeName).Colors

    for _, v in ipairs(self:GetChildren()) do
        RiceUI.ApplyTheme(v, self.Theme)
    end
end

--- `Theme Process` related helpers
-- @section ThemeProcess

RiceUI.ThemeProcess = {}

function RiceUI.DoThemeProcess(self)
    local ProcessSet = RiceUI.ThemeProcess[self.ProcessID]

    if ProcessSet == nil then return end

    for _,v in ipairs(ProcessSet) do
        v(self)
    end
end

function RiceUI.DefineThemeProcess(name, data)
    RiceUI.ThemeProcess[name] = RiceUI.ThemeProcess[name] or {}

    table.insert(RiceUI.ThemeProcess[name], data)
end

RL.IncludeDir("riceui/themeprocess", true)

RiceUI.ThemeParamaBlacklist = {}

function RiceUI.AddThemeParamaBlacklist(name)
    RiceUI.ThemeParamaBlacklist[name] = true
end

RL.IncludeDir("riceui/themeprocess_parmablacklist", true)

--- Themes Loader
-- @section ThemesLoader

RiceUI.Theme = {}
RL.Functions.LoadFiles(RiceUI.Theme, "riceui/theme")

for k, v in pairs(RiceUI.Theme) do
    if not isfunction(v.OnLoaded) then continue end
    v.OnLoaded()
end

--- Themes NT
-- DEPRECATED
-- Some color feature used in old Theme System
-- @section ThemesNT

RiceUI.ThemeNT = {}
RiceUI.ThemeNT.Themes = {}

function RiceUI.ThemeNT.DefineColors(ThemeName, Colors)
    RiceUI.ThemeNT.Themes[ThemeName].Colors = Colors
end

function RiceUI.ThemeNT.DefineStyle(ThemeName, ElementID, Styles)
    RiceUI.ThemeNT.Themes[ThemeName][ElementID] = Styles
end

function RiceUI.ThemeNT.LoadThemes()
    local path

    for _, themeName in pairs(RL.Files.GetDir("riceui/theme", "LUA")) do
        RiceUI.ThemeNT.Themes[themeName] = {}
        RiceUI.ThemeNT.Themes[themeName].Styles = {}

        path = "riceui/theme/" .. themeName

        for _, fileName in pairs(RL.Files.GetAll(path, "LUA")) do
            include(path .. "/" .. fileName)
        end
    end
end

function RiceUI.ThemeNT.RefreshTheme(self)
    local theme = self.Theme

    print(RiceUI.ThemeNT.Themes[theme.ThemeName][self.ProcessID][theme.Style or "Default"])
    print(theme.ThemeName,self.ProcessID,theme.Style or "Default")

    self.Paint = RiceUI.ThemeNT.Themes[theme.ThemeName][self.ProcessID][theme.Style or "Default"]
end

function RiceUI.ThemeNT.ApplyTheme(self, theme)
    if self.ProcessID == nil then return end

    self.Theme = self.Theme or {}

    RL.table.Inherit(self.Theme, theme, {
        ThemeName = 1,
        Color = 1
    }, RiceUI.ThemeParamaBlacklist)

    self.ThemeColors = RiceUI.ThemeNT.Themes[self.Theme.Color].Colors

    RiceUI.ThemeNT.RefreshTheme(self)

    for _, v in pairs(self:GetChildren()) do
        RiceUI.ThemeNT.ApplyTheme(v, self.Theme)
    end
end

RiceUI.ThemeNT.LoadThemes()