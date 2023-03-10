RL = RL or {}
RL.VGUI = RL.VGUI or {}
RL.VGUI.Anim = RL.VGUI.Anim or {}
RL.Language = RL.Language or {}
RL.Language.Words = RL.Language.Words or {}
RL.Functions = RL.Functions or {}
RL.Files = {}
file.CreateDir("ricelib/settings")

if SERVER then
    resource.AddWorkshop("2829757059")
end

for k, v in pairs({
    ["Message"] = Color(0, 255, 0),
    ["Message_Error"] = Color(255, 0, 0),
    ["Message_Warn"] = Color(255, 150, 0)
}) do
    RL[k] = function(msg)
        if string.StartWith(msg, "#") then
            msg = RL.Language.Get(string.sub(msg, 2)) or msg
        end

        if SERVER then
            color = Color(0, 150, 255)
        else
            color = Color(255, 255, 150)
        end

        MsgC(color, "[RiceLib] ")
        MsgC(v, msg .. "\n")
    end
end

for k, v in pairs({
    ["MessageAs"] = Color(0, 255, 0),
    ["Message_ErrorAs"] = Color(255, 0, 0),
    ["Message_WarnAs"] = Color(255, 150, 0)
}) do
    RL[k] = function(msg, name)
        if string.StartWith(msg, "#") then
            msg = RL.Language.Get(string.sub(msg, 2)) or msg
        end

        if SERVER then
            color = Color(0, 150, 255)
        else
            color = Color(255, 255, 150)
        end

        MsgC(color, "[" .. name .. "] ")
        MsgC(v, msg .. "\n")
    end
end

local function AddFile(File, directory, silence)
    local prefix = string.lower(string.Left(File, 3))
    silence = silence or RL.Debug or true

    if SERVER and prefix == "sv_" then
        include(directory .. File)

        if not silence then
            RL.Message("Server Load: " .. File)
        end
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)

            if not silence then
                RL.Message("Shared AddCS: " .. File)
            end
        end

        include(directory .. File)

        if not silence then
            RL.Message("Shared Load: " .. File)
        end
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)

            if not silence then
                RL.Message("Client AddCS: " .. File)
            end
        elseif CLIENT then
            include(directory .. File)

            if not silence then
                RL.Message("Client Load: " .. File)
            end
        end
    else
        AddCSLuaFile(directory .. File)
        include(directory .. File)

        if not silence then
            RL.Message("Load: " .. File)
        end
    end
end

function RL.IncludeDir(directory, silence, nosub, name)
    if not string.EndsWith(directory, "/") then
        directory = directory .. "/"
    end

    local files, directories = file.Find(directory .. "*", "LUA")
    silence = silence or RL.Debug or true

    for _, v in ipairs(files) do
        AddFile(v, directory, silence)
    end

    if nosub then
        if not silence then
            RL.Message("Done Loading: " .. name .. "\n")
        end

        return
    end

    for i, v in ipairs(directories) do
        if not silence then
            RL.Message("Loading Directory: " .. directory .. v)
        end

        RL.IncludeDir(directory .. v, silence)
        if silence then continue end

        if i == #directories then
            RL.Message("Done Loading Directory: " .. directory .. v)
        end
    end

    if not silence then
        RL.Message("Done Loading: " .. name .. "\n")
    end
end

local function AddFileAs(File, directory, name)
    local prefix = string.lower(string.Left(File, 3))

    if SERVER and prefix == "sv_" then
        include(directory .. File)
        RL.MessageAs("Server Load: " .. File, name)
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)
            RL.MessageAs("Shared AddCS: " .. File, name)
        end

        include(directory .. File)
        RL.MessageAs("Shared Load: " .. File, name)
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            RL.MessageAs("Client AddCS: " .. File, name)
        elseif CLIENT then
            include(directory .. File)
            RL.MessageAs("Client Load: " .. File, name)
        end
    else
        AddCSLuaFile(directory .. File)
        include(directory .. File)
        RL.MessageAs("Load: " .. File, name)
    end
end

function RL.IncludeDirAs(directory, name, nosub)
    if not string.EndsWith(directory, "/") then
        directory = directory .. "/"
    end

    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFileAs(v, directory, name)
    end

    if nosub then
        if not silence then
            RL.Message("Done Loading: " .. name .. "\n")
        end

        return
    end

    for i, v in ipairs(directories) do
        RL.MessageAs("Loading Directory: " .. directory .. v, name)
        RL.IncludeDirAs(directory .. v, name)

        if i == #directories then
            RL.MessageAs("Done Loading Directory: " .. directory .. v, name)
        end
    end

    RL.MessageAs("Done Loading\n", name)
end

if SERVER then
    function RL.AddCSFiles(directory, name, nosub)
        if not string.EndsWith(directory, "/") then
            directory = directory .. "/"
        end

        local files, directories = file.Find(directory .. "*", "LUA")

        for _, v in ipairs(files) do
            if name then
                RL.MessageAs("CSFiles: " .. directory .. v, name)
            end

            AddCSLuaFile(directory .. v)
        end

        if nosub then
            if name then
                RL.Message("Added CSFiles: " .. name .. "\n")
            end

            return
        end

        for _, v in ipairs(directories) do
            if name then
                RL.MessageAs("CSFiles Dir: " .. directory .. v, name)
            end

            RL.AddCSFiles(directory .. v, name)
        end

        if name then
            RL.Message("Added CSFiles: " .. name .. "\n")
        end
    end
end

function RL.Files.GetAll(dir, path)
    if not string.EndsWith(dir, "/") then
        dir = dir .. "/"
    end

    local files, _ = file.Find(dir .. "*", path)

    return files
end

function RL.Files.GetDir(dir, path)
    if not string.EndsWith(dir, "/") then
        dir = dir .. "/"
    end

    local _, ret_dir = file.Find(dir .. "*", path)

    return ret_dir
end

function RL.Files.Iterator(dir, path, iterator)
    if not string.EndsWith(dir, "/") then
        dir = dir .. "/"
    end

    for _, v in ipairs(RL.Files.GetAll(dir, path)) do
        iterator(v, dir, path)
    end
end

print("==================RL=================")
RL.IncludeDir("ricelib_preload")