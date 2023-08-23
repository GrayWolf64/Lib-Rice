RL.URLMaterial = {}
local MAT_DIR = "ricelib/materials/"
local MANIFEST = MAT_DIR .. "manifest.json"
file.CreateDir(MAT_DIR)
if not file.Exists(MANIFEST, "DATA") then file.Write(MANIFEST, "[]") end

if SERVER then
    util.AddNetworkString"RiceLib_SendMaterial"
    util.AddNetworkString"RiceLib_SendMaterials"

    local function createURLMaterial(name, url)
        local oldContent = util.JSONToTable(file.Read(MANIFEST, "DATA"))
        file.Write(MANIFEST, table.insert(oldContent, {name = name, url = url}))

        net.Start"RiceLib_SendMaterial"
        net.WriteString(name)
        net.WriteString(url)
        net.Broadcast()
    end

    gameevent.Listen("player_connect")
    hook.Add("player_connect", "RiceLib_SendURLMaterials", function(data)
        if data.bot == 1 then return end
        net.Start"RiceLib_SendMaterials"
        net.WriteString(file.Read(MANIFEST, "DATA"))
        net.Send(Entity(data.index + 1))
    end)

    RL.URLMaterial.Create = createURLMaterial
else
    local matCache = matCache or {}

    local function downloadImage(name, url)
        local imageFile = MAT_DIR .. name .. ".png"
        if file.Exists(imageFile, "DATA") then return end

        http.Fetch(url, function(body)
            file.Write(imageFile, body)
        end)
    end

    net.Receive("RiceLib_SendMaterial", function()
        downloadImage(net.ReadString(), net.ReadString())
    end)

    net.Receive("RiceLib_SendMaterials", function()
        local manifest = net.ReadString()
        file.Write(MANIFEST, manifest)

        for _, v in pairs(util.JSONToTable(manifest)) do
            if file.Exists(MAT_DIR .. v.name .. ".png", "DATA") then continue end
            downloadImage(v.name, v.url)
        end
    end)

    RL.URLMaterial.Reload = function()
        for _, v in pairs(util.JSONToTable(file.Read(MANIFEST, "DATA"))) do
            http.Fetch(v.url, function(body)
                file.Write(MAT_DIR .. v.name .. ".png", body)
            end)
        end
    end

    RL.URLMaterial.Get = function(name, url)
        local imageFile = MAT_DIR .. name .. ".png"
        if file.Exists(imageFile, "DATA") then
            if matCache[name] then return matCache[name] end

            local material = Material("data/" .. imageFile, "smooth")
            matCache[name] = material

            return material
        end

        downloadImage(name, url)
        if not file.Exists(imageFile, "DATA") then return Material"models/error/green" end
    end

    RL.URLMaterial.Create = downloadImage
end