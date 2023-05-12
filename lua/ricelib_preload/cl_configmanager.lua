RL.Config = RL.Config or {}
RL.Config.Data = {}

function RL.Config.LoadConfig(Config,Name,default)
    local root = "ricelib/settings/"..Config
    local dir = "ricelib/settings/"..Config.."/"..Name..".json"

    if file.Exists(root,"DATA") and file.Exists(dir,"DATA") then
        return util.JSONToTable(file.Read(dir))
    else
        file.CreateDir(root)
        file.Write(dir,util.TableToJSON(default,true) or "")

        return {}
    end
end

function RL.Config.SaveConfig(Config,Name,tbl)
    dir = "ricelib/settings/"..Config.."/"..Name..".json"

    file.Write(dir,util.TableToJSON(tbl,true))
end