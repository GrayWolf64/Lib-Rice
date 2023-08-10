local Element = {}
function Element.Create(data,parent)
    local panel = vgui.Create("DButton",parent)
    panel:SetText("")

    function panel:Paint()
    end

    function panel:DoClick()
        gui.OpenURL("https://steamcommunity.com/profiles/" .. self.ply:SteamID64())
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element