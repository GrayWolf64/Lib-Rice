RiceLib.Cache.RiceUI_PopMenus = RiceLib.Cache.RiceUI_PopMenus or {}

local Element = {}
local PopMenus = RiceLib.Cache.RiceUI_PopMenus

function Element.Create(data,parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 300,
        h = 300,

        Theme = {
            ThemeName = "modern",
            ThemeType = "Panel",
            Color = "white",
            TextColor = "white",
        },
    })

    local panel = vgui.Create("DPanel")
    panel:SetPos(data.x, data.y)
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    panel.ProcessID = "RL_PopMenu"

    table.insert(PopMenus, panel)

    function panel:ChildCreated()
        if self.UseNewTheme then
            RiceUI.ApplyTheme(self)

            return
        end

        if self.GTheme == nil then return end
        local Theme = RiceUI.GetTheme(self.GTheme.name)

        for _, child in ipairs(self:GetChildren()) do
            if child.GThemeType == nil then continue end
            if child.NoGTheme then continue end

            if Theme[child.GThemeType] then
                child.Paint = Theme[child.GThemeType]
                child.Theme = child.Theme or {}
                table.Merge(child.Theme, self.GTheme.Theme)
            end
        end
    end

    function panel:OnFocusChanged(gain)
        if not gain then self:Remove() end
    end

    function panel.RiceUI_Event(self,name,id,data)
        if not IsValid(panel.Parent) then return end

        if panel.Parent.RiceUI_Event then
            panel.Parent:RiceUI_Event(name,id,data)
        end
    end

    function panel:OnRemove()
        table.RemoveByValue(PopMenus, self)
    end

    RiceUI.MergeData(panel,RiceUI.ProcessData(data))

    return panel
end

function RiceUI.RemovePopMenus()
    for _, panel in ipairs(PopMenus) do
        if IsValid(panel) then
            panel:Remove()
        end
    end
end

return Element