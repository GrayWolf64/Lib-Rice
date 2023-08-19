RiceUI.DefineExtraFunction("RiceUI_GetColor", function(self, ... )
    local args = { ... }
    if istable(args[1]) then args = args[1] end

    if self.Colors == nil then return end

    local color = self.Colors[self.Theme.Color or "white"]
    if color == nil then return Color(150,0,255) end

    for _, path in ipairs(args) do
        if color[path] == nil then return Color(150,0,255) end

        color = color[path]
    end

    return color
end)