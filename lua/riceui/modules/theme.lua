--- Theme system
-- @script theme
-- @author RiceMCUT, GrayWolf

local themes = themes or {}
local themes_nt = themes_nt or {}
local theme_processes = theme_processes or {}
local parama_blacklist = parama_blacklist or {}

function get_theme(name) return themes[name] end

function RiceUI.GetColor(tab, self, name, default)
    name = name or ""
    default = default or "white1"

    return self.Theme["Raw" .. name .. "Color"] or tab[name .. "Color"][self.Theme.Color] or tab[name .. "Color"][default]
end

local function match_color(str) return str:match"^[a-zA-Z]*" end

function get_color_base(tab, self, name, default)
    name = name or ""
    default = default or "white"
    color = match_color(self.Theme.Color or "white")

    return self.Theme["Raw" .. name .. "Color"] or tab[name .. "Color"][color] or tab[name .. "Color"][default]
end

function RiceUI.GetShadowAlpha(tab, self)
    color = match_color(self.Theme.Color or "white")

    return self.Theme.ShadowAlpha or tab.ShadowAlpha[color] or 50
end

function refresh_theme(self)
    local theme = self.Theme
    if theme.ThemeName == nil then return end

    self.Paint = get_theme(theme.ThemeName)[theme.ThemeType]
end

local function thement_refresh_theme(self)
    local theme = self.Theme

    print(themes_nt[theme.ThemeName][self.ProcessID][theme.Style or "Default"])
    print(theme.ThemeName, self.ProcessID, theme.Style or "Default")

    self.Paint = themes_nt[theme.ThemeName][self.ProcessID][theme.Style or "Default"]
end

local function thement_apply_theme(self, theme)
    if self.ProcessID == nil then return end

    self.Theme = self.Theme or {}

    RiceLib.table.Inherit(self.Theme, theme, {
        ThemeName = 1,
        Color = 1
    }, parama_blacklist)

    self.ThemeColors = themes_nt[self.Theme.Color].Colors

    thement_refresh_theme(self)

    for _, v in pairs(self:GetChildren()) do
        thement_apply_theme(v, self.Theme)
    end
end

function do_theme_process(self)
    local process_set = theme_processes[self.ProcessID]

    if process_set == nil then return end

    for _, v in ipairs(process_set) do v(self) end
end

function apply_theme(self, theme)
    if self.NoGTheme then return end

    if (theme ~= nil and theme.NT) or (self.Theme ~= nil and self.Theme.NT) then
        thement_apply_theme(self, theme)

        return
    end

    if theme then
        if self.ProcessID == nil then return end

        self.Theme = self.Theme or {}
        self.ThemeMeta = get_theme(theme.ThemeName)
        self.Colors = get_theme(theme.ThemeName).Colors

        RiceLib.table.Inherit(self.Theme, {
            ThemeType = self.Theme.TypeOverride or self.ProcessID
        }, parama_blacklist)

        RiceLib.table.Inherit(self.Theme, theme, {
            ThemeName = 1,
            Color = (not self.Theme.ColorOverride) or 1,
            TextColor = 1
        }, parama_blacklist)

        refresh_theme(self)
        do_theme_process(self)
    end

    self.Colors = get_theme(self.Theme.ThemeName).Colors

    for _, v in ipairs(self:GetChildren()) do
        apply_theme(v, self.Theme)
    end
end

local function reload_themes()
    RiceLib.Util.LoadFiles(themes, "riceui/theme")
end

concommand.Add("riceui_theme", function()
    PrintTable(themes)
end)

function RiceUI.DefineThemeProcess(name, data)
    theme_processes[name] = theme_processes[name] or {}

    table.insert(theme_processes[name], data)
end

function RiceUI.AddThemeParamaBlacklist(name)
    parama_blacklist[name] = true
end

reload_themes()

for _, v in pairs(themes) do
    if not isfunction(v.OnLoaded) then continue end
    v.OnLoaded()
end

RiceUI.ThemeNT = RiceUI.ThemeNT or {}

function RiceUI.ThemeNT.DefineColors(theme_name, Colors)
    themes_nt[theme_name].Colors = Colors
end

function RiceUI.ThemeNT.DefineStyle(theme_name, ElementID, Styles)
    themes_nt[theme_name][ElementID] = Styles
end

local function reload_themes_nt()
    local dir, path = "riceui/theme/"

    for _, theme_name in pairs(RiceLib.FS.GetDir(dir, "LUA")) do
        themes_nt[theme_name] = {}
        themes_nt[theme_name].Styles = {}

        path = dir .. theme_name

        for _, file_name in pairs(RiceLib.FS.GetAll(path, "LUA")) do
            include(path .. "/" .. file_name)
        end
    end
end

reload_themes_nt()

RiceUI.DefineThemeProcess("Label", function(panel)
    panel:SetColor(get_color_base(panel.ThemeMeta, panel, "Text"))
end)

RiceUI.DefineThemeProcess("RL_Frame", function(panel)
    panel.Title:SetColor(get_color_base(panel.ThemeMeta, panel, "Text"))
end)

RiceUI.DefineThemeProcess("ScrollPanel", function(panel)
    panel:RefreshVBar()
end)

RiceUI.DefineThemeProcess("Switch", function(panel)
    panel.Color = get_color_base(panel.ThemeMeta, panel, "Focus")

    if not panel.Value then return end

    panel:SetColor(panel.Color)
end)

RiceUI.AddThemeParamaBlacklist("Shadow")
RiceUI.AddThemeParamaBlacklist("Blur")
RiceUI.AddThemeParamaBlacklist("Corner")

RiceUI.GetTheme = get_theme
RiceUI.GetColorBase = get_color_base
RiceUI.ThemeNT.RefreshTheme = thement_refresh_theme
RiceUI.RefreshTheme = refresh_theme
RiceUI.ThemeNT.ApplyTheme = thement_apply_theme
RiceUI.ApplyTheme = apply_theme
RiceUI.DoThemeProcess = do_theme_process

RiceUI.ThemeNT.LoadThemes = reload_themes_nt
RiceUI.ReloadThemes = reload_themes