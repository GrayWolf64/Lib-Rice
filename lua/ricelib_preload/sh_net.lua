RL.Net = {}

function RL.Net.AddCommandReceiver(netID, commandHandler)
    net.Receive(netID, function()
        commandHandler[net.ReadString()](net.ReadTable())
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