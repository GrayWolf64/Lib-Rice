RiceLib.Util = {}

local today
local is_holiday = false

local function update_holiday()
    if today ~= nil and os.date"%d" == today then return end

    http.Fetch("http://timor.tech/api/holiday/info/" .. os.date"%Y-%m-%d", function(body)
        today = os.date("%d")
        is_holiday = (util.JSONToTable(body).holiday ~= nil)
    end)
end

timer.Create("ricelib_util_updateholiday", 60, 0, update_holiday)

function RiceLib.Util.IsHoliday()
    return is_holiday
end

function RiceLib.Util.IsWeekend()
    return os.date"%w" == 0 or os.date"%w" == 6
end

function RiceLib.Util.GetClosestEntity(pos, entities)
    local distance = math.huge
    local winner

    for _, ent in ipairs(entities) do
        local dist = ent:GetPos():DistToSqr(pos)
        if dist > distance then continue end

        distance = dist
        winner = ent
    end

    return winner
end

function RiceLib.RunFromTable(tbl, name, ...)
    return tbl[name](...)
end