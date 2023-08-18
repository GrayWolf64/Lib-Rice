RL = RL or {}
RL.VGUI = RL.VGUI or {}
RL.VGUI.Anim = RL.VGUI.Anim or {}
RL.Language = RL.Language or {}
RL.Language.Words = RL.Language.Words or {}
RL.Functions = RL.Functions or {}
RL.Files = {}
file.CreateDir"ricelib/settings"

if SERVER then
    resource.AddWorkshop"2829757059"
end

local function mkMessageFunc(msgColor)
    return function(msg, name)
        if msg:StartsWith"#" then
            msg = RL.Language.Get(msg:sub(2)) or msg
        end

        local color = (SERVER and {Color(64, 158, 255)} or {Color(255, 255, 150)})[1]

        name = name or "RiceLib"

        MsgC(color, "[" .. name .. "] ", msgColor, msg .. "\n")
    end
end

local message = mkMessageFunc(Color(0, 255, 0))
RL.Message = message
RL.Message_Error = mkMessageFunc(Color(255, 75, 75))
RL.Message_Warn = mkMessageFunc(Color(255, 150, 0))

local function checkSlash(str)
    if not str:EndsWith("/") then return str .. "/" end
    return str
end

local function AddFile(File, directory, quiet)
    local prefix = File:Left(3):lower()
    quiet = quiet or RL.Debug or true

    if SERVER and prefix == "sv_" then
        include(directory .. File)

        if quiet then return end
        message("Server Load: " .. File)
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)

            if quiet then return end
            message("Shared AddCS: " .. File)
        end

        include(directory .. File)

        if quiet then return end
        message("Shared Load: " .. File)
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)

            if quiet then return end
            message("Client AddCS: " .. File)
        elseif CLIENT then
            include(directory .. File)

            if quiet then return end
            message("Client Load: " .. File)
        end
    else
        AddCSLuaFile(directory .. File)
        include(directory .. File)

        if quiet then return end
        message("Load: " .. File)
    end
end

local function includeDir(directory, quiet, nosub)
    directory = checkSlash(directory)

    local files, directories = file.Find(directory .. "*.lua", "LUA")
    quiet = quiet or RL.Debug or true

    for _, v in ipairs(files) do
        AddFile(v, directory, quiet)
    end

    if nosub then
        if quiet then return end
        message("Done Loading: " .. directory)

        return
    end

    for i, v in ipairs(directories) do
        if not quiet then
            message("Loading Directory: " .. directory .. v)
        end

        includeDir(directory .. v, quiet)
        if quiet then continue end

        if i ~= #directories then continue end
        message("Done Loading Directory: " .. directory .. v)
    end

    if quiet then return end
    message("Done Loading: " .. directory)
end

local function AddFileAs(File, directory, name)
    local prefix = File:Left(3):lower()

    if SERVER and prefix == "sv_" then
        include(directory .. File)
        message("Server Load: " .. File, name)
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)
            message("Shared AddCS: " .. File, name)
        end

        include(directory .. File)
        message("Shared Load: " .. File, name)
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            message("Client AddCS: " .. File, name)
        elseif CLIENT then
            include(directory .. File)
            message("Client Load: " .. File, name)
        end
    else
        AddCSLuaFile(directory .. File)
        include(directory .. File)
        message("Load: " .. File, name)
    end
end

local function includeDirAs(directory, name, nosub)
    directory = checkSlash(directory)

    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFileAs(v, directory, name)
    end

    if nosub then
        if quiet then return end
        message("Done Loading: " .. name)

        return
    end

    for i, v in ipairs(directories) do
        message("Loading Directory: " .. directory .. v, name)
        includeDirAs(directory .. v, name)

        if i ~= #directories then continue end
        message("Done Loading Directory: " .. directory .. v, name)
    end

    message("Done Loading", name)
end

RL.IncludeDir = includeDir
RL.IncludeDirAs = includeDirAs

if SERVER then
    local function addCSFiles(directory, name, nosub)
        directory = checkSlash(directory)

        local files, directories = file.Find(directory .. "*", "LUA")

        for _, v in ipairs(files) do
            AddCSLuaFile(directory .. v)
            if not name then continue end
            message("CSFiles: " .. directory .. v, name)
        end

        if nosub then
            if not name then return end
            message("Added CSFiles: " .. name)

            return
        end

        for _, v in ipairs(directories) do
            addCSFiles(directory .. v, name)
            if not name then continue end
            message("CSFiles Dir: " .. directory .. v, name)
        end

        if not name then return end
        message("Added CSFiles: " .. name)
    end

    RL.AddCSFiles = addCSFiles
end

RL.Files.GetAll = function(dir, path)
    local files, _ = file.Find(checkSlash(dir) .. "*", path)
    return files
end

RL.Files.GetDir = function(dir, path)
    local _, ret_dir = file.Find(checkSlash(dir) .. "*", path)
    return ret_dir
end

RL.Files.Iterator = function(dir, path, iterator)
    dir = checkSlash(dir)
    for _, v in ipairs(RL.Files.GetAll(dir, path)) do
        iterator(v, dir, path)
    end
end

RL.Files.Iterator_Dir = function(dir, path, iterator)
    dir = checkSlash(dir)
    for _, v in ipairs(RL.Files.GetDir(dir, path)) do
        iterator(v, dir, path)
    end
end

print"================== RL ================="
RL.IncludeDir"ricelib_preload"