RiceLib.Config = RiceLib.Config or {}

file.CreateDir"ricelib/settings"

-- file based config
function RiceLib.Config.LoadConfig(Config, Name, default)
    local root = "ricelib/settings/" .. Config
    local dir = root .. "/" .. Name .. ".json"

    if file.Exists(root, "DATA") and file.Exists(dir, "DATA") then
        local data = util.JSONToTable(file.Read(dir))
        if data then
            RiceLib.table.Inherit(data, default)
        else
            data = table.Copy(default)
        end

        RiceLib.Config.SaveConfig(Config, Name, data)

        return data
    else
        file.CreateDir(root)
        file.Write(dir, util.TableToJSON(default, true) or "")

        return default
    end
end

local function saveConfig(config, name, tbl)
    local dir = "ricelib/settings/" .. config .. "/" .. name .. ".json"

    file.Write(dir, util.TableToJSON(tbl, true))
end
RiceLib.Config.SaveConfig = saveConfig

-- key based config
local configTable = {}
local configEntrys = {}
local configCategorys = {}
local nameSpaceInfos = {}

local function loadConfig()
    for _, file in ipairs(RiceLib.FS.GetAll("ricelib/settings/ricelib", "DATA")) do
        local nameSpace = string.StripExtension(file)

        configTable[nameSpace] = RiceLib.Config.LoadConfig("ricelib", nameSpace, {})
    end
end

local function checkAdminLevel(ply, levelNeeded)
    if ply:IsSuperAdmin() then
        return true
    end

    if ply:IsAdmin() then
        return levelNeeded == 1
    end

    return levelNeeded == 0
end

local function sendSharedConfig(nameSpace, key, value, info)
    if CLIENT then
        if not checkAdminLevel(LocalPlayer(), info.AdminLevel) then return end

        RiceLib.Net.Send{
            NameSpace = "RiceLib_ConfigManager",
            Command = "SetSharedConfig",
            Data = {nameSpace, key, value}
        }

        return
    end

    RiceLib.Net.Send{
        NameSpace = "RiceLib_ConfigManager",
        Command = "SetSharedConfig",
        Data = {nameSpace, key, value}
    }
end

local function set(nameSpace, key, value, noNetwork)
    nameSpace = string.lower(nameSpace)

    configTable[nameSpace] = configTable[nameSpace] or {}
    configTable[nameSpace][key] = value

    RiceLib.Config.SaveConfig("ricelib", nameSpace, configTable[nameSpace])

    if noNetwork then return end
    if not configEntrys[nameSpace] then return end
    if not configEntrys[nameSpace][key] then return end

    local info = configEntrys[nameSpace][key]

    if info.Shared then
        sendSharedConfig(nameSpace, key, value, info)
    end
end

local function getEntryInfo(nameSpace, key)
    if not configEntrys[nameSpace] then return end

    return configEntrys[nameSpace][key]
end

local function get(nameSpace, Key)
    if nameSpace == nil or Key == nil then return end
    nameSpace = string.lower(nameSpace)

    configTable[nameSpace] = configTable[nameSpace] or {}

    local value = configTable[nameSpace][Key]
    if not value then
        local default = (getEntryInfo(nameSpace, Key) or {}).Default

        if default then
            set(nameSpace, Key, default)

            value = default
        end
    end

    return value
end

local baseEntryInfo = {
    Type = "Number",
    Default = 0,
    Category = "DefaultCategory",
    DisplayName = "UnknownSetting",

    Min = 0,
    Max = math.huge,

    -- Make client config value avaliable for server, cannot be use with Shared
    TellServer = false,

    -- Make this config be shared across server and client, cannot be use with TellServer
    Shared = false,

    -- Admin level needed to change Shared config
    -- 0 Anyone
    -- 1 Admin
    -- 2 SuperAdmin
    AdminLevel = 1,

    -- Make config avaliable in config manager
    UseGUI = true,

    GetValue = function(self)
        return get(self.NameSpace, self.Key)
    end,

    SetValue = function(self, value)
        return set(self.NameSpace, self.Key, value)
    end,
}

local baseNameSpaceInfo = {
    DisplayName = "Unknown",
    Author = "Unknown"
}

function RiceLib.Config.DefineNameSpace(nameSpace, info)
    nameSpaceInfos[nameSpace] = RiceLib.table.InheritCopy(info, baseNameSpaceInfo)
end
RiceLib.Config.DefineNameSpace("ricelib", {
    DisplayName = "RiceLib",
    Author = "Rice"
})

function RiceLib.Config.GetNameSpaceInfo(nameSpace)
    return nameSpaceInfos[nameSpace]
end

function RiceLib.Config.Define(nameSpace, key, info)
    if not configEntrys[nameSpace] then configEntrys[nameSpace] = {} end

    info = RiceLib.table.InheritCopy(info, baseEntryInfo)
    info.NameSpace = nameSpace
    info.Key = key
    configEntrys[nameSpace][key] = info

    if not configCategorys[nameSpace] then configCategorys[nameSpace] = {} end
    if not table.HasValue(configCategorys[nameSpace], info.Category) then
        table.insert(configCategorys[nameSpace], info.Category)
    end

    if not configTable[nameSpace] then configTable[nameSpace] = {} end
    if not configTable[nameSpace][key] then
        set(nameSpace, key, info.Default, true)
    end

    return info
end

function RiceLib.Config.GetEntry(nameSpace, key)
    return configEntrys[nameSpace][key]
end

function RiceLib.Config.GetEntrys()
    return configEntrys
end

function RiceLib.Config.GetEntrysInCategory(nameSpace, category)
    local entrys = {}

    for key, info in pairs(configEntrys[nameSpace]) do
        if info.Category ~= category then continue end

        entrys[key] = info
    end

    return entrys
end

function RiceLib.Config.GetCategorys(nameSpace)
    return configCategorys[nameSpace]
end

RiceLib.Config.All = configTable
RiceLib.Config.Set = set
RiceLib.Config.Get = get

loadConfig()

concommand.Add("ricelib_configmanaer_load", loadConfig)
concommand.Add("ricelib_configmanaer_save", function()
    for nameSpace, config in pairs(configTable) do
        saveConfig(nameSpace, config)
    end
end)
concommand.Add("ricelib_configmanaer_dump", function()
    print("config:")
    PrintTable(configTable)

    print("configEntrys:")
    PrintTable(configEntrys)
end)

RiceLib.Net.RegisterReceiver("RiceLib_ConfigManager", {
    SetSharedConfig = function(data, ply)
        local nameSpace, key, value = unpack(data)

        if not configEntrys[nameSpace] then return end
        if not configEntrys[nameSpace][key] then return end

        if SERVER and not checkAdminLevel(ply, configEntrys[nameSpace][key].AdminLevel)then return end

        set(nameSpace, key, value, CLIENT)
    end
})