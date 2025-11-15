--- Loads `RiceLib` ahead of time
-- @script ricelib_init
-- @author RiceMCUT, GrayWolf
if SERVER then resource.AddWorkshop"2829757059" end

RiceLib           = RiceLib or {}
RiceLib.VGUI      = RiceLib.VGUI or {}
RiceLib.VGUI.Anim = RiceLib.VGUI.Anim or {}
RiceLib.Cache     = RiceLib.Cache or {}

local LOG_DIR      = "ricelib/logs/"
local COLOR_SERVER = Color(64, 158, 255)
local COLOR_CLIENT = Color(255, 255, 150)

local TEXT_LEVEL  = {}
local LEVEL_TEXT  = {}
local LEVEL_COLOR = {}

local function BRACK(str) return "[" .. str .. "]" end
local function SLASH(str) return Either(str:EndsWith"/", str, str .. "/") end

local function LEVEL(name, level_num, color)
    TEXT_LEVEL[name], LEVEL_TEXT[level_num], LEVEL_COLOR[level_num] = level_num, name, color
end

file.CreateDir(LOG_DIR)

LEVEL("INFO", 0, Color(100, 255, 100))
LEVEL("WARN", 1, Color(255, 255, 100))
LEVEL("ERROR", 2, Color(255, 100, 100))

local function log_func(log_level)
    return function(message, name)
        if message:StartsWith"#" then message = language.GetPhrase(message:sub(2)) or message end

        local header     = BRACK(name or "RiceLib")
        local level_text = BRACK(LEVEL_TEXT[log_level])
        local full_msg   = level_text .. " " .. message

        MsgC(Either(SERVER, COLOR_SERVER, COLOR_CLIENT), header, LEVEL_COLOR[log_level], full_msg .. "\n")

        if RiceLib.LogLevel > log_level then return end

        file.Append(LOG_DIR .. os.date("%Y_%d_%m.txt"), header .. " " .. BRACK(os.date("%H:%M:%S")) .. " " .. full_msg .. "\n")
    end
end

RiceLib.LogLevel = TEXT_LEVEL["ERROR"]

RiceLib.Info  = log_func(TEXT_LEVEL["INFO"])
RiceLib.Warn  = log_func(TEXT_LEVEL["WARN"])
RiceLib.Error = log_func(TEXT_LEVEL["ERROR"])

local prefix_loaders = {
    sv_ = function(full_path)
        if SERVER then return include(full_path) end
    end,
    cl_ = function(full_path)
        if SERVER then return AddCSLuaFile(full_path) end
        include(full_path)
    end
}

local function add_file(file_name, dir)
    local full_path = dir .. file_name

    local loader = prefix_loaders[string.Left(file_name, 3)]
    if loader then
        return loader(full_path)
    end

    AddCSLuaFile(full_path)
    include(full_path)
end

local function eachi_file(_dir, _no_sub, _path, _wildcard, _f1, _f1_argmod, _f2, _f2_argmod)
    local files, dirs = file.Find(_dir .. _wildcard, _path)
    for _, f in ipairs(files) do _f1(_f1_argmod(f)) end
    if _no_sub then return end
    for _, dir in ipairs(dirs) do _f2(_f2_argmod(dir)) end
end

local function include_dir(dir, no_sub)
    dir = SLASH(dir)

    eachi_file(dir, no_sub, "LUA", "*",
    add_file, function(f) return f, dir end,
    include_dir, function(v) return dir .. v end)
end

local function get_all_files(dir, path)
    local files = file.Find(SLASH(dir) .. "*", path)
    return files
end

local function get_all_dirs(dir, path)
    return select(2, file.Find(SLASH(dir) .. "*", path))
end

RiceLib.FS = RiceLib.FS or {}

function RiceLib.AddCSFiles(dir, no_sub)
    if CLIENT then return end
    dir = SLASH(dir)

    eachi_file(dir, no_sub, "LUA", "*",
    AddCSLuaFile, function(f) return dir .. f end,
    RiceLib.AddCSFiles, function(v) return dir .. v end)
end

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

local function ieach(_t, _f, ...)
    for _, v in ipairs(_t) do _f(v, ...) end
end

function RiceLib.FS.Iterator(dir, path, iterator)
    dir = SLASH(dir)
    ieach(get_all_files(dir, path), iterator, dir, path)
end

function RiceLib.FS.DirIterator(dir, path, iterator)
    dir = SLASH(dir)
    ieach(get_all_dirs(dir, path), iterator, dir, path)
end

RiceLib.FS.GetAll  = get_all_files
RiceLib.FS.GetDir  = get_all_dirs

RiceLib.AddFileAs  = add_file
RiceLib.IncludeDir = include_dir

print"================ RiceLib ================"

RiceLib.IncludeDir"ricelib_preload"

if CLIENT then
    RiceLib.IncludeDir("ricelib_vgui")
    RiceLib.IncludeDir("riceui")
else
    RiceLib.AddCSFiles("ricelib_vgui")
    RiceLib.AddCSFiles("riceui")
end

RiceLib.IncludeDir"ricelib"