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
-- @param file_name File name with extension
-- @param dir Directory where file lies
-- @param id Log as who? Default value is `RL`
local function add_file(file_name, dir, id)
    dir = dir .. file_name

    local handlers = setmetatable({
        sv = function() include(dir) end,
        sh = {
            [true]  = function() AddCSLuaFile(dir) end,
            [false] = function() return end,
            final   = function() include(dir) end},
        cl = {
            [true]  = function() AddCSLuaFile(dir) end,
            [false] = function() include(dir) end,
            final   = function() return end}
    }, {__index = function()
        return function() AddCSLuaFile(dir); include(dir) end
    end})

    local handler = handlers[file_name:Left(2):lower()]
    if istable(handler) then handler[SERVER](); handler.final() else handler() end
end

local function eachi_file(_dir, _no_sub, _path, _wildcard, _f1, _f1_argmod, _f2, _f2_argmod)
    local files, dirs = file.Find(_dir .. _wildcard, _path)
    for _, f in ipairs(files) do _f1(_f1_argmod(f)) end
    if _no_sub then return end
    for _, dir in ipairs(dirs) do _f2(_f2_argmod(dir)) end
end

--- Adds(include) all the files in a dir
-- @function RiceLib.IncludeDir
-- @param dir Directory where files exist
-- @param no_sub Boolean for determining whether or not to also include `dir`'s sub dir's files / dirs(recursive)
local function include_dir(dir, no_sub)
    dir = check_slash(dir)

    eachi_file(dir, no_sub, "LUA", "*.lua", 
    add_file, function(f) return f, dir end,
    include_dir, function(v) return dir .. v end)
end

RiceLib.AddFileAs    = add_file
RiceLib.IncludeDir   = include_dir
RiceLib.IncludeDirAs = function(dir, id, no_sub) include_dir(dir, false, no_sub, id) end

if SERVER then
    --- Adds `.lua` files to be sent to client
    -- @function RiceLib.AddCSFiles
    -- @param dir Directory where files lie
    -- @param no_sub Boolean for determining whether or not to also add `dir`'s sub dir's files / dirs(recursive)
    local function add_csluafiles(dir, no_sub)
        dir = check_slash(dir)

        eachi_file(dir, no_sub, "LUA", "*",
        AddCSLuaFile, function(f) return dir .. f end,
        add_csluafiles, function(v) return dir .. v end)
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

local function ieach(_t, _f, ...)
    for _, v in ipairs(_t) do _f(v, ...) end
end

--- Gets all dirs found in dir under path
-- @function RiceLib.IO.GetDir
-- @param dir Directory where sub dirs may lie
-- @param path Game path
local function get_all_dirs(dir, path)
    return select(2, file.Find(check_slash(dir) .. "*", path))
end

RiceLib.IO.Iterator = function(dir, path, iterator)
    dir = check_slash(dir)
    ieach(get_all_files(dir, path), iterator, dir, path)
end

RiceLib.IO.DirIterator = function(dir, path, iterator)
    dir = check_slash(dir)
    ieach(get_all_dirs(dir, path), iterator, dir, path)
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