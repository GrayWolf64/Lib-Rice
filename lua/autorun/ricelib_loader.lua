RL = RL or {}

file.CreateDir("ricelib")
file.CreateDir("ricelib/settings")

local function AddFile(File, directory)
    local prefix = string.lower(string.Left(File, 3))

    if SERVER and prefix == "sv_" then
        include(directory .. File)
        print("[RiceLib] Server Load: " .. File)
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)
            print("[RiceLib] Shared AddCS: " .. File)
        end

        include(directory .. File)
        print("[RiceLib] Shared Load: " .. File)
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            print("[RiceLib] Client AddCS: " .. File)
        elseif CLIENT then
            include(directory .. File)
            print("[RiceLib] Client Load: " .. File)
        end
    end
end

function RL.IncludeDir(directory)
    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFile(v, directory)
    end

    for _, v in ipairs(directories) do
        print("[RiceLib] Loading Directory: " .. directory .. v)
        RL.IncludeDir(directory .. v)
    end
end

local function AddFileAs(File, directory, name)
    local prefix = string.lower(string.Left(File, 3))

    if SERVER and prefix == "sv_" then
        include(directory .. File)
        print("["..name.."] Server Load: " .. File)
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            include(directory .. File)
            print("["..name.."] Shared AddCS: " .. File)
        end

        include(directory .. File)
        print("["..name.."] Shared Load: " .. File)
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            print("["..name.."] Client AddCS: " .. File)
        elseif CLIENT then
            include(directory .. File)
            print("["..name.."] Client Load: " .. File)
        end
    end
end

function RL.IncludeDirAs(directory, name)
    local files, directories = file.Find(directory .. "*", "LUA")

    for _, v in ipairs(files) do
        AddFileAs(v, directory, name)
    end

    for _, v in ipairs(directories) do
        print("["..name.."] Loading Directory: " .. directory .. v)
        RL.IncludeDirAs(directory .. v, name)
    end
end

if SERVER then
    function RL.AddCSFiles(directory, name)
        local files, directories = file.Find(directory .. "*", "LUA")
    
        for _, v in ipairs(files) do
            print("["..name.."] AddCSFiles : " .. directory .. v)
            AddCSLuaFile(directory .. v)
        end
    
        for _, v in ipairs(directories) do
            print("["..name.."] AddCSFiles Dir : " .. directory .. v)
            RL.AddCSFiles(directory .. v, name)
        end
    end

    resource.AddWorkshop( "2829757059" )
end

RL.IncludeDir("ricelib/")