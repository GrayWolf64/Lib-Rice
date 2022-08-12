RL = RL or {}
RL.VGUI = RL.VGUI or {}

file.CreateDir("ricelib")
file.CreateDir("ricelib/settings")

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

local function AddFile(File, directory)
    local prefix = string.lower(string.Left(File, 3))

    if SERVER and prefix == "sv_" then
        include(directory .. File)
        RL.Message("Server Load: " .. File)
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)
            RL.Message("Shared AddCS: " .. File)
        end

        include(directory .. File)
        RL.Message("Shared Load: " .. File)
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            RL.Message("Client AddCS: " .. File)
        elseif CLIENT then
            include(directory .. File)
            RL.Message("Client Load: " .. File)
        end
    end
end

function RL.IncludeDir(directory)
    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFile(v, directory)
    end

    for _, v in ipairs(directories) do
        RL.Message("Loading Directory: " .. directory .. v)
        RL.IncludeDir(directory .. v)
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
    end
end

function RL.IncludeDirAs(directory, name)
    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFileAs(v, directory, name)
    end

    for _, v in ipairs(directories) do
        RL.MessageAs("Loading Directory: " .. directory .. v, name)
        RL.IncludeDirAs(directory .. v, name)
    end
end

if SERVER then
    function RL.AddCSFiles(directory, name)
        local files, directories = file.Find(directory .. "*", "LUA")
    
        for _, v in ipairs(files) do
            RL.MessageAs("AddCSFiles: " .. directory .. v,name)
            AddCSLuaFile(directory .. v)
        end
    
        for _, v in ipairs(directories) do
            RL.MessageAs("AddCSFiles Dir: " .. directory .. v,name)
            RL.AddCSFiles(directory .. v, name)
        end
    end

    resource.AddWorkshop( "2829757059" )
end

RL.IncludeDir("ricelib/")