if SERVER then
    if not RiceLib.Config.Get("LibRice", "RiceLib.PlayerRecord.Enable") then return end

    sql.Query("CREATE TABLE IF NOT EXISTS LibRice_PlayerRecord ( SteamID TEXT PRIMARY KEY NOT NULL, Name TEXT, LastSpawn TEXT, LastDisconnect TEXT)")

    local function playerConnect(ply)
        local steamID = ply:SteamID()

        local exists = sql.Query("SELECT * FROM LibRice_PlayerRecord WHERE SteamID = '" .. steamID .. "'")
        if not exists then
            sql.Query(string.format("INSERT INTO LibRice_PlayerRecord (SteamID, Name, LastSpawn) VALUES ('%s', '%s', date('now'))", steamID, ply:Name()))

            return
        end

        sql.Query(string.format("UPDATE LibRice_PlayerRecord SET Name = '%s', LastSpawn = date('now') WHERE SteamID = '%s'", ply:Name(), steamID))
    end

    local function playerDisconnect(ply)
        local steamID = ply:SteamID()

        sql.Query(string.format("UPDATE LibRice_PlayerRecord SET Name = '%s', LastDisconnect = date('now') WHERE SteamID = '%s'", ply:Name(), steamID))
    end

    local function getBySteamID(steamID)
        return sql.QueryValue(string.format("SELECT Name FROM LibRice_PlayerRecord WHERE SteamID = '%s'", steamID))
    end

    RiceLib.Net.RegisterResponsiveReceiver("RL_PlayerRecord", {
        GetBySteamID = getBySteamID
    })

    RiceLib.PlayerRecord = {
        GetBySteamID = getBySteamID
    }

    hook.Add("PlayerSpawn", "LibRice_PlayerSpawn", function(ply)
        playerConnect(ply)
    end)

    hook.Add("PlayerDisconnected", "LibRice_PlayerDisconnect", function(ply)
        playerDisconnect(ply)
    end)
else
    local function getBySteamID_CL(steamID, callback)
        RiceLib.Net.Responsive({
            NameSpace = "RL_PlayerRecord",
            Command = "GetBySteamID",
            Data = steamID,
            Callback = callback
        })
    end

    RiceLib.PlayerRecord = {
        GetBySteamID = getBySteamID_CL
    }
end