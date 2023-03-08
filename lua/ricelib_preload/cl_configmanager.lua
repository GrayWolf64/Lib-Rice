RL.Config = RL.Config or {}
RL.Config.Data = {}

function RL.Config.LoadConfig(Config,Name,tbl)
    local root = "ricelib/settings/"..Config
    local dir = "ricelib/settings/"..Config.."/"..Name..".json"

    if file.Exists(root,"DATA") then
        return util.JSONToTable(file.Read(dir))
    else
        file.CreateDir(root)
        file.Write(dir,"")

        return {}
    end
end

function RL.Config.SaveConfig(Config,Name,tbl)
    dir = "ricelib/settings/"..Config.."/"..Name..".json"

    file.Write(dir,util.TableToJSON(tbl,true))
end