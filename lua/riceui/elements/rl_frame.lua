local Element = {}

function Element.Create(data, parent)
    RL.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 500,
        h = 300,

        TitleColor = Color(25, 25, 25),
        CloseButtonColor = Color(255, 255, 255),

        OnClose = function() end,

        Padding = {5, 35, 5, 5},

        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_Frame",
            Color = "white",
            TextColor = "white"
        },
    })

    local panel = vgui.Create("EditablePanel", parent)
    panel:SetPos(RL.hudScale(data.x, data.y))
    panel:SetSize(RL.hudScale(data.w, data.h))
    panel:SetText("")
    panel.ProcessID = "RL_Frame"
    panel.IsBase = true

    function panel:Think()
        local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
        local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

        if self.Dragging then
            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]
            self:SetPos(x, y)
        end
    end

    function panel:OnMousePressed()
        local _, screenY = self:LocalToScreen(0, 0)

        if gui.MouseY() < (screenY + self.Title:GetTall() + 5) then
            self.Dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}

            self:MouseCapture(true)

            return
        end
    end

    function panel:OnMouseReleased()
        self.Dragging = nil
        self:MouseCapture(false)
    end

    panel.Title = RiceUI.SimpleCreate({type = "label",
        Font = "OPPOSans_20",
        Text = data.Text or "标题",

        x = 5,
        y = 5,

        Color = data.TitleColor
    }, panel)

    panel.CloseButton = RiceUI.SimpleCreate({type = "rl_button",
        Font = panel.Title:GetFont(),
        Text = "X",

        x = data.w - 50,
        y = 0,

        w = 50,
        h = panel.Title:GetTall() + 10,

        Theme = {TypeOverride = "CloseButton"},

        DoClick = function()
            if panel.NoClose then return end

            panel:AlphaTo(0, 0.075, 0, function()
                panel:Remove()
            end)

            panel.OnClose()
        end
    }, panel)

    function panel.CloseButton:Resize()
        self:SetTall(panel.Title:GetTall() + 5)
    end

    function panel:ChildCreated()
        if self.UseNewTheme then
            RiceUI.ApplyTheme(self)

            return
        end

        if not self.GTheme then return end
        local Theme = RiceUI.GetTheme(self.GTheme.name)

        for _, child in ipairs(self:GetChildren()) do
            if not child.GThemeType then continue end
            if child.NoGTheme then continue end

            if Theme[child.GThemeType] then
                child.Paint = Theme[child.GThemeType]
                child.Theme = child.Theme or {}
                table.Merge(child.Theme, self.GTheme.Theme)
            end
        end
    end

    function panel.RiceUI_Event(self, name, id, data)
        if panel:GetParent().RiceUI_Event then
            panel:GetParent():RiceUI_Event(name, id, data)
        end

        if not isfunction(self.GetChildren) then return end

        for _, pnl in ipairs(self:GetChildren()) do
            if pnl.IsBase then continue end
            if pnl.RiceUI_Event == nil then continue end
            pnl:RiceUI_Event(name, id, data)
        end
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element