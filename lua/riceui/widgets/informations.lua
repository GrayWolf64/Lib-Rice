RiceUI.DefineWidget("RiceUI_PlayerProfileBadge", function(data, parent, root)
    local textSize = math.max(RiceLib.VGUI.TextWide("Source_36", data.Player:Name()), RiceLib.VGUI.TextWide("RiceUI_24", team.GetName(data.Player:Team())))

    local tbl = RiceLib.table.InheritCopy(data, {type = "rl_panel",
        x = 16,
        y = 16,
        w = 256,
        h = 84,

        ThemeNT = {
            Style = "Control",
            StyleSheet = {
                Radius = 32,
            }
        },

        children = {
            {type = "player_profile",
                Class = "Custom",

                Dock = LEFT,
                Margin = {12, 12, 0, 12},
                w = (data.h or 84) - 24,

                PrePaint = function(self, w, h)
                    RiceLib.Render.StartStencil()

                    RiceLib.Draw.Circle(w / 2, h / 2, w / 2, 32, color_white)

                    render.SetStencilCompareFunction(STENCIL_EQUAL)
                    render.SetStencilFailOperation(STENCIL_KEEP)
                end,

                PostPaint = function(self, w, h)
                    render.SetStencilEnable(false)
                end,

                Player = data.Player,
                SteamID = data.SteamID,
            },

            {type = "rl_panel",
                Dock = LEFT,
                Margin = {16, 12, 0, 12},
                w = textSize,

                ThemeNT = {
                    Class = "NoDraw",
                },

                children = {
                    {type = "label",
                        Dock = TOP,
                        Text = data.Player:Name(),
                        Font = "Source_36"
                    },

                    {type = "label",
                        Dock = BOTTOM,

                        ShouldCreate = function()
                            return not data.Desrciption
                        end,

                        ThemeNT = {
                            ColorOverrides = {
                                Text = {
                                    Primary = team.GetColor(data.Player:Team())
                                }
                            }
                        },

                        Text = team.GetName(data.Player:Team()),
                        Font = "RiceUI_24"
                    },

                    {type = "label",
                        Dock = BOTTOM,

                        ShouldCreate = function()
                            return data.Desrciption
                        end,

                        ThemeNT = {
                            ColorOverrides = {
                                Text = {
                                    Primary = data.DescriptionColor or color_white
                                }
                            }
                        },

                        Text = data.Description,
                        Font = "RiceUI_24"
                    },
                }
            }
        }
    })

    tbl.widget = nil

    local capsle = RiceUI.SimpleCreate(tbl, parent, root)
    if not tbl.NoResize then
        capsle:FitContents_Horizontal(RiceUI.Scale.Size(24))
    end

    return capsle
end)

local notFound = Material("vgui/avatar_default.vmt")
RiceUI.DefineWidget("RiceUI_CustomProfileBadge", function(data, parent, root)
    local textSize = math.max(RiceLib.VGUI.TextWide("Source_36", data.Name), RiceLib.VGUI.TextWide("RiceUI_24", data.Description))

    local tbl = RiceLib.table.InheritCopy(data, {type = "rl_panel",
        x = 16,
        y = 16,
        w = 256,
        h = 84,

        ThemeNT = {
            Style = "Control",
            StyleSheet = {
                Radius = 32,
            }
        },

        Material = data.Material,

        children = {
            {type = "rl_panel",
                Dock = LEFT,
                Margin = {12, 12, 0, 12},
                w = (data.h or 84) - 24,

                ThemeNT = {
                    Class = "NoDraw",
                    Style = "Custom",
                    StyleSheet = {
                        Draw = function(self, w, h)
                            RiceLib.Render.StartStencil()

                            RiceLib.Draw.Circle(w / 2, h / 2, w / 2, 32, color_white)

                            render.SetStencilCompareFunction(STENCIL_EQUAL)
                            render.SetStencilFailOperation(STENCIL_KEEP)

                            local mat = self:GetParent().Material
                            if not mat or mat:IsError() then
                                mat = notFound
                            end

                            surface.SetMaterial(mat)
                            surface.SetDrawColor(color_white)
                            surface.DrawTexturedRect(0, 0, w, h)

                            render.SetStencilEnable(false)
                        end
                    }
                }
            },

            {type = "rl_panel",
                Dock = LEFT,
                Margin = {16, 12, 0, 12},
                w = textSize,

                ThemeNT = {
                    Class = "NoDraw",
                },

                children = {
                    {type = "label",
                        Dock = TOP,

                        ThemeNT = {
                            ColorOverrides = {
                                Text = {
                                    Primary = data.NameColor or color_white
                                }
                            }
                        },

                        Text = data.Name,
                        Font = "Source_36"
                    },

                    {type = "label",
                        Dock = BOTTOM,

                        ThemeNT = {
                            ColorOverrides = {
                                Text = {
                                    Primary = data.DescriptionColor or color_white
                                }
                            }
                        },

                        Text = data.Description,
                        Font = "RiceUI_24"
                    },
                }
            }
        }
    })

    tbl.widget = nil

    local capsle = RiceUI.SimpleCreate(tbl, parent, root)

    if not tbl.NoResize then
        capsle:FitContents_Horizontal(RiceUI.Scale.Size(24))
    end

    return capsle
end)

RiceUI.Examples.Register("Widgets_Informations", {
    {type = "rl_frame2",
        Center = true,
        Root = true,

        w = 1200,
        h = 768,

        ThemeNT = {
            Theme = "Modern",
            Class = "Frame",
            Color = "black"
        },

        Title = "Information Widgets",

        children = {
            {widget = "RiceUI_PlayerProfileBadge",
                x = 24,
                y = 64,

                Player = LocalPlayer()
            },

            {widget = "RiceUI_CustomProfileBadge",
                x = 24,
                y = 164,

                Name = "稻谷MCUT",
                Description = "Developer",

                Material = RiceLib.URLMaterial.Get("CustomProfileExample", "http://q1.qlogo.cn/g?b=qq&nk=2950767658&s=100")
            },
        }
    }
})

local alerts = {}

RiceUI.DefineWidget("RiceUI_CursorAlert", function(data, parent)
    local x, y = input.GetCursorPos()

    local alert = RiceUI.SimpleCreate({type = "rl_panel",
        PaintManually = true,
        h = 40,

        UseNewTheme = true,
        ThemeNT = {
            Theme = "Modern",
            Class = "Panel",
            Style = "Acrylic",
            StyleSheet = {
                Blur = 3,
            }
        },

        ShouldRemove = SysTime() + 2,

        Think = function(self)
            if self.ShouldRemove and SysTime() > self.ShouldRemove then
                self:RiceUI_AlphaTo{
                    Alpha = 0,
                    Time = RiceUI.Animation.GetTime("Normal"),

                    Callback = function()
                        if IsValid(self) then
                            self:Remove()
                        end
                    end
                }
            end
        end,

        children = {
            {type = "label",
                x = 16,
                y = 8,
                h = 24,

                Text = data.Text or "!",
                Font = "RiceUI_24",
            }
        }
    })

    alert:FitContents_Horizontal(RICEUI_SIZE_16)

    surface.PlaySound("glide/ui/radar_alert.wav")

    table.insert(alerts, alert)
end)

hook.Add("PostRenderVGUI", "RiceUI_CursorAlert_Think", function()
    local x, y = input.GetCursorPos()
    local height = RiceUI.Scale.Size(48)

    for index, alert in ipairs(alerts) do
        if not IsValid(alert) then
            table.remove(alerts, index)

            break
        else
            local scale = 1
            local prevAlert = alerts[index - 1]

            if IsValid(prevAlert) then
                scale = prevAlert:GetAlpha() / 255
            end

            alert:PaintAt(x - alert:GetWide() / 2, y - height * scale - (index - 1) * height + RICEUI_SIZE_8)
        end
    end
end)
