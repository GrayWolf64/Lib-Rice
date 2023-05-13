local function main(panel,data)
    if data.DoClick then panel.DoClick = data.DoClick end
    if data.DoRightClick then panel.DoRightClick = data.DoRightClick end
end

return main