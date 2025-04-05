RiceLib.URLMaterial = {}

local materialsPath = "ricelib/materials/"
local cache = {}
local queue = {}

local downloading = Material("vgui/alpha-back.vmt", "smooth")
local downloadFailed = Material("vgui/avatar_default.vmt", "smooth")
function RiceLib.URLMaterial.Get(id, url, expire, callback)
    local hash = util.SHA256(url)
    local filePath = materialsPath .. hash .. ".png"
    local fileExists = file.Exists(filePath, "DATA")

    if cache[id] and fileExists then
        return cache[id]
    end

    if fileExists and os.time() - file.Time(filePath, "DATA") < 3600 then
        cache[id] = Material("data/" .. filePath, "smooth")

        return cache[id]
    end

    if queue[hash] then
        return downloading, true
    end

    queue[hash] = {
        URL = url,
        ID = id,
        Retrys = 0,
        Fetching = false,
        Callback = callback
    }
end

timer.Create("RiceLib_URLMaterial_Queue", 0.1, 0, function()
    for hash, info in pairs(queue) do
        if info.Fetching then
            continue
        end

        info.Fetching = true

        http.Fetch(info.URL, function(body)
            if not body then
                info.Retrys = info.Retrys + 1

                if info.Retrys < 3 then
                    cache[info.ID] = downloadFailed
                    queue[hash] = nil

                    if info.Callback then
                        info.Callback(info.ID, info.URL, downloadFailed, true)
                    end

                    return
                end
            end

            file.Write(materialsPath .. hash .. ".png", body)

            local mat = Material("data/" .. materialsPath .. hash .. ".png", "smooth")

            cache[info.ID] = mat
            queue[hash] = nil

            if info.Callback then
                info.Callback(info.ID, info.URL, mat)
            end
        end)
    end
end)