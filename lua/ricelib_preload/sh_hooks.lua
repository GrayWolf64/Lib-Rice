if SERVER then
    util.AddNetworkString("RL_PlayerReady")

    net.Receive("RL_PlayerReady",function(len,ply)
        hook.Run("RL_PlayerReady",ply)
    end)
else
    hook.Add("InitPostEntity","RL_PlayerReady",function()
        net.Start("RL_PlayerReady")
        net.SendToServer()
    end)
end