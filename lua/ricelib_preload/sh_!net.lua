if SERVER then
    util.AddNetworkString("RL_EntityCommand")
    util.AddNetworkString("RL_ResponsiveNet")
end

local function registerCommandReceiver(netID, commandHandler)
    net.Receive(netID, function(_, player)
        local command = net.ReadString()
        local func = commandHandler[command]
        if func == nil then RiceLib.Error("Net Command Not Found: " .. command) return end

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

local function sendEntityCommand(entity, command, data, player)
    if data == nil then return end
    if data.CheckPlayerValid and player == nil then return end

    net.Start("RL_EntityCommand", data.Unreliable)
    net.WriteEntity(entity)
    net.WriteString(command)
    net.WriteTable(data)

    if CLIENT then net.SendToServer() return end
    if IsValid(player) then net.Send(player) return end

    net.Broadcast()
end

net.Receive("RL_EntityCommand", function(_, player)
    local ent = net.ReadEntity()
    if ent.RL_NetCommand == nil then return end

    ent:RL_NetCommand(net.ReadString(), net.ReadTable(), player)
end)

--- Responesive Networking
-- @section ResponesiveNet

local utilCompress = util.Compress
local utilDecompress = util.Decompress
local utilTableToJSON = util.TableToJSON
local utilJSONToTable = util.JSONToTable

local function createMessage(nameSpace, command, data, key, respone)
    local Raw = utilCompress(utilTableToJSON{
        NameSpace = nameSpace,
        Command = command,
        Data = data,
        SessionKey = key,
        IsRespone = respone
    })

    return Raw, #Raw
end

local function parseMessage(Raw, len)
    local data = utilJSONToTable(utilDecompress(Raw, len))

    return data.NameSpace, data.Command, data.Data or {}, data.SessionKey, data.IsRespone
end

local ResponesiveReceivers = {}
local function responsive(args)
    local sessionKey = tostring(SysTime())

    net.Start("RL_ResponsiveNet")
    net.WriteData(createMessage(args.NameSpace, args.Command, args.Data, sessionKey))

    ResponesiveReceivers[sessionKey] = args.Callback

    if CLIENT then net.SendToServer() return end
    net.Send(args.TargetPlayer)
end

local function sendRespone(args)
    net.Start("RL_ResponsiveNet")
    net.WriteData(createMessage(args.NameSpace, args.Command, args.Data, args.SessionKey, true))

    if CLIENT then net.SendToServer() return end
    net.Send(args.TargetPlayer)
end

local ResponesiveCommmands = {
    RiceLib = {
        Ping = function() return "Pong" end
    }
}
local registerResponsiveReceiver = function(nameSpace, commands)
    ResponesiveCommmands[nameSpace] = commands
end

net.Receive("RL_ResponsiveNet", function(len, ply)
    local nameSpace, command, data, sessionKey, isRespone = parseMessage(net.ReadData(len), len)

    if isRespone then
        local callback = ResponesiveReceivers[sessionKey]

        if callback ~= nil then
            callback(data)

            ResponesiveReceivers[sessionKey] = nil
        end

        return
    end

    if ResponesiveCommmands[nameSpace] == nil then
        RiceLib.Error(string.format("Responsive Net NameSpace Not Found: %s", nameSpace))

        return
    end

    local func = ResponesiveCommmands[nameSpace][command]

    if func == nil then
        RiceLib.Error(string.format("Responsive Net Command Not Found: %s - %s", nameSpace, command))

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

RiceLib.Net = {
    RegisterCommandReceiver = registerCommandReceiver,
    SendCommand = sendCommand,
    SendEntityCommand = sendEntityCommand,

    Responsive = responsive,
    RegisterResponsiveReceiver = registerResponsiveReceiver
}

if CLIENT then
    concommand.Add("LibRice_Net_Ping", function()
        responsive({
            NameSpace = "RiceLib",
            Command = "Ping",
            Callback = function(data) print(data) end
        })
    end)
end