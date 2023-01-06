function RL.Functions.LoadFiles(tbl,dir)
    if !tbl then return end
    local files,_ = file.Find(dir.."/*","LUA")

    for _,file in ipairs(files) do
        AddCSLuaFile(dir .."/".. file)

        tbl[string.StripExtension(file)] = include(dir .."/".. file)
    end
end

function RL.Functions.LoadFilesRaw(loader,dir)
    if !loader then return end
    local files,_ = file.Find(dir.."/*","LUA")

    for _,file in ipairs(files) do
        AddCSLuaFile(dir .."/".. file)

        loader(string.StripExtension(file),include(dir .."/".. file))
    end
end

function RL.RunFromTable(tbl,name,...) return tbl[name](...) end