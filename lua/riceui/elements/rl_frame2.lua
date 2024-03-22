local Element = {}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 1200,
        h = 700,

        Title = "Frame",
        Font = "RiceUI_M_24",

        OnClose = function() end,
        DoClose = function(self)
            if self.NoClose then return end

            self:RiceUI_Animation("FadeOut")
            self:OnClose()
        end,

        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_Frame2",
            Color = "white",
            TextColor = "white"
        },
    })

    local panel = RiceUI.SimpleCreate({type = "rl_panel",
        UseNewTheme = true,
        Theme = data.Theme,

        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        Alpha = 0,

        Anim = {
            {
                type = "alpha",
                time = 0.075,
                alpha = 255
            }
        },

        children = {
            {type = "rl_panel",
                ID = "TabBar",

                Dock = TOP,
                h = 45,

                Theme = {
                    ThemeType = "NoDraw"
                },

                ThemeNT = {
                    Class = "TabBar"
                },

                OnMousePressed = function(self)
                    local root = self:GetParent()

                    root.Dragging = {gui.MouseX() - root:GetX(), gui.MouseY() - root:GetY()}

                    self:MouseCapture(true)
                end,

                OnMouseReleased = function(self)
                    local root = self:GetParent()
                    root.Dragging = nil
                    
                    self:MouseCapture(false)
                end,

                children = {
                    {type = "label",
                        ID = "Title",
                        Text = data.Title,
                        Font = data.Font,
                        Dock = LEFT,
                        Margin = {16, 0, 0, 0}
                    },

                    {type = "rl_button",
                        ID = "CloseButton",

                        Dock = RIGHT,
                        Margin = {0, 0, 0, 10},
                        w = 50,

                        Text = data.Title,

                        Theme = {
                            ThemeType = "CloseButton"
                        },

                        ThemeNT = {
                            Class = "Button",
                            Style = "Close"
                        },

                        DoClick = function(self)
                            self:GetParent():GetParent():DoClose()
                        end
                    },

                    {type = "rl_button",
                        ID = "CenterButton",

                        Dock = RIGHT,
                        Margin = {0, 0, 0, 10},
                        w = 50,

                        Text = "田",

                        Theme = {
                            ThemeType = "TransButton",
                            Corner = {false, false, false, false}
                        },

                        ThemeNT = {
                            Class = "Button",
                            Style = "Transparent"
                        },

                        DoClick = function(self)
                            self:GetParent():GetParent():Center()
                        end
                    },
                }
            },
        }
    }, parent)

    function panel:Think()
        if self.Dragging then
            local parent = self:GetParent()

            local mousex = gui.MouseX()
            local mousey = gui.MouseY()
            local x = math.Clamp(mousex - self.Dragging[1], 0, parent:GetWide() - self:GetWide())
            local y = math.Clamp(mousey - self.Dragging[2], 0, parent:GetTall() - self:GetTall())

            self:SetPos(x, y)
        end
    end

    function panel:Clear()
        for _, panel in ipairs(self:GetChildren()) do
            if panel:GetParent().ID and panel:GetParent().ID == "TabBar" then continue end
            if panel.ID and panel.ID == "TabBar" then continue end

            panel:Remove()
        end
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element