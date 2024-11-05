if SERVER then
    util.AddNetworkString("RiceLibNet")
    util.AddNetworkString("RiceLibNetReponsive")
end

local function registerCommandReceiver(netID, commandHandler)
    net.Receive(netID, function(_, player)
        local command = net.ReadString()
        local func = commandHandler[command]
        if func == nil then RiceLib.Error("Net Command Not Found: " .. command, "RiceLib Net") return end

        func(net.ReadTable(), player)
    end)
end

local function sendCommand(netID, command, data, player)
    if data == nil then return end
    if data.CheckPlayerValid and player == nil then return end

    net.Start(netID, data.Unreliable)
    net.WriteString(command)
    net.WriteTable(data)

    if CLIENT then net.SendToServer() return end
    if IsValid(player) then net.Send(player) return end

    net.Broadcast()
end

--- Responesive Networking
-- @section ResponesiveNet

local utilCompress = util.Compress
local utilDecompress = util.Decompress
local utilTableToJSON = util.TableToJSON
local utilJSONToTable = util.JSONToTable

local function createResponsiveMessage(nameSpace, command, data, key, respone)
    local Raw = utilCompress(utilTableToJSON{
        NameSpace = nameSpace,
        Command = command,
        Data = data,
        SessionKey = key,
        IsRespone = respone
    })

    return Raw, #Raw
end

local function parseResponsiveMessage(Raw, len)
    local data = utilJSONToTable(utilDecompress(Raw, len))

    return data.NameSpace, data.Command, data.Data or {}, data.SessionKey, data.IsRespone
end

local ResponesiveReceivers = {}
local ResponesiveCommmands = {
    RiceLib = {
        Ping = function() return "Pong" end
    }
}

local function responsive(args)
    local sessionKey = tostring(SysTime())

    net.Start("RiceLibNetReponsive")
    net.WriteData(createResponsiveMessage(args.NameSpace, args.Command, args.Data, sessionKey))

    ResponesiveReceivers[sessionKey] = args.Callback

    if CLIENT then net.SendToServer() return end
    net.Send(args.TargetPlayer or player.GetAll())
end

local function sendRespone(args)
    net.Start("RiceLibNetReponsive")
    net.WriteData(createResponsiveMessage(args.NameSpace, args.Command, args.Data, args.SessionKey, true))

    if CLIENT then net.SendToServer() return end
    net.Send(args.TargetPlayer or player.GetAll())
end

net.Receive("RiceLibNetReponsive", function(len, ply)
    local nameSpace, command, data, sessionKey, isRespone = parseResponsiveMessage(net.ReadData(len), len)

    if isRespone then
        local callback = ResponesiveReceivers[sessionKey]

        if callback ~= nil then
            callback(data, ply)

            ResponesiveReceivers[sessionKey] = nil
        end

        return
    end

    if ResponesiveCommmands[nameSpace] == nil then
        RiceLib.Error(string.format("Responsive Net NameSpace Not Found: %s", nameSpace), "RiceLib Net")

        return
    end

    local func = ResponesiveCommmands[nameSpace][command]

    if func == nil then
        RiceLib.Error(string.format("Responsive Net Command Not Found: %s - %s", nameSpace, command), "RiceLib Net")

        return
    end

    sendRespone({
        NameSpace = nameSpace,
        Command = command,
        Data = func(data, ply),
        SessionKey = sessionKey,
        TargetPlayer = ply
    })
end)


--
-- Basically SendCommand but all parma are table and use compress
--


local Receivers = {}

--[[ Not practical now

local serializers = {
    Entity = function(value) return value:EntIndex() end,
    Player = function(value) return value:EntIndex() end,
}

local function serializeValue(value)
    local valueType = type(value)

    if not serializers[valueType] then return value end

    return serializers[valueType](value)
end

local function serialization(raw)
    if not raw then return end
    if not istable(raw) then return serializeValue(raw) end

    if table.IsSequential(raw) then
        for index, value in ipairs(raw) do
            raw[index] = serializeValue(value)
        end

        return raw
    end

    local serialized = {}

    for key, value in pairs(raw) do
        serialized[serializeValue(key)] = serializeValue(value)
    end

    return serialized
end

]]--

local function createMessage(nameSpace, command, data)
    local Raw = utilCompress(utilTableToJSON{
        NameSpace = nameSpace,
        Command = command,
        Data = data
    })

    return Raw, #Raw
end

local function parseMessage(Raw, len)
    local data = utilJSONToTable(utilDecompress(Raw, len))

    return data.NameSpace, data.Command, data.Data or {}
end

local function send(args)
    net.Start("RiceLibNet", args.Unreliable)
    net.WriteData(createMessage(args.NameSpace, args.Command, args.Data))

    if CLIENT then net.SendToServer() return end
    net.Send(args.TargetPlayer or player.GetAll())
end

local function sendEntityCommand(entity, command, data, player)
    if not IsValid(entity) then return end

    send{
        NameSpace = "RiceLibEntityCommand",
        Command = "Send",
        Data = {entity:EntIndex(), command, data},
        TargetPlayer = player
    }
end

Receivers.RiceLibEntityCommand = {
    Send = function(data)
        local ent, command, data = unpack(data)
        ent = Entity(ent)

        if not ent.RiceLib_EntityNetCommand then RiceLib.Error(Format("Entity: %s Don't have a RiceLib_EntityNetCommand function!"), ent) return end
        ent:RiceLib_EntityNetCommand(command, data, ply)
    end
}

net.Receive("RiceLibNet", function(len, ply)
    local nameSpace, command, data = parseMessage(net.ReadData(len), len)

    local commands = Receivers[nameSpace]
    if not commands then
        RiceLib.Error(string.format("Receiver %s Not Found!", nameSpace), "RiceLib Net")

        return
    end

    local func = commands[command]
    if not func then
        RiceLib.Error(string.format("Command %s Not Found In %s!", command, nameSpace), "RiceLib Net")

        return
    end

    func(data, ply)
end)

RiceLib.Net = {
    RegisterCommandReceiver = registerCommandReceiver,
    SendCommand = sendCommand,
    SendEntityCommand = sendEntityCommand,

    Responsive = responsive,
    RegisterResponsiveReceiver = function(nameSpace, commands) ResponesiveCommmands[nameSpace] = commands end,

    Send = send,
    RegisterReceiver = function(nameSpace, commands) Receivers[nameSpace] = commands end,
}

if CLIENT then
    concommand.Add("ricelib_net_responsive_ping", function()
        responsive({
            NameSpace = "RiceLib",
            Command = "Ping",
            Callback = function(data) print(data) end
        })
    end)

    concommand.Add("ricelib_net_dump_cl", function()
        print("\nResponesiveReceivers")
        PrintTable(ResponesiveCommmands)

        print("\nReceivers")
        PrintTable(Receivers)
    end)
end

concommand.Add("ricelib_net_dump", function()
    print("\nResponesiveReceivers")
    PrintTable(ResponesiveCommmands)

    print("\nReceivers")
    PrintTable(Receivers)
end)