RiceLib.Cache.RiceUI_Mixins = RiceLib.Cache.RiceUI_Mixins or {}
local Mixins = RiceLib.Cache.RiceUI_Mixins

function RiceUI.ApplyMixins(self)
    local panelTable = self:GetTable()

    for name, func in pairs(Mixins) do
        if istable(func) then
            if func[self.ProcessID] then
                panelTable[name] = func
            end
        else
            panelTable[name] = func
        end
    end
end

function RiceUI.DefineMixin(name, data)
    Mixins[name] = data
end

RiceUI.DefineMixin("RiceUI_GetRoot", function(self)
    return RiceLib.VGUI.GetRoot(self)
end)

RiceUI.DefineMixin("RiceUI_GetRootPanel", function(self)
    return self.RiceUI_Root
end)

RiceUI.DefineMixin("GetElementValue", function(self, element)
    if not self.riceui_elements then return end

    return self.riceui_elements[element]:GetValue()
end)

RiceUI.DefineMixin("GetElement", function(self, element)
    if self.HasCanvas and IsValid(self.Canvas) then self = self.Canvas end

    if not self.riceui_elements then return end

    return self.riceui_elements[element]
end)

local function getColorOverride(args, color, useColorScheme, colorTheme)
    if useColorScheme then
        color = color[colorTheme]

        if color == nil then return end

        for _, path in ipairs(args) do
            if color[path] == nil then return end

            color = color[path]
        end
    else
        for _, path in ipairs(args) do
            if color[path] == nil then return end

            color = color[path]
        end
    end

    return color
end

RiceUI.DefineMixin("RiceUI_GetColor", function(self, ...)
    local args = {...}
    if istable(args[1]) then args = args[1] end

    if self.Colors == nil then return end

    local colorTheme = "white"
    if self.IsThemeNT then
        colorTheme = self.ThemeNT_Color or "white"

        if self.ThemeNT.ColorOverrides then
            local colorOverride = getColorOverride(args, self.ThemeNT.ColorOverrides, self.ThemeNT.ColorOverridesUseScheme, colorTheme)

            if colorOverride then return colorOverride end
        end
    else
        colorTheme = self.Theme.Color or "white"
    end

    local color_default = Color(150, 0, 255)
    local color = self.Colors[colorTheme]
    if color == nil then return color_default end

    for _, path in ipairs(args) do
        if color[path] == nil then return color_default end

        color = color[path]
    end

    return color
end)

RiceLib.IncludeDir("riceui/mixins")