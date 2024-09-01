local Element = {}

Element.Editor = {
    Category = "display"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 50,
        h = 50,
        Image = "gui/contenticon-normal.png"
    })

    local panel = vgui.Create("DImageButton", parent)
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))

    function panel:SetWorkshopID(id, isPreviewID)
        if not id then return end
        self.WorkshopID = id

        if isPreviewID then
            steamworks.Download(id, true, function(path)
                if not path then return end
                if not IsValid(self) then return end

                self:SetMaterial(AddonMaterial(path))
            end)

            return
        end

        steamworks.FileInfo(id, function(result)
            steamworks.Download(result.previewid, true, function(path)
                if not path then return end
                if not IsValid(self) then return end

                self:SetMaterial(AddonMaterial(path))
            end)
        end)
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    if data.WorkshopID then panel:SetWorkshopID(data.WorkshopID) end

    return panel
end

return Element