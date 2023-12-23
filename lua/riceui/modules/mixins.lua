local mixins = mixins or {}

function RiceUI.ApplyMixins(self)
    for name, func in pairs(mixins) do
        if istable(func) then
            if func[self.ProcessID] then
                self:GetTable()[name] = func
            end
        else
            self:GetTable()[name] = func
        end
    end
end

function RiceUI.DefineMixin(name, data)
    mixins[name] = data
end

RiceUI.DefineMixin("RiceUI_GetRoot", function(self)
    return RiceLib.VGUI.GetRoot(self)
end)

RiceUI.DefineMixin("GetElementValue", function(self, element)
    return self.riceui_elements[element]:GetValue()
end)

RiceUI.DefineMixin("GetElement", function(self, element)
    return self.riceui_elements[element]
end)

RiceUI.DefineMixin("RiceUI_GetColor", function(self, ...)
    local args = {...}
    if istable(args[1]) then args = args[1] end

    if self.Colors == nil then return end

    local color_default = Color(150, 0, 255)
    local color = self.Colors[self.Theme.Color or "white"]
    if color == nil then return color_default end

    for _, path in ipairs(args) do
        if color[path] == nil then return color_default end

        color = color[path]
    end

    return color
end)

RiceLib.IncludeDir("riceui/mixins")