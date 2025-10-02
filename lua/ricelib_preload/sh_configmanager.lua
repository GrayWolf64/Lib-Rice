RiceLib.Config = RiceLib.Config or {}
RiceLib.Cache.Config_ConfigTable = RiceLib.Cache.Config_ConfigTable or {}

file.CreateDir"ricelib/settings"
file.CreateDir"ricelib/settings/ricelib"

-- MARK: file based config
---@return table Config
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

-- MARK: Key based object config
local configTable = RiceLib.Cache.Config_ConfigTable
local configTypes = {}
local configEntrys = {}
local configCategorys = {}
local nameSpaceInfos = {}

---@enum AdminLevel
RiceLib.Config.AdminLevels = {
    ADMINLEVEL_ANYONE = 0,
    ADMINLEVEL_ADMIN = 1,
    ADMINLEVEL_SUPERADMIN = 2
}

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

    hook.Run("RiceLib_ConfigManager_ValueChanged", nameSpace, key, value)
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
    if value == nil then
        local default = (getEntryInfo(nameSpace, Key) or {}).Default

        if default then
            set(nameSpace, Key, default)

            value = default
        end
    end

    return value
end

-- MARK: Config Object Class
---@class RiceLib_Config
local configMeta = {}
configMeta.__index = configMeta

function configMeta:GetValue()
    return self:GetInternal()
end

function configMeta:SetValue(value, noNetwork)
    self:SetInternal(value, noNetwork)
end

function configMeta:GetInternal()
    local nameSpace = self.NameSpace
    local key = self.Key

    if nameSpace == nil or key == nil then return end

    configTable[nameSpace] = configTable[nameSpace] or {}

    local value = configTable[nameSpace][key]
    if value == nil then
        local default = (getEntryInfo(nameSpace, key) or {}).Default

        if default then
            set(nameSpace, key, default)

            value = default
        end
    end

    return value
end

function configMeta:SetInternal(value, noNetwork)
    local nameSpace = self.NameSpace
    local key = self.Key

    if nameSpace == nil or key == nil then return end

    configTable[nameSpace] = configTable[nameSpace] or {}
    configTable[nameSpace][key] = value

    RiceLib.Config.SaveConfig("ricelib", nameSpace, configTable[nameSpace])

    if noNetwork then return end
    if self.Shared then
        self:SendToServer()
    end

    hook.Run("RiceLib_ConfigManager_ValueChanged", nameSpace, key, value)
end

function configMeta:SendToServer()
    local nameSpace = self.NameSpace
    local key = self.Key
    local value = self:GetValue()

    if CLIENT then
        if not checkAdminLevel(LocalPlayer(), self.AdminLevel) then return end

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

function RiceLib.Config.GetMetaTable()
    return configMeta
end

function RiceLib.Config.RegisterConfigType(type, displayName, meta)
    configTypes[type] = {
        DisplayName = displayName,
        MetaTable = meta or configMeta
    }

    PrintTable(configTypes)
end

---@class RiceLib_ConfigInfo
---@field Type? string
---@field Default? string
---@field Category? string
---@field DisplayName? string
---@field Min? number
---@field Max? number
---@field TellServer? boolean Make client config value avaliable for server, cannot be use with Shared
---@field Shared? boolean Make this config be shared across server and client, cannot be use with TellServer
---@field AdminLevel? AdminLevel Admin level needed to change Shared config
---@field UseGUI? boolean Make config avaliable in config manager
local baseEntryInfo = {
    Type = "Number",
    Default = 0,
    Category = "DefaultCategory",
    DisplayName = "UnknownSetting",

    Min = 0,
    Max = math.huge,

    TellServer = false,
    Shared = false,

    AdminLevel = 1,

    UseGUI = true,
}

---@class RiceLib_NameSpaceInfo
---@field Author? string
local baseNameSpaceInfo = {
    DisplayName = "Unknown",
    Author = "Unknown"
}

---@param info RiceLib_NameSpaceInfo
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

local ingoreTypes = {
    FunctionEntry = true
}

---comment
---@param nameSpace string
---@param key string
---@param info RiceLib_ConfigInfo
---@return RiceLib_Config configObject
function RiceLib.Config.Define(nameSpace, key, info)
    if not configEntrys[nameSpace] then configEntrys[nameSpace] = {} end

    info = RiceLib.table.InheritCopy(info, baseEntryInfo)
    info.NameSpace = nameSpace
    info.Key = key
    configEntrys[nameSpace][key] = info

    local configMeta = configMeta
    local typeInfo = configTypes[info.Type]
    if typeInfo then
        configMeta = typeInfo.MetaTable
        info.TypeInfo = typeInfo
    end

    setmetatable(info, configMeta)

    if not configCategorys[nameSpace] then configCategorys[nameSpace] = {} end
    if not table.HasValue(configCategorys[nameSpace], info.Category) then
        table.insert(configCategorys[nameSpace], info.Category)
    end

    if ingoreTypes[info.Type] then
        return info
    end

    if not configTable[nameSpace] then
        configTable[nameSpace] = {}
    end

    if configTable[nameSpace][key] == nil then
        info:SetValue(info.Default, true)
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

-- MARK: File based Tree config

local nodeMeta = {}
nodeMeta.__index = nodeMeta

function nodeMeta:Initialize(path, isRoot)
    self.Path = path
    self.FileName = ""
    self.Children = {}
    self.Values = {}
    self.IsRoot = isRoot or false

    if not isRoot then return end

    self.Structure = RiceLib.Config.LoadConfig("ricelib/config_tree", path, {})
    self.NodeLookupTable = {}
end

function nodeMeta:GetRoot()
    if self.Parent then
        return self.Parent:GetRoot()
    end

    return self
end

function nodeMeta:GetFilePath()
    return Format("%s/%s", string.TrimRight(self.Path, "/"), self.FileName)
end

function nodeMeta:UpdateStructure()
    local root = self:GetRoot()
    local structure = root.Structure

    RiceLib.Table.Travers(structure, self:GetFilePath(), true)
    RiceLib.Config.SaveConfig("ricelib/config_tree", root.Path, structure)
end

function nodeMeta:LoadStructure(nodes)
    if not nodes then
        _, nodes = next(self.Structure)
    end

    for nodeID, children in pairs(nodes) do
        self:NewNode(nodeID, true)
    end
end

function nodeMeta:Load()
    self.Values = RiceLib.Config.LoadConfig("ricelib/config_tree_data/" .. self:GetFilePath(), self.FileName, {})
end

function nodeMeta:Save()
    RiceLib.Config.SaveConfig("ricelib/config_tree_data/" .. self:GetFilePath(), self.FileName, self.Values)
end

function nodeMeta:NewNode(name, noUpdate)
    local node = {}
    setmetatable(node, nodeMeta)
    node:Initialize()

    local path = self:GetFilePath()
    if self.IsRoot then
        path = self.Path
    end

    node.Path = path
    node.FileName = name
    node.Parent = self

    if not noUpdate then
        node:UpdateStructure()
    end

    self:GetRoot().NodeLookupTable[node:GetFilePath()] = node

    node:Load()

    self.Children[name] = node

    return node
end

function nodeMeta:GetNode(path)
    return self.NodeLookupTable[Format("%s/%s", self.Path, path)]
end

function RiceLib.Config.CreateTree(root)
    local node = {}
    setmetatable(node, nodeMeta)
    node:Initialize(root, true)
    node.IsRoot = true

    return node
end

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

        if SERVER and not checkAdminLevel(ply, configEntrys[nameSpace][key].AdminLevel) then return end

        set(nameSpace, key, value, CLIENT)
    end
})
