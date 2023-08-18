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

    hook.Add("RL_ClientReady", "RL_SendURLMaterials", function(ply)
        net.Start"RiceLib_SendMaterials"
        net.WriteTable(urlMaterials)
        net.Send(ply)
    end)

    local files = file.Find(matDir .. "*.txt", "DATA")
    for _, v in pairs(files) do
        table.insert(urlMaterials, {name = v:StripExtension(), url = file.Read(matDir .. v)})
    end

    createURLMaterial("rl_logo", "https://sv.wolf109909.top:62500/f/ede41dd0da3e4c4dbb3d/?dl=1")

    RL.URLMaterial.Create = createURLMaterial
else
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
            createURLMaterial(v.name, v.url)
        end
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

    RL.URLMaterial.Create = createURLMaterial
    RL.URLMaterial.Reload = function()
        local files = file.Find(matDir .. "*.txt", "DATA")
        for _, v in pairs(files) do
            http.Fetch(file.Read(matDir .. v, "DATA"), function(body)
                file.Write(matDir .. v:StripExtension() .. ".png", body)
            end)
        end
    end

    local materialCache = materialCache or {}
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
end