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
RiceLib.Cache = RiceLib.Cache or {}

RICELIB_LOGLEVEL_INFO = 0
RICELIB_LOGLEVEL_WARN = 1
RICELIB_LOGLEVEL_ERROR = 2

RiceLib.LogLevel = RICELIB_LOGLEVEL_ERROR

--- Makes a log function
-- @lfunction mklogfunc
-- @param color_msg Customize output function's log msg color
-- @return function log function

local logLevelColors = {
    [RICELIB_LOGLEVEL_INFO] = Color(100, 255, 100),
    [RICELIB_LOGLEVEL_WARN] = Color(255, 255, 100),
    [RICELIB_LOGLEVEL_ERROR] = Color(255, 100, 100)
}

local logLevelText = {
    [RICELIB_LOGLEVEL_INFO] = "[INFO]",
    [RICELIB_LOGLEVEL_WARN] = "[WARN]",
    [RICELIB_LOGLEVEL_ERROR] = "[ERROR]"
}

local color_server = Color(64, 158, 255)
local color_client = Color(255, 255, 150)

file.CreateDir("ricelib/logs")

local function mklogfunc(logLevel)
    return function(message, name)
        if message:StartsWith"#" then message = language.GetPhrase(message:sub(2)) or message end

        local header = "[" .. (name or "RiceLib") .. "]"
        local fullMessage = logLevelText[logLevel] .. " " .. message

        MsgC(Either(SERVER, color_server, color_client), header, logLevelColors[logLevel], fullMessage, "\n")

        if RiceLib.LogLevel > logLevel then return end

        local fileName = os.date("%Y_%d_%m.txt")
        local time = "[" .. os.date("%H:%M:%S") .. "]"
        local logMessage = logLevelText[logLevel] .. time .. " " .. message

        file.Append("ricelib/logs/" .. fileName, header .. logMessage .. "\n")
    end
end

RiceLib.Info  = mklogfunc(RICELIB_LOGLEVEL_INFO)
RiceLib.Warn  = mklogfunc(RICELIB_LOGLEVEL_WARN)
RiceLib.Error = mklogfunc(RICELIB_LOGLEVEL_ERROR)

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
local prefixLoaders = {
    sv_ = function(fullPath)
        if CLIENT then return end

        include(fullPath)
    end,

    cl_ = function(fullPath)
        if SERVER then
            AddCSLuaFile(fullPath)

            return
        end

        include(fullPath)
    end,
}
local function add_file(file_name, dir)
    local fullPath = dir .. file_name

    local loader = prefixLoaders[string.Left(file_name, 3)]
    if loader then
        loader(fullPath)

        return
    end

    AddCSLuaFile(fullPath)
    include(fullPath)
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

--- Modifies target table or calls target with filenames using corresponding include result
function RiceLib.FS.LoadFiles(target, dir)
    if not target or not dir then return end

    for _, f in ipairs(get_all_files(dir, "LUA")) do
        AddCSLuaFile(dir .. "/" .. f)

        local ret = include(dir .. "/" .. f)
        local filename = f:StripExtension()

        if isfunction(target) then target(filename, ret)
        elseif istable(target) then target[filename] = ret end
    end
end

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
if SERVER then
    util.AddNetworkString("ricelib_clientready")

    net.Receive("ricelib_clientready", function(_, b)
        hook.Run("RiceLibClientReady", b)
    end)
else
    local function c()
        net.Start("ricelib_clientready")
        net.SendToServer()
    end

    hook.Add("InitPostEntity", "RiceLibClientReady", c)

    concommand.Add("ricelib_simulate_clientready", function(b)
        if not b:IsAdmin() then return end
        c()
    end)
end

RiceLib.AddFileAs  = add_file
RiceLib.IncludeDir = include_dir

print"================ RiceLib ================"

RiceLib.IncludeDir"ricelib_preload"

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

RiceLib.IncludeDir"ricelib"