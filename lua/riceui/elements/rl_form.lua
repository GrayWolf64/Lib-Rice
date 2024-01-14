local Element = {}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 300,
        h = 40,
        Text = "Form 1",
        Font = "OPSans_30",

        Theme = {
            ThemeName = "modern",
            ThemeType = "Form",
            Color = "white",
            TextColor = "white"
        },
    })

    local panel = vgui.Create("DButton", parent)
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetText("")
    panel:DockPadding(RiceLib.hudScaleX(5), RiceLib.hudScaleY(data.h), RiceLib.hudScaleX(5), 0)
    panel.ProcessID = "RL_Form"
    panel.a_pointang = 0
    panel.Init_H = RiceLib.hudScaleY(data.h)

    panel.Header = RiceUI.SimpleCreate({
        type = "label",
        Font = data.Font,
        Text = data.Text,
        x = 10,
        y = 5
    }, panel)

    function panel:ChildCreated()
        if self.Theme.ThemeName == nil then return end

        RiceUI.ApplyTheme(self)
    end

    function panel:Clear()
        for _, v in pairs(self:GetChildren()) do
            if v == self.Header then continue end
            v:Remove()
        end
    end

    function panel:DoClick()
        self:DoAnim()
    end

    function panel:DoAnim()
        if self.Expand then
            self:SizeTo(-1, data.h, 0.3, 0, 0.3)
        else
            self:DoExpand()
        end

        local anim = self:NewAnimation(0.3, 0, 0.2)
        self.Expand = not self.Expand

        anim.Think = function(_, pnl, fraction)
            if not self.Expand then
                panel.a_pointang = -180 + (180 * fraction)

                return
            end

            panel.a_pointang = -180 * fraction
        end
    end

    function panel:DoExpand()
        local h = self:GetTall()

        for _, v in ipairs(self:GetChildren()) do
            if v:GetDock() < 1 then continue end
            h = h + v:GetTall()
        end

        self:SizeTo(-1, h + RiceLib.hudScaleY(5), 0.3, 0, 0.3)
    end

    function panel.RiceUI_Event(self, name, id, pnl)
        if panel:GetParent().RiceUI_Event then
            panel:GetParent():RiceUI_Event(name, id, pnl)
        end
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))
    panel.Text = ""

    timer.Simple(0, function()
        if panel.DefaultExpand then
            local h = panel:GetTall()

            for _, v in ipairs(panel:GetChildren()) do
                if v:GetDock() < 1 then continue end
                h = h + v:GetTall()
            end

            panel:SetTall(h + RiceLib.hudScaleY(5))

            panel.Expand = true
            panel.a_pointang = 180
        end
    end)

    return panel
end

return Element