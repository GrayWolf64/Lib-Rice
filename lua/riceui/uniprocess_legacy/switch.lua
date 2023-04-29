local function main(panel,data)
    if data.OnValueChanged then panel.OnValueChanged = data.OnValueChanged end
end

return main