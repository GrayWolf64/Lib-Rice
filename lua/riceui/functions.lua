RiceUI = RiceUI or {}

function RiceUI.Smooth_CreateController(controller,time)
    controller.valStart, controller.oldVal, controller.newVal = 0, -1, -1
    controller.time = controller.time or 0.25
end

function RiceUI.Smooth(controller,val)
    if ( controller.oldVal == -1 and controller.newVal == -1 ) then
        controller.oldVal = val
        controller.newVal = val
    end

    local valStart = controller.valStart
    local oldVal = controller.oldVal
    local newVal = controller.newVal
    local time = controller.time

    local smoothVal = Lerp( (SysTime() - valStart) / time , oldVal, newVal )

    if newVal ~= val then
        if ( smoothVal ~= val ) then
            controller.newVal = smoothVal
        end

        controller.oldVal = newVal
        controller.valStart = SysTime()
        controller.newVal = val
    end

    return smoothVal
end

function RiceUI.MergeData(pnl,data)
    pnl.RiceUI_Data = data

    table.Merge(pnl:GetTable(),data)
end

function RiceUI.ProcessData(data)
    local newData = table.Copy(data)

    if data.Center then
        newData.Center = nil
        newData.center = true
    end

    if data.Dock then
        newData.dock = data.Dock
        newData.Dock = nil
    end

    newData.x = nil
    newData.y = nil

    return newData
end

function RiceUI.GetWebImage(url,httpFunc)
    if url == nil then return end

    if file.Exists("riceui/web_image/" .. util.SHA256(url) .. ".png","DATA") then
        return Material("data/riceui/web_image/" .. util.SHA256(url) .. ".png","smooth")
    else
        http.Fetch(url,function(body)
            file.Write("riceui/web_image/" .. util.SHA256(url) .. ".png",body)

            if isfunction(httpFunc) then
                httpFunc(Material("data/riceui/web_image/" .. util.SHA256(url) .. ".png","smooth"))
            end
        end)
    end
end

function RiceUI.HoverAlpha(pnl,Speed)
    if not pnl.HoverAlpha then
        pnl.HoverAlpha = 0
    end

    if pnl:IsHovered() then
        pnl.HoverAlpha = math.min(pnl.HoverAlpha + Speed * (RealFrameTime() * 100), 255)
    else
        pnl.HoverAlpha = math.max(pnl.HoverAlpha - Speed * (RealFrameTime() * 100), 0)
    end

    return pnl.HoverAlpha
end

function RiceUI.HoverAlphaEase(pnl,Speed)
    if not pnl.HoverAlpha then
        pnl.HoverAlpha = 0
    end

    if pnl:IsHovered() then
        pnl.HoverAlpha = math.min(pnl.HoverAlpha + Speed * (RealFrameTime() * 100), 255)
    else
        pnl.HoverAlpha = math.max(pnl.HoverAlpha - Speed * (RealFrameTime() * 100), 0)
    end

    return math.ease.InOutCubic(pnl.HoverAlpha / 255) * 255
end

function RiceUI.AlphaPercent(color, percent)
    return ColorAlpha(color, 255 * percent)
end