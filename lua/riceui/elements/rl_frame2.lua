local Element = {}

function Element.Create(data, parent)
    RL.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 1200,
        h = 700,

        Title = "Frame",

        OnClose = function() end,

        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_Frame2",

            Color = "white",
            TextColor = "white"
        },
    })

    local panel = RiceUI.SimpleCreate({type = "rl_panel",
        UseNewTheme = true,
        Theme = Theme,

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

                Theme = {ThemeType = "NoDraw"},

                Dock = TOP,
                h = 45,

                OnMousePressed = function(self)
                    local root = self:GetParent()

                    root.Dragging = {gui.MouseX() - root:GetX(), gui.MouseY() - root:GetY()}
                end,

                OnMouseReleased = function(self)
                    local root = self:GetParent()

                    root.Dragging = nil
                end,

                children = {
                    {type = "label", ID = "Title", Text = data.Title, Font = "RiceUI_M_24", Dock = LEFT, Margin = {16, 0, 0, 0}},
                    {type = "rl_button", ID = "CloseButton", Text = data.Title, Dock = RIGHT, w = 50, Margin = {0, 0, 0, 10},
                        Theme = {ThemeType = "CloseButton"},

                        DoClick = function(self)
                            local panel = self:GetParent():GetParent()

                            if panel.NoClose then return end

                            panel:AlphaTo(0, 0.075, 0, function()
                                panel:Remove()
                            end)

                            panel.OnClose()
                        end
                    },
                }
            },
        }
    }, parent)

    function panel:Think()
        if self.Dragging then
            local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
            local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]
            self:SetPos(x, y)
        end
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element