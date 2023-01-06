local function main(panel,data)
    if data.Callback then data.callback(panel,data) end
    if data.Resize then panel:SizeToContents() end
end

return main