if SERVER then
    gameevent.Listen( "player_activate" )
    hook.Add( "player_activate", "RL_ClientReady", function( data )
        hook.Run("RL_ClientReady", Player(data.userid))
    end )
end