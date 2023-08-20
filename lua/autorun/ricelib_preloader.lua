--- Loads `RiceLib` ahead of time
-- @script ricelib_preloader
-- @author RiceMCUT, GrayWolf
if SERVER then resource.AddWorkshop"2829757059" end

--- RiceLib global table
-- @table RL
-- @field VGUI
-- @field Language
-- @field Functions
-- @field Files
RL                = RL or {}
RL.VGUI           = RL.VGUI or {}
RL.VGUI.Anim      = RL.VGUI.Anim or {}
RL.Language       = RL.Language or {}
RL.Language.Words = RL.Language.Words or {}
RL.Functions      = RL.Functions or {}
RL.Files          = RL.Files or {}

file.CreateDir"ricelib/settings"

--- Makes a log function
-- @local
-- @param msgColor Customize output function's log msg color
-- @return function log function
local function mkMessageFunc(msgColor)
    return function(msg, name)
        if msg:StartsWith"#" then
            msg = RL.Language.Get(msg:sub(2)) or msg
        end

        name = name or "RiceLib"
        local nameColor = (SERVER and {Color(64, 158, 255)} or {Color(255, 255, 150)})[1]

        MsgC(nameColor, "[" .. name .. "] ", msgColor, msg .. "\n")
    end
end

local message    = mkMessageFunc(Color(0, 255, 0))
RL.Message_Warn  = mkMessageFunc(Color(255, 150, 0))
RL.Message_Error = mkMessageFunc(Color(255, 75, 75))
RL.Message       = message

--- Checks if a string is properly ended with '/'
-- @local
-- @param str String to check
-- @return string checked string
local function checkSlash(str)
    if not str:EndsWith"/" then return str .. "/" end
    return str
end

--- Adds a `.lua` file on whatever state
-- @local
-- @param fileName File name with extension
-- @param dir Directory where file lies
-- @param quiet Boolean for determining whether or not to output log msgs
-- @param name Log as who? Default value is `RL`
local function AddFile(fileName, dir, quiet, name)
    local type
    name = name or "RL"

    local mt = {__index = function()
        return function() AddCSLuaFile(dir .. fileName); include(dir .. fileName); type = 4 end
    end}
    local mappedHandlers = setmetatable({
        sv_ = function() include(dir .. fileName); type = 1 end,
        sh_ = {
            [true]  = function() AddCSLuaFile(dir .. fileName) end,
            [false] = function() return end,
            final   = function() include(dir .. fileName); type = 2 end},
        cl_ = {
            [true]  = function() AddCSLuaFile(dir .. fileName) end,
            [false] = function() include(dir .. fileName) end,
            final   = function() type = 3 end}
    }, mt)

    local handler = mappedHandlers[fileName:Left(3):lower()]
    if istable(handler) then handler[SERVER](); handler.final() else handler() end

    if quiet then return end
    local opType = {"sv include", "sh send or include", "cl recv and include", "send or include"}
    message(opType[type] .. ": " .. fileName, name)
end

--- Adds(include) all the files in a dir
-- @function RL.IncludeDir
-- @param dir Directory where files exist
-- @param quiet Boolean for determining whether or not to output log msgs
-- @param noSub Boolean for determining whether or not to also include `dir`'s sub dir's files / dirs(recursive)
-- @param name Log as who? Default value is `RL`
local function includeDir(dir, quiet, noSub, name)
    dir = checkSlash(dir)
    name = name or "RL"

    local files, directories = file.Find(dir .. "*.lua", "LUA")

    for _, v in ipairs(files) do AddFile(v, dir, quiet) end

    if not quiet then message("Done loading: " .. dir, name) end

    if noSub then return end

    for _, v in ipairs(directories) do
        includeDir(dir .. v, quiet, false, name)

        if quiet then continue end
        message("Loaded sub dir: " .. dir .. v, name)
    end
end

RL.IncludeDir   = includeDir
RL.IncludeDirAs = function(dir, name, noSub) includeDir(dir, false, noSub, name) end
RL.AddFileAs    = function(fileName, dir, name) AddFile(fileName, dir, false, name) end

if SERVER then
    --- Adds `.lua` files to be sent to client
    -- @function RL.AddCSFiles
    -- @param dir Directory where files lie
    -- @param Log as who? Default value is `RL`
    -- @param noSub Boolean for determining whether or not to also add `dir`'s sub dir's files / dirs(recursive)
    local function addCSFiles(dir, name, noSub)
        dir = checkSlash(dir)
        name = name or "RL"

        local files, directories = file.Find(dir .. "*", "LUA")

        for _, v in ipairs(files) do
            AddCSLuaFile(dir .. v)
            message("CSFiles: " .. dir .. v, name)
        end

        message("Added CSFiles: " .. name)

        if noSub then return end

        for _, v in ipairs(directories) do
            addCSFiles(dir .. v, name)
            message("CSFiles sub dir: " .. dir .. v, name)
        end
    end

    RL.AddCSFiles = addCSFiles
end

--- Gets all file names found in dir under path
-- @function RL.Files.GetAll
-- @param dir Directory where files may lie
-- @param path Game path
local function getAll(dir, path)
    local files = file.Find(checkSlash(dir) .. "*", path)
    return files
end

--- Gets all dirs found in dir under path
-- @function RL.Files.GetDir
-- @param dir Directory where sub dirs may lie
-- @param path Game path
local function getDir(dir, path)
    local _, dirs = file.Find(checkSlash(dir) .. "*", path)
    return dirs
end

RL.Files.Iterator = function(dir, path, iterator)
    dir = checkSlash(dir)
    for _, v in ipairs(getAll(dir, path)) do
        iterator(v, dir, path)
    end
end

RL.Files.Iterator_Dir = function(dir, path, iterator)
    dir = checkSlash(dir)
    for _, v in ipairs(getDir(dir, path)) do
        iterator(v, dir, path)
    end
end

RL.Files.GetAll = getAll
RL.Files.GetDir = getDir

print"================== RL ================="
RL.IncludeDir"ricelib_preload"