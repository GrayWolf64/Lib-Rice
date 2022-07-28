if SERVER then
    RiceLib_Materials = {}

    util.AddNetworkString("RiceLib_SendMaterial")
    util.AddNetworkString("RiceLib_SendMaterials")

    file.CreateDir("RiceLib/Materials")

    function RL_URLMaterial_Create(name,url)
        if not file.Exists("RiceLib/Materials/"..name..".txt","DATA") then
            table.insert(RiceLib_Materials,{name,url})
        end
        
        file.Write("RiceLib/Materials/"..name..".txt",url)

        net.Start("RiceLib_SendMaterial")
        net.WriteString(name)
        net.WriteString(url)
        net.Broadcast()
    end

    net.Receive("RiceLib_SendMaterials",function(len,ply)
        net.Start("RiceLib_SendMaterials")
        net.WriteTable(RiceLib_Materials)
        net.Send(ply)
    end)

    local files = file.Find("RiceLib/Materials/*.txt","DATA")

    for _,v in ipairs(files) do
        local name = string.StripExtension(v)
        local url = file.Read("RiceLib/Materials/"..v)

        table.insert(RiceLib_Materials,{name,url})
    end
else
    file.CreateDir("RiceLib/Materials")

    net.Receive("RiceLib_SendMaterial",function()
        RL_URLMaterial_Create(net.ReadString(),net.ReadString())
    end)

    net.Receive("RiceLib_SendMaterials",function()
        RL_URLMaterial_Create(net.ReadString(),net.ReadString())
    end)

    function RL_URLMaterial_Create(name,url)
        file.Write("RiceLib/Materials/"..name..".txt",url)

        http.Fetch(url,function(body)
            file.Write("RiceLib/Materials/"..name..".png",body)
        end)
    end

    function RL_URLMaterial_Reload()
        local files = file.Find("RiceLib/Materials/*.txt","DATA")

        for _,v in ipairs(files) do
            http.Fetch(file.Read("RiceLib/Materials/"..v,"DATA"),function(body)
                file.Write("RiceLib/Materials/"..string.StripExtension(v)..".png",body)
            end)
        end
    end

    function RL_URLMaterial(mat)
        return Material("data/RiceLib/Materials/"..mat..".png") or Material("models/error/green")
    end

    net.Receive("RiceLib_SendMaterials",function(len,ply)
        local files = net.ReadTable()

        for _,v in ipairs(files) do
            if file.Exists("RiceLib/Materials/"..v[1]..".png","DATA") then continue elseif file.Exists("RiceLib/Materials/"..v[1]..".txt","DATA") then
                http.Fetch(v[2],function(body)
                    file.Write("RiceLib/Materials/"..v[1]..".png",body)
                end)
            else
                RL_URLMaterial_Create(v[1],v[2])
            end
        end
    end)

    hook.Add("InitPostEntity","RiceLib_SendMaterials",function()
        net.Start("RiceLib_SendMaterials")
        net.SendToServer()
    end)
end