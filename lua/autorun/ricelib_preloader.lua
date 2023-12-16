--- Loads `RiceLib` ahead of time
-- @script ricelib_preloader
-- @author RiceMCUT, GrayWolf
if SERVER then resource.AddWorkshop"2829757059" end

--- RiceLib global table
-- @table RiceLib
-- @field VGUI
-- @field IO
RiceLib           = RiceLib or {}
RiceLib.VGUI      = RiceLib.VGUI or {}
RiceLib.VGUI.Anim = RiceLib.VGUI.Anim or {}
RiceLib.IO        = RiceLib.IO or {}

--- Makes a log function
-- @local
-- @param msgColor Customize output function's log msg color
-- @return function log function
local function mklogfunc(msgColor)
    return function(msg, name)
        if msg:StartsWith"#" then
            msg = language.GetPhrase(msg:sub(2)) or msg
        end

        MsgC(Either(SERVER, Color(64, 158, 255), Color(255, 255, 150)),
            "[" .. (name or "RiceLib") .. "] ", msgColor, msg .. "\n")
    end
end

local message = mklogfunc(Color(0, 255, 0))
RiceLib.Warn  = mklogfunc(Color(255, 150, 0))
RiceLib.Error = mklogfunc(Color(255, 75, 75))
RiceLib.Info  = message

--- Checks if a string is properly ended with '/'
-- @local
-- @param str String to check
-- @return string checked string
local function check_slash(str)
    if not str:EndsWith"/" then return str .. "/" end
    return str
end

--- Adds a `.lua` file on whatever state
-- @local
-- @param fileName File name with extension
-- @param dir Directory where file lies
-- @param quiet Boolean for determining whether or not to output log msgs
-- @param name Log as who? Default value is `RL`
local function add_file(fileName, dir, quiet, name)
    local type

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
    local opType = {"include", "sh send or include", "send or include", "send and include"}
    message(opType[type] .. ": " .. fileName, name)
end

--- Adds(include) all the files in a dir
-- @function RiceLib.IncludeDir
-- @param dir Directory where files exist
-- @param quiet Boolean for determining whether or not to output log msgs
-- @param noSub Boolean for determining whether or not to also include `dir`'s sub dir's files / dirs(recursive)
-- @param name Log as who? Default value is `RL`
local function include_dir(dir, quiet, noSub, name)
    dir = check_slash(dir)

    local files, dirs = file.Find(dir .. "*.lua", "LUA")

    for _, v in ipairs(files) do add_file(v, dir, quiet) end

    if not quiet then message("loaded: " .. dir, name) end

    if noSub then return end

    for _, v in ipairs(dirs) do
        include_dir(dir .. v, quiet, false, name)

        if quiet then continue end
        message("loaded sub dir: " .. dir .. v, name)
    end
end

RiceLib.IncludeDir   = include_dir
RiceLib.IncludeDirAs = function(dir, name, noSub) include_dir(dir, false, noSub, name) end
RiceLib.AddFileAs    = function(fileName, dir, name) add_file(fileName, dir, false, name) end

if SERVER then
    --- Adds `.lua` files to be sent to client
    -- @function RiceLib.AddCSFiles
    -- @param dir Directory where files lie
    -- @param Log as who? Default value is `RL`
    -- @param noSub Boolean for determining whether or not to also add `dir`'s sub dir's files / dirs(recursive)
    local function add_csluafiles(dir, name, noSub)
        dir = check_slash(dir)

        local files, dirs = file.Find(dir .. "*", "LUA")

        for _, v in ipairs(files) do
            AddCSLuaFile(dir .. v)
            message("cslf: " .. dir .. v, name)
        end

        if noSub then return end

        for _, v in ipairs(dirs) do
            add_csluafiles(dir .. v, name)
            message("cslf sub dir: " .. dir .. v, name)
        end
    end

    RiceLib.AddCSFiles = add_csluafiles
end

--- Gets all file names found in dir under path
-- @function RiceLib.IO.GetAll
-- @param dir Directory where files may lie
-- @param path Game path
local function get_all_files(dir, path)
    local files = file.Find(check_slash(dir) .. "*", path)
    return files
end

--- Gets all dirs found in dir under path
-- @function RiceLib.IO.GetDir
-- @param dir Directory where sub dirs may lie
-- @param path Game path
local function get_all_dirs(dir, path)
    local _, dirs = file.Find(check_slash(dir) .. "*", path)
    return dirs
end

RiceLib.IO.Iterator = function(dir, path, iterator)
    dir = check_slash(dir)
    for _, v in ipairs(get_all_files(dir, path)) do
        iterator(v, dir, path)
    end
end

RiceLib.IO.DirIterator = function(dir, path, iterator)
    dir = check_slash(dir)
    for _, v in ipairs(get_all_dirs(dir, path)) do
        iterator(v, dir, path)
    end
end

RiceLib.IO.GetAll = get_all_files
RiceLib.IO.GetDir = get_all_dirs

if SERVER then
    util.AddNetworkString("ricelib_clientready")

    net.Receive("ricelib_clientready", function(_, ply)
        hook.Run("RiceLibClientReady", ply)
    end)
else
    local function ready()
        net.Start("ricelib_clientready")
        net.SendToServer()
    end

    hook.Add("InitPostEntity", "RiceLibClientReady", ready)

    concommand.Add("ricelib_simulate_clientready", ready)
end

print"================ RL ================"

RiceLib.IncludeDir"ricelib_preload"
RiceLib.IncludeDir"ricelib"

if CLIENT then
    RiceLib.IncludeDirAs("ricelib_vgui", "RiceLib VGUI")
    RiceLib.IncludeDir("riceui", true, true)
else
    RiceLib.AddCSFiles("ricelib_vgui", "RiceLib VGUI")
    RiceLib.AddCSFiles("riceui")
end