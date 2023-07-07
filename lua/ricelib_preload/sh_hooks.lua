if SERVER then
    util.AddNetworkString("RL_ClientReady")

    net.Receive("RL_ClientReady",function(len,ply)
        hook.Run("RL_ClientReady",ply)
    end)
else
    hook.Add("InitPostEntity","RL_ClientReady",function()
        net.Start("RL_ClientReady")
        net.SendToServer()
    end)

    concommand.Add("RL_Hooks_FakeReadyMessage",function()
        net.Start("RL_ClientReady")
        net.SendToServer()
    end)
end