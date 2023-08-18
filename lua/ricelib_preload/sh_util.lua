RL.Util = {}

local today
local isHoliday = false

local function updateHoliday()
    if today ~= nil and os.date("%d") == today then return end

    http.Fetch("http://timor.tech/api/holiday/info/" .. os.date("%Y-%m-%d"), function(body)
        local data = util.JSONToTable(body)

        today = os.date("%d")
        isHoliday = ( data.holiday ~= nil )
    end)
end

timer.Create("RL.Util.UpdateHoliday", 1, 0, updateHoliday)

function RL.Util.IsHoliday()
    return isHoliday
end

function RL.Util.IsWeekend()
    return os.date("%w") == 0 or os.date("%w") == 6
end