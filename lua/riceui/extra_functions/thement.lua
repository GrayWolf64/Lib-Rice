RiceUI.DefineExtraFunction("RiceUI_GetColor", function(self, ... )
    local args = { ... }
    if istable(args[1]) then args = args[1] end

    local color = self.Colors[self.Theme.Color]

    for _, path in ipairs(args) do
        color = color[path]
    end

    return color
end)