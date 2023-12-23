RiceLib.URLMaterial = {}
local mat_dir  = "ricelib/materials/"
local manifest = mat_dir .. "manifest.json"
file.CreateDir(mat_dir)

if not file.Exists(manifest, "DATA") then
    file.Write(manifest, "[]")
end

if SERVER then
    util.AddNetworkString"ricelib_send_materials"

    gameevent.Listen("player_connect")
    hook.Add("player_connect", "RiceLibURLMaterialsDispatch", function(data)
        if data.bot == 1 then return end
        net.Start"ricelib_send_materials"
        net.WriteString(file.Read(manifest, "DATA"))
        net.Send(Entity(data.index + 1))
    end)

    RiceLib.URLMaterial.Create = function(name, url)
        net.Start"ricelib_send_materials"

        local oldContent = util.JSONToTable(file.Read(manifest, "DATA"))
        oldContent[#oldContent + 1] = {name = name, url = url}

        file.Write(manifest, util.TableToJSON(oldContent))

        net.WriteString(file.Read(manifest, "DATA"))
        net.Broadcast()
    end
else
    local function downloadImage(name, url)
        local imageFile = mat_dir .. name .. ".png"
        if file.Exists(imageFile, "DATA") then return end

        http.Fetch(url, function(body) file.Write(imageFile, body) end)
    end

    net.Receive("ricelib_send_materials", function()
        local manifest = net.ReadString()
        file.Write(manifest, manifest)

        for _, v in pairs(util.JSONToTable(manifest)) do
            if file.Exists(mat_dir .. v.name .. ".png", "DATA") then continue end
            downloadImage(v.name, v.url)
        end
    end)

    RiceLib.URLMaterial.Reload = function()
        for _, v in pairs(util.JSONToTable(file.Read(manifest, "DATA"))) do
            http.Fetch(v.url, function(body) file.Write(mat_dir .. v.name .. ".png", body) end)
        end
    end

    local mat_cache = mat_cache or {}
    RiceLib.URLMaterial.Get = function(name, url)
        local imageFile = mat_dir .. name .. ".png"
        if file.Exists(imageFile, "DATA") then
            if mat_cache[name] then return mat_cache[name] end

            mat_cache[name] = Material("data/" .. imageFile, "smooth")

            return mat_cache[name]
        end

        downloadImage(name, url)
        if not file.Exists(imageFile, "DATA") then return Material"models/error/green" end
    end

    RiceLib.URLMaterial.Create = downloadImage
end