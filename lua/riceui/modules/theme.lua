--- Theme system
-- @script theme
-- @author RiceMCUT, GrayWolf

local themes = themes or {}
local themes_nt = themes_nt or {}
local theme_processes = theme_processes or {}
local parama_blacklist = parama_blacklist or {}

local apply_theme_nt

local function get_theme(name) return themes[name] end

function RiceUI.GetColor(tab, self, name, default)
    name = name or ""
    default = default or "white1"

    return self.Theme["Raw" .. name .. "Color"] or tab[name .. "Color"][self.Theme.Color] or tab[name .. "Color"][default]
end

local function match_color(str) return str:match"^[a-zA-Z]*" end

local function get_color_base(tab, self, name, default)
    name = name or ""
    default = default or "white"
    local color = match_color(self.Theme.Color or "white")

    return self.Theme["Raw" .. name .. "Color"] or tab[name .. "Color"][color] or tab[name .. "Color"][default]
end

function RiceUI.GetShadowAlpha(tab, self)
    local color = match_color(self.Theme.Color or "white")

    return self.Theme.ShadowAlpha or tab.ShadowAlpha[color] or 50
end

local function refresh_theme(self)
    local theme = self.Theme
    if theme.ThemeName == nil then return end

    self.Paint = get_theme(theme.ThemeName)[theme.ThemeType]
end

local function do_theme_process(self)
    local process_set = theme_processes[self.ProcessID]

    if process_set == nil then return end

    for _, v in ipairs(process_set) do v(self) end
end

local function apply_theme(self, theme)
    if self.NoGTheme then return end
    if self.ThemeNT ~= nil and self.ThemeNT.Theme ~= nil then
        apply_theme_nt(self)

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

    if self.Theme.ThemeName == nil then return end
    if not self.Colors then self.Colors = get_theme(self.Theme.ThemeName).Colors end

    for _, v in ipairs(self:GetChildren()) do
        apply_theme(v, self.Theme)
    end
end

local function reload_themes()
    RiceLib.FS.LoadFiles(themes, "riceui/theme")
end

concommand.Add("riceui_themes", function()
    PrintTable(themes)
end)


-- MARK: ThemeProcess

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

RiceUI.DefineThemeProcess("Label", function(panel)
    if panel.IsThemeNT then
        panel:SetColor(panel:RiceUI_GetColor("Text", "Primary"))

        return
    end

    if not panel.ThemeMeta then return end
    panel:SetColor(get_color_base(panel.ThemeMeta, panel, "Text"))
end)

RiceUI.DefineThemeProcess("RL_Frame", function(panel)
    panel.Title:SetColor(get_color_base(panel.ThemeMeta, panel, "Text"))
end)

RiceUI.DefineThemeProcess("ScrollPanel", function(panel)
    panel:RefreshVBar()
end)

RiceUI.DefineThemeProcess("Switch", function(panel)
    if not panel.ThemeMeta then return end
    if not panel.Value then return end

    panel.Color = get_color_base(panel.ThemeMeta, panel, "Focus")
    panel:SetColor(panel.Color)
end)

RiceUI.AddThemeParamaBlacklist("Shadow")
RiceUI.AddThemeParamaBlacklist("Blur")
RiceUI.AddThemeParamaBlacklist("Corner")


RiceUI.GetTheme = get_theme
RiceUI.GetColorBase = get_color_base
RiceUI.RefreshTheme = refresh_theme
RiceUI.ApplyTheme = apply_theme
RiceUI.DoThemeProcess = do_theme_process

RiceUI.ReloadThemes = reload_themes


-- MARK: ThemeNT
-- ThemeNT

function apply_theme_nt(panel, inputTheme)
    if not panel.ThemeNT then
        panel.ThemeNT = {}
    end

    local theme = panel.ThemeNT

    if theme.Skip then return end

    if inputTheme then
        theme = RiceLib.table.Inherit(panel.ThemeNT, inputTheme, {
            Color = not theme.NoColorOverride
        }, {
            Class = true,
            Style = true,
            StyleSheet = true,
        })
    end

    inputTheme = inputTheme or theme

    local themeTable = themes_nt[theme.Theme]
    if not themeTable then
        RiceLib.Error(Format("Theme %s does not exists!", theme.Theme), "RiceUI ThemeNT")

        return
    end

    panel.IsThemeNT = true
    panel.ThemeNT_Color = theme.Color

    local class = theme.Class
    if not class then
        class = (panel.Theme or {ThemeType = nil}).ThemeType or panel.ProcessID

        theme.Class = class
    end

    local paintFunction = themeTable.Classes[class][theme.Style]
    if paintFunction then
        if not theme.StyleSheet then theme.StyleSheet = {} end

        panel.RiceUI_ThemeNT_Paint = paintFunction
        panel.Paint = function(self, w, h)
            self:RiceUI_ThemeNT_Paint(w, h, theme.StyleSheet)
        end
    end

    panel.Colors = themeTable.Colors or get_theme(themeTable.Base).Colors

    do_theme_process(panel)

    if theme.IgnoreChildren then return end
    for _, child in ipairs(panel:GetChildren()) do
        apply_theme_nt(child, inputTheme)
    end
end

local function parent_class(themeTable, class)
    local parentTheme, isNT = themeTable.Base, themeTable.BaseNT

    if isNT then
        return themes_nt[parentTheme].Classes[class]
    end

    return setmetatable({themes[parentTheme][class] ~= nil, themes[parentTheme][class]}, {
        __index = function(themeTable)
            if not themeTable[1] then return end

            return themeTable[2]
        end
    })
end

local function define_theme(theme, themeTable)
    RiceLib.table.Inherit(themeTable, {
        Base = "Modern",
        Classes = {},
        Colors = {}
    })

    setmetatable(themeTable.Classes, {
        __index = function(_, class)
            if not class then return "" end

            return parent_class(themeTable, class)
        end
    })

    themes_nt[theme] = themeTable
end

local function register_class(theme, class, data)
    data = table.Copy(data)

    if not data or not data.Default then
        RiceLib.Error(Format("Theme %s Class %s is missing Default style!", theme, class), "RiceUI ThemeNT")

        return
    end

    if not themes_nt[theme] then
        RiceLib.Error(Format("Theme %s is not defined!", theme), "RiceUI ThemeNT")

        return
    end

    themes_nt[theme].Classes[class] = setmetatable(data, {
        __index = function(themeTable, style)
            if style ~= nil then
                local baseTheme = themes_nt[theme].Base

                --RiceLib.Warn(Format("Theme %s Class %s is missing Style %s, fallback to Theme %s", theme, class, style, baseTheme), "RiceUI ThemeNT")

                local baseThemeStyle = themes_nt[baseTheme]

                if baseThemeStyle and baseThemeStyle.Classes[class] then
                    return baseThemeStyle.Classes[class][style]
                end
            end

            return themeTable.Default
        end
    })
end

local function reload_themes_nt()
    RiceLib.FS.DirIterator("riceui/theme", "LUA", function(dir)
        local path = "riceui/theme/" .. dir

        if not file.Exists(path .. "/main.lua", "LUA") then
            RiceLib.Error(Format("Theme at %s is missing main file!", path), "RiceUI ThemeNT")

            return
        end

        include(path .. "/main.lua")

        RiceLib.IncludeDir(path .. "/classes")
    end)
end

local DARKMODE = RiceLib.Config.Define("ricelib", "ThemeNT_DarkMode", {
    Type = "Bool",
    Default = false,
    Category = "Visual",
    DisplayName = "Darkmode"
})

RiceUI.ThemeNT = {
    DefineTheme = define_theme,
    ApplyTheme = apply_theme_nt,
    RegisterClass = register_class,

    IsDarkMode = function()
        return DARKMODE:GetValue()
    end,

    DefaultThemeColor = function()
        if DARKMODE:GetValue() then return "black" end

        return "white"
    end
}

reload_themes_nt()

concommand.Add("riceui_themes_nt", function()
    PrintTable(themes_nt)
end)