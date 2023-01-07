local function main(panel,data)
    if data.Callback then data.callback(panel,data) end
    if data.Resize and not data.Resize then panel:SetSize(data.w,data.h) end
end

return main