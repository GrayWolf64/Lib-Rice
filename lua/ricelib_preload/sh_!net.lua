RL.Net = {}

function RL.Net.AddCommandReceiver(netID, commandHandler)
    net.Receive(netID, function(len, ply)
        commandHandler[net.ReadString()](net.ReadTable(), ply)
    end)
end

function RL.Net.SendCommand(netID, command, data, ply)
    net.Start(netID)
    net.WriteString(command)
    net.WriteTable(data)

    if CLIENT then net.SendToServer() return end
    if IsValid(ply) then net.Send(ply) return end

    net.Broadcast()
end

function RL.Net.SendEntityCommand(entity, command, data, ply)
    net.Start("RL_EntityCommand")
    net.WriteEntity(entity)
    net.WriteString(command)
    net.WriteTable(data)

    if CLIENT then net.SendToServer() return end
    if IsValid(ply) then net.Send(ply) return end

    net.Broadcast()
end

net.Receive("Rl_EntityCommand", function(len, ply)
    local ent = net.ReadEntity()
    if not ent.RL_NetCommand then return end

    ent:RL_NetCommand(net.ReadString(), net.ReadTable(), ply)
end)

if SERVER then
    util.AddNetworkString("RL_EntityCommand")
end