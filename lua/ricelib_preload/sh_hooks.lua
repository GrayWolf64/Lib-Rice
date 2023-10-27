--[[ Player Entity is'nt properly initialized so change it to old version
if SERVER then
    gameevent.Listen( "player_activate" )
    hook.Add( "player_activate", "RL_ClientReady", function( data )
        hook.Run("RL_ClientReady", Player(data.userid))
    end )
end
]]

if SERVER then
    util.AddNetworkString("RL_ClientReady")

    net.Receive("RL_ClientReady", function(_, ply)
        hook.Run("RL_ClientReady", ply)
    end)
else
    hook.Add("InitPostEntity", "RL_ClientReady", function()
        net.Start("RL_ClientReady")
        net.SendToServer()
    end)

    concommand.Add("RL_Hooks_FakeReadyMessage", function()
        net.Start("RL_ClientReady")
        net.SendToServer()
    end)
end