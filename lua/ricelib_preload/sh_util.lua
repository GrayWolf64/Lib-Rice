RL.Util = {}

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

function RL.Util.IsHoliday()
    return is_holiday
end

function RL.Util.IsWeekend()
    return os.date"%w" == 0 or os.date"%w" == 6
end

local function load_files(target, dir)
    if not target or not dir then return end
    local files = file.Find(dir .. "/*", "LUA")

    for _, f in ipairs(files) do
        local path_name = f:StripExtension()
        local include_ret = include(dir .. "/" .. f)

        AddCSLuaFile(dir .. "/" .. f)

        if isfunction(target) then
            loader(path_name, include_ret)
        elseif istable(target) then
            target[path_name] = include_ret
        end
    end
end

function RL.IO.LoadFiles(tbl, dir)
    load_files(tbl, dir)
end

function RL.IO.LoadFilesRaw(loader, dir)
    load_files(loader, dir)
end

function RL.RunFromTable(tbl, name, ...)
    return tbl[name](...)
end