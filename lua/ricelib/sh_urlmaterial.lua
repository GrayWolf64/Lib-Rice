RL.URLMaterial = {}

if SERVER then
    RL.URLMaterial.Materials = {}
    util.AddNetworkString("RiceLib_SendMaterial")
    util.AddNetworkString("RiceLib_SendMaterials")
    file.CreateDir("RiceLib/Materials")

    function RL.URLMaterial.Create(name, url)
        if not file.Exists("RiceLib/Materials/" .. name .. ".txt", "DATA") then
            table.insert(RL.URLMaterial.Materials, {name, url})
        end

        file.Write("RiceLib/Materials/" .. name .. ".txt", url)
        net.Start("RiceLib_SendMaterial")
        net.WriteString(name)
        net.WriteString(url)
        net.Broadcast()
    end

    hook.Add("RL_ClientReady", "RL_SendURLMaterials", function(ply)
        net.Start("RiceLib_SendMaterials")
        net.WriteTable(RL.URLMaterial.Materials)
        net.Send(ply)
    end)

    local files = file.Find("RiceLib/Materials/*.txt", "DATA")

    for _, v in ipairs(files) do
        local name = string.StripExtension(v)
        local url = file.Read("RiceLib/Materials/" .. v)

        table.insert(RL.URLMaterial.Materials, {name, url})
    end
else
    file.CreateDir("RiceLib/Materials")

    net.Receive("RiceLib_SendMaterial", function()
        RL.URLMaterial.Create(net.ReadString(), net.ReadString())
    end)

    net.Receive("RiceLib_SendMaterials", function()
        RL.URLMaterial.Create(net.ReadString(), net.ReadString())
    end)

    function RL.URLMaterial.Create(name, url)
        file.Write("RiceLib/Materials/" .. name .. ".txt", url)

        http.Fetch(url, function(body)
            file.Write("RiceLib/Materials/" .. name .. ".png", body)
        end)
    end

    function RL.URLMaterial.Reload()
        local files = file.Find("RiceLib/Materials/*.txt", "DATA")

        for _, v in ipairs(files) do
            http.Fetch(file.Read("RiceLib/Materials/" .. v, "DATA"), function(body)
                file.Write("RiceLib/Materials/" .. string.StripExtension(v) .. ".png", body)
            end)
        end
    end

    RL.URLMaterial.Cache = {}
    function RL.URLMaterial.Get(mat, url)
        if file.Exists("RiceLib/Materials/" .. mat .. ".png", "DATA") then
            if RL.URLMaterial.Cache[mat] then
                return RL.URLMaterial.Cache[mat]
            end

            local material = Material("data/RiceLib/Materials/" .. mat .. ".png", "smooth")
            RL.URLMaterial.Cache[mat] = material

            return material
        end

        RL.URLMaterial.Create(mat, url)
        if file.Exists("RiceLib/Materials/" .. mat .. ".txt", "DATA") then return Material("models/error/green") end
    end

    net.Receive("RiceLib_SendMaterials", function(len, ply)
        local files = net.ReadTable()

        for _, v in ipairs(files) do
            if file.Exists("RiceLib/Materials/" .. v[1] .. ".png", "DATA") then
                continue
            elseif file.Exists("RiceLib/Materials/" .. v[1] .. ".txt", "DATA") then
                http.Fetch(v[2], function(body)
                    file.Write("RiceLib/Materials/" .. v[1] .. ".png", body)
                end)
            else
                RL.URLMaterial.Create(v[1], v[2])
            end
        end
    end)
end