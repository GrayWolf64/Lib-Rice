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