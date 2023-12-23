--- Loads `RiceLib` ahead of time
-- @script ricelib_init
-- @author RiceMCUT, GrayWolf
if SERVER then resource.AddWorkshop"2829757059" end

--- RiceLib global table
-- @table RiceLib
-- @field VGUI
-- @field FS
RiceLib           = RiceLib or {}
RiceLib.VGUI      = RiceLib.VGUI or {}
RiceLib.VGUI.Anim = RiceLib.VGUI.Anim or {}

--- Makes a log function
-- @lfunction mklogfunc
-- @param color_msg Customize output function's log msg color
-- @return function log function
local function mklogfunc(color_msg)
    return function(msg, name)
        if msg:StartsWith"#" then msg = language.GetPhrase(msg:sub(2)) or msg end

        MsgC(Either(SERVER, Color(64, 158, 255), Color(255, 255, 150)),
            "[" .. (name or "RiceLib") .. "] ", color_msg, msg .. "\n")
    end
end

local message = mklogfunc(Color(0, 255, 0))
RiceLib.Warn  = mklogfunc(Color(255, 150, 0))
RiceLib.Error = mklogfunc(Color(255, 75, 75))
RiceLib.Info  = message

--- Checks if a string is properly ended with '/'
-- @lfunction check_slash
-- @param str String to check
-- @return string checked string
local function check_slash(str)
    if not str:EndsWith"/" then return str .. "/" end
    return str
end

--- Adds a `.lua` file on whatever state
-- @lfunction add_file
-- @param file_name File name with extension
-- @param dir Directory where file lies
local function add_file(file_name, dir)
    dir = dir .. file_name

    local handlers = setmetatable({
        sv_ = function() include(dir) end,
        sh_ = {
            [true]  = function() AddCSLuaFile(dir) end, [false] = function() return end,
            final   = function() include(dir) end},
        cl_ = {
            [true]  = function() AddCSLuaFile(dir) end, [false] = function() include(dir) end,
            final   = function() return end}
    }, {__index = function()
        return function() AddCSLuaFile(dir); include(dir) end
    end})

    local handler = handlers[file_name:Left(3)]
    if istable(handler) then handler[SERVER](); handler.final() else handler() end
end

--- Apply Function 1 to every file name(arg) in a folder(dir) modified by its Argument Modifier 1 orderly,
-- if sub folders(dirs) are accounted for, apply Function 2 to every sub folder(dir) name in the folder(dir) modified by its Argument Modifier 2 orderly
-- @param _dir The directory's name
-- @param _no_sub Whether or not dis-allow for sub folders(dirs) in `_dir`
-- @param _path Game path
-- @param _wildcard The wildcard to search for
-- @param _f1 Function 1
-- @param _f1_argmod Function 1's argument modifier
-- @param _f2 Function 2
-- @param _f2_argmod Function 2's argument modifier
local function eachi_file(_dir, _no_sub, _path, _wildcard, _f1, _f1_argmod, _f2, _f2_argmod)
    local files, dirs = file.Find(_dir .. _wildcard, _path)
    for _, f in ipairs(files) do _f1(_f1_argmod(f)) end
    if _no_sub then return end
    for _, dir in ipairs(dirs) do _f2(_f2_argmod(dir)) end
end

--- Adds(includes) all the files in a dir
-- @lfunction include_dir
-- @param dir Directory where files exist
-- @param no_sub Boolean for determining whether or not to also include `dir`'s sub dir's files / dirs(recursive)
local function include_dir(dir, no_sub)
    dir = check_slash(dir)

    eachi_file(dir, no_sub, "LUA", "*",
    add_file, function(f) return f, dir end,
    include_dir, function(v) return dir .. v end)
end

--- Gets all file names found in dir under path
-- @lfunction get_all_files
-- @param dir Directory where files may lie
-- @param path Game path
local function get_all_files(dir, path)
    local files = file.Find(check_slash(dir) .. "*", path)
    return files
end

--- Gets all dirs found in dir under path
-- @lfunction get_all_dirs
-- @param dir Directory where sub dirs may lie
-- @param path Game path
local function get_all_dirs(dir, path)
    return select(2, file.Find(check_slash(dir) .. "*", path))
end

--- Some convenient functions to cope with the file system of the game
-- @section FS
RiceLib.FS = RiceLib.FS or {}

--- Apply a function to every values in a table alongside with specific parameters orderly
-- @lfunction ieach
-- @param _t Table
-- @param _f Function
-- @param ... Some additional params to pass in
local function ieach(_t, _f, ...)
    for _, v in ipairs(_t) do _f(v, ...) end
end

--- Iterate every file in a folder(dir) from a path
-- @param dir The directory's name
-- @param path Game path
-- @param iterator A custom Function
function RiceLib.FS.Iterator(dir, path, iterator)
    dir = check_slash(dir)
    ieach(get_all_files(dir, path), iterator, dir, path)
end

--- Iterate every folder in a dir from a path
-- @param dir The directory's name
-- @param path Game path
-- @param iterator A custom Function
function RiceLib.FS.DirIterator(dir, path, iterator)
    dir = check_slash(dir)
    ieach(get_all_dirs(dir, path), iterator, dir, path)
end

-- @section end
RiceLib.FS.GetAll  = get_all_files
RiceLib.FS.GetDir  = get_all_dirs

-- Hook: RiceLibClientReady, which has a `ply` param
-- Not recommended. Please seek for other alternatives
if SERVER then util.AddNetworkString("ricelib_clientready")net.Receive("ricelib_clientready",function(_,b)hook.Run("RiceLibClientReady",b)end)
else local function c()net.Start("ricelib_clientready")net.SendToServer()end;hook.Add("InitPostEntity","RiceLibClientReady",c)concommand.Add("ricelib_simulate_clientready",function(b)if not b:IsAdmin()then return end;c()end)end

RiceLib.AddFileAs  = add_file
RiceLib.IncludeDir = include_dir

print"================ RL ================"

RiceLib.IncludeDir"ricelib_preload"
RiceLib.IncludeDir"ricelib"

if CLIENT then
    -- RiceLib.IncludeDirAs("ricelib_vgui", "RiceLib VGUI")
    RiceLib.IncludeDir("ricelib_vgui")
    RiceLib.IncludeDir("riceui")
else
    --- Adds `.lua` files to be sent to client
    -- @lfunction add_cslua
    -- @param dir Directory where files lie
    -- @param no_sub Boolean for determining whether or not to also add `dir`'s sub dir's files / dirs(recursive)
    local function add_cslua(dir, no_sub)
        dir = check_slash(dir)

        eachi_file(dir, no_sub, "LUA", "*",
        AddCSLuaFile, function(f) return dir .. f end,
        add_cslua, function(v) return dir .. v end)
    end

    RiceLib.AddCSFiles = add_cslua

    -- RiceLib.AddCSFiles("ricelib_vgui", "RiceLib VGUI")
    RiceLib.AddCSFiles("ricelib_vgui")
    RiceLib.AddCSFiles("riceui")
end