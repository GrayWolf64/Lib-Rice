RL.URLMaterial = {}
local matDir = "RiceLib/Materials/"
file.CreateDir(matDir)

if SERVER then
    local urlMaterials = urlMaterials or {}
    util.AddNetworkString"RiceLib_SendMaterial"
    util.AddNetworkString"RiceLib_SendMaterials"

    local function createURLMaterial(name, url)
        if not file.Exists(matDir .. name .. ".txt", "DATA") then
            table.insert(urlMaterials, {name = name, url = url})
        end

        file.Write(matDir .. name .. ".txt", url)
        net.Start"RiceLib_SendMaterial"
        net.WriteString(name)
        net.WriteString(url)
        net.Broadcast()
    end

    gameevent.Listen("player_connect")
    hook.Add("player_connect", "RiceLib_SendURLMaterials", function(data)
        if data.bot == 1 then return end
        net.Start"RiceLib_SendMaterials"
        net.WriteTable(urlMaterials)
        net.Send(Entity(data.index + 1))
    end)

    local files = file.Find(matDir .. "*.txt", "DATA")
    for _, v in pairs(files) do
        table.insert(urlMaterials, {name = v:StripExtension(), url = file.Read(matDir .. v)})
    end

    RL.URLMaterial.Create = createURLMaterial
else
    local materialCache = materialCache or {}

    local function createURLMaterial(name, url)
        file.Write(matDir .. name .. ".txt", url)
        http.Fetch(url, function(body)
            file.Write(matDir .. name .. ".png", body)
        end)
    end

    net.Receive("RiceLib_SendMaterial", function()
        createURLMaterial(net.ReadString(), net.ReadString())
    end)

    net.Receive("RiceLib_SendMaterials", function()
        for _, v in pairs(net.ReadTable()) do
            if file.Exists(matDir .. v.name .. ".png", "DATA") then
                continue
            elseif file.Exists(matDir .. v.name .. ".txt", "DATA") then
                http.Fetch(v.url, function(body)
                    file.Write(matDir .. v.name .. ".png", body)
                end)
            else
                createURLMaterial(v.name, v.url)
            end
        end
    end)

    RL.URLMaterial.Reload = function()
        local files = file.Find(matDir .. "*.txt", "DATA")
        for _, v in pairs(files) do
            http.Fetch(file.Read(matDir .. v, "DATA"), function(body)
                file.Write(matDir .. v:StripExtension() .. ".png", body)
            end)
        end
    end

    RL.URLMaterial.Get = function(name, url)
        if file.Exists(matDir .. name .. ".png", "DATA") then
            if materialCache[name] then return materialCache[name] end

            local material = Material("data/" .. matDir .. name .. ".png", "smooth")
            materialCache[name] = material

            return material
        end

        createURLMaterial(name, url)
        if file.Exists(matDir .. name .. ".txt", "DATA") then return Material"models/error/green" end
    end

    RL.URLMaterial.Create = createURLMaterial
end