local Element = {}
function Element.Create(data,parent)
    data.ply = data.ply or data.Player

    local panel = vgui.Create("DButton",parent)
    panel:SetText("")

    function panel:Paint()
    end

    function panel:DoClick()
        self.ply:ShowProfile()
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

return Element