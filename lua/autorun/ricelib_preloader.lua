RL = RL or {}
RL.VGUI = RL.VGUI or {}
RL.Functions = RL.Functions or {}

file.CreateDir("ricelib")
file.CreateDir("ricelib/settings")

if SERVER then
    resource.AddWorkshop( "2829757059" )
end

function RL.Message(msg)
    if SERVER then color = Color(0,150,255) else color = Color(255, 255, 150) end
    
    MsgC(color, "[RiceLib] ")
    MsgC(Color(0, 255, 0), msg .. "\n")
end

function RL.Message_Error(msg)
    if SERVER then color = Color(0,150,255) else color = Color(255, 255, 150) end

    MsgC(color, "[RiceLib] ")
    MsgC(Color(255, 0, 0), msg .. "\n")
end

function RL.Message_Warn(msg)
    if SERVER then color = Color(0,150,255) else color = Color(255, 255, 150) end

    MsgC(color, "[RiceLib] ")
    MsgC(Color(255, 150, 0), msg .. "\n")
end

function RL.MessageAs(msg,name)
    if SERVER then color = Color(0,150,255) else color = Color(255, 255, 150) end

    MsgC(color, "["..name.."] ")
    MsgC(Color(0, 255, 0), msg .. "\n")
end

function RL.Message_ErrorAs(msg,name)
    if SERVER then color = Color(0,150,255) else color = Color(255, 255, 150) end

    MsgC(color, "["..name.."] ")
    MsgC(Color(255, 0, 0), msg .. "\n")
end

function RL.Message_WarnAs(msg,name)
    if SERVER then color = Color(0,150,255) else color = Color(255, 255, 150) end
    
    MsgC(color, "["..name.."] ")
    MsgC(Color(255, 150, 0), msg .. "\n")
end

local function AddFile(File, directory, silence)
    local prefix = string.lower(string.Left(File, 3))

    if SERVER and prefix == "sv_" then
        include(directory .. File)
        if not silence then RL.Message("Server Load: " .. File) end
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)
            if not silence then RL.Message("Shared AddCS: " .. File) end
        end

        include(directory .. File)
        RL.Message("Shared Load: " .. File)
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            if not silence then RL.Message("Client AddCS: " .. File) end
        elseif CLIENT then
            include(directory .. File)
            if not silence then RL.Message("Client Load: " .. File) end
        end
    else
        include(directory .. File)

        if not silence then RL.Message("Load: " .. File) end
    end
end

function RL.IncludeDir(directory,silence,nosub)
    if not string.EndsWith(directory,"/") then directory = directory.."/" end
    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFile(v, directory, silence)
    end

    if nosub then return end

    for _, v in ipairs(directories) do
        if not silence then RL.Message("Loading Directory: " .. directory .. v) end
        RL.IncludeDir(directory .. v, silence)
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
            RL.MessageAs("Shared AddCS: " .. File,name)
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
        include(directory .. File)

        if not silence then RL.MessageAs("Load: " .. File, name) end
    end
end

function RL.IncludeDirAs(directory, name, nosub)
    if not string.EndsWith(directory,"/") then directory = directory.."/" end
    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFileAs(v, directory, name)
    end

    if nosub then return end

    for _, v in ipairs(directories) do
        RL.MessageAs("Loading Directory: " .. directory .. v, name)
        RL.IncludeDirAs(directory .. v, name)
    end
end

if SERVER then
    function RL.AddCSFiles(directory, name, silence, nosub)
        if not string.EndsWith(directory,"/") then directory = directory.."/" end
        local files, directories = file.Find(directory .. "*", "LUA")
    
        for _, v in ipairs(files) do
            if not silence then RL.MessageAs("AddCSFiles: " .. directory .. v,name) end
            AddCSLuaFile(directory .. v)
        end

        if nosub then return end
    
        for _, v in ipairs(directories) do
            if not silence then RL.MessageAs("AddCSFiles Dir: " .. directory .. v,name) end
            RL.AddCSFiles(directory .. v, name)
        end
    end
end

RL.IncludeDir("ricelib_preload")