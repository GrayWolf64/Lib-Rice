RL = RL or {}
RL.VGUI = RL.VGUI or {}
RL.VGUI.Anim = RL.VGUI.Anim or {}
RL.Language = RL.Language or {}
RL.Language.Words = RL.Language.Words or {}
RL.Functions = RL.Functions or {}
RL.Files = {}

file.CreateDir"ricelib/settings"
if SERVER then resource.AddWorkshop"2829757059" end

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
    if not str:EndsWith"/" then return str .. "/" end
    return str
end

local function AddFile(fileName, directory, quiet, name)
    local type
    name = name or "RL"

    local mt = {__index = function()
        return function() AddCSLuaFile(directory .. fileName); include(directory .. fileName); type = 4 end
    end}
    local mappedHandlers = setmetatable({
        sv_ = function() include(directory .. fileName); type = 1 end,
        sh_ = {
            [true] = function() AddCSLuaFile(directory .. fileName) end,
            [false] = function() return end,
            final = function() include(directory .. fileName); type = 2 end},
        cl_ = {
            [true] = function() AddCSLuaFile(directory .. fileName) end,
            [false] = function() include(directory .. fileName) end,
            final = function() type = 3 end}
    }, mt)

    local handler = mappedHandlers[fileName:Left(3):lower()]
    if istable(handler) then handler[SERVER](); handler.final() else handler() end

    if quiet then return end
    local opType = {"sv include", "sh send or include", "cl recv and include", "send or include"}
    message(opType[type] .. ": " .. fileName, name)
end

AddFileAs = function(fileName, directory, name) AddFile(fileName, directory, false, name) end

local function includeDir(directory, quiet, noSub, name)
    directory = checkSlash(directory)
    name = name or "RL"

    local files, directories = file.Find(directory .. "*.lua", "LUA")

    for _, v in ipairs(files) do AddFile(v, directory, quiet) end

    if not quiet then message("Done loading: " .. directory, name) end

    if noSub then return end

    for _, v in ipairs(directories) do
        includeDir(directory .. v, quiet, false, name)

        if quiet then continue end
        message("Loaded sub dir: " .. directory .. v, name)
    end

    if quiet then return end
    message("Done loading dir: " .. directory, name)
end

includeDirAs = function(directory, name, noSub) includeDir(directory, false, noSub, name) end

RL.IncludeDir = includeDir
RL.IncludeDirAs = includeDirAs

if SERVER then
    local function addCSFiles(directory, name, noSub)
        directory = checkSlash(directory)
        name = name or "RL"

        local files, directories = file.Find(directory .. "*", "LUA")

        for _, v in ipairs(files) do
            AddCSLuaFile(directory .. v)
            message("CSFiles: " .. directory .. v, name)
        end

        message("Added CSFiles: " .. name)

        if noSub then return end

        for _, v in ipairs(directories) do
            addCSFiles(directory .. v, name)
            message("CSFiles sub dir: " .. directory .. v, name)
        end
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