function RiceUI.SmoothController(time)
    local controller = {
        time = time
    }

    controller.valStart, controller.oldVal, controller.newVal = 0, -1, -1
    controller.time = controller.time or 0.25

    return controller
end

function RiceUI.Smooth(controller, val)
    if controller.oldVal == -1 and controller.newVal == -1 then
        controller.oldVal = val
        controller.newVal = val
    end

    local valStart = controller.valStart
    local oldVal = controller.oldVal
    local newVal = controller.newVal
    local time = controller.time

    local smoothVal = Lerp( math.ease.OutExpo((SysTime() - valStart) / time) , oldVal, newVal )

    if newVal ~= val then
        if smoothVal ~= val then
            controller.newVal = smoothVal
        end

        controller.oldVal = newVal
        controller.valStart = SysTime()
        controller.newVal = val
    end

    return smoothVal
end

function RiceUI.MergeData(panel, data)
    panel.riceui_data = data

    table.Merge(panel:GetTable(), data)
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

function RiceUI.HoverAlpha(panel, speed)
    if not panel.HoverAlpha then
        panel.HoverAlpha = 0
    end

    if panel:IsHovered() then
        panel.HoverAlpha = math.min(panel.HoverAlpha + speed * (RealFrameTime() * 100), 255)
    else
        panel.HoverAlpha = math.max(panel.HoverAlpha - speed * (RealFrameTime() * 100), 0)
    end

    return panel.HoverAlpha
end

function RiceUI.HoverAlphaEase(panel, speed)
    RiceUI.HoverAlpha(panel, speed)

    return math.ease.InOutCubic(panel.HoverAlpha / 255) * 255
end

RiceUI.AlphaPercent = function(color, percent) return ColorAlpha(color, 255 * percent) end

-- Web Images are temporarily stored and clear in each session
RiceLib.FS.Iterator("riceui/web_image", "DATA", function(path)
    file.Delete("riceui/web_image/" .. path)
end)
function RiceUI.GetWebImage(url, httpFunc)
    if url == nil then return end
    local dir = "riceui/web_image/"

    if file.Exists(dir .. util.SHA256(url) .. ".png", "DATA") then
        return Material("data/" .. dir .. util.SHA256(url) .. ".png", "smooth")
    else
        http.Fetch(url, function(body)
            file.Write(dir .. util.SHA256(url) .. ".png", body)

            if not isfunction(httpFunc) then return end
            httpFunc(Material("data/" .. dir .. util.SHA256(url) .. ".png", "smooth"))
        end)
    end
end