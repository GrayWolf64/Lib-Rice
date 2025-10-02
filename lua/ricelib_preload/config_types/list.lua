local meta = table.Copy(RiceLib.Config.GetMetaTable())

function meta:AddValue(value)
    local configTable = RiceLib.Config.All

    local nameSpace = self.NameSpace
    local key = self.Key

    if nameSpace == nil or key == nil then return end

    configTable[nameSpace] = configTable[nameSpace] or {}

    table.insert(configTable[nameSpace][key], value)

    RiceLib.Config.SaveConfig("ricelib", nameSpace, configTable[nameSpace])

    if noNetwork then return end
    if self.Shared then
        self:SendToServer()
    end

    hook.Run("RiceLib_ConfigManager_ValueChanged", nameSpace, key, value)
end

function meta:RemoveValue(index)
    local configTable = RiceLib.Config.All

    local nameSpace = self.NameSpace
    local key = self.Key

    if nameSpace == nil or key == nil then return end

    configTable[nameSpace] = configTable[nameSpace] or {}

    table.remove(configTable[nameSpace][key], index)

    RiceLib.Config.SaveConfig("ricelib", nameSpace, configTable[nameSpace])

    if noNetwork then return end
    if self.Shared then
        self:SendToServer()
    end

    hook.Run("RiceLib_ConfigManager_ValueChanged", nameSpace, key, value)
end

RiceLib.Config.RegisterConfigType("List", "列表", meta)
