RiceUI = RiceUI or {}

RiceUI.Examples = {
    Modern = {
        {type = "rl_frame",
            Text = "Example",
            Center = true,
            Root = true,

            w = 1200,
            h = 800,

            UseNewTheme = true,
            Theme = {
                ThemeName = "modern",
                ThemeType = "RL_Frame",
                Color = "white",
                TextColor = "white",
            },

            Alpha = 0,
            Anim = {
                {
                    type = "alpha",
                    time = 0.075,
                    alpha = 255
                }
            },
            children = {
                {type = "button",
                    x = 10,
                    y = 40,
                    w = 100,
                    h = 50
                },
                {type = "entry",
                    x = 10,
                    y = 100,
                    w = 300,
                    h = 30
                },
                {type = "switch",
                    x = 120,
                    y = 38,
                    w = 50,
                    h = 25
                },
                {type = "switch",
                    x = 120,
                    y = 67,
                    w = 50,
                    h = 25,
                    Value = true
                },
                {type = "image",
                    x = 320,
                    y = 40,
                    w = 90,
                    h = 90,
                    Image = "gui/dupe_bg.png"
                },
                {type = "web_image",
                    x = 420,
                    y = 40,
                    w = 90,
                    h = 90,
                    Image = "https://i.328888.xyz/2023/01/29/jM97x.jpeg"
                },
                {type = "rl_numberwang",
                    x = 10,
                    y = 140
                },
                {type = "rl_numberwang",
                    x = 140,
                    y = 140,
                    Step = 5
                },
                {type = "button",
                    ID = "btn_Anim_Expand",
                    Text = "Animation 1",
                    x = 10,
                    y = 180,
                    w = 200,
                    h = 50,
                },
                {type = "button",
                    ID = "btn_Menu",
                    Text = "Menu 1",
                    x = 10,
                    y = 240,
                    w = 200,
                    h = 50,
                    DoClick = function(self)
                        RiceUI.SimpleCreate({
                            type = "rl_menu"
                        })
                    end
                },
                {type = "rl_form",
                    Text = "Form",
                    x = 10,
                    y = 300,
                    children = {
                        {
                            type = "rl_button",
                            Dock = TOP
                        }
                    }
                },
                {type = "rl_panel",
                    ID = "Anim_Expand",
                    w = 0,
                    h = 0,
                    NoGTheme = true,
                    Theme = {
                        ThemeName = "modern",
                        ThemeType = "Panel",
                        Color = "black"
                    },
                },
                {type = "rl_colorbutton",
                    x = 10,
                    y = 405,
                },
                {type = "rl_frame",
                    x = 520,
                    y = 40,
                    w = 670,
                    Text = "Frame In Frame",

                    children = {
                        {type = "slider",
                            y = 40
                        },
                        {type = "rl_combo",
                            y = 80,
                            Choice = {
                                {"选项1"},
                                {"选项2"},
                                {"选项3"}
                            }
                        },
                        {type = "rl_button", x = 220, y = 80, h = 40,
                            Text = "Message",

                            DoClick = function() RunConsoleCommand("riceui_notify_message","Message") end
                        },

                        {type = "rl_button", x = 220, y = 130, h = 40,
                            Text = "Warning",

                            DoClick = function() RunConsoleCommand("riceui_notify_warn","WARNING!") end
                        },

                        {type = "rl_button", x = 220, y = 180, h = 40,
                            Text = "Error",

                            DoClick = function() RunConsoleCommand("riceui_notify_error","ERROR!") end
                        },
                    },
                },
            },
            RiceUI_Event = function(event, id, data)
                if id ~= "btn_Anim_Expand" then return end
                local frame = data:GetParent()

                RiceUI.Animation.ExpandFromPos(frame.Elements.Anim_Expand, {
                    StartX = gui.MouseX() - frame:GetX(),
                    StartY = gui.MouseY() - frame:GetY(),
                    EndX = 0,
                    EndY = 30,
                    SizeW = 1200,
                    SizeH = 770,
                    callback = function()
                        RiceUI.SimpleCreate({type = "rl_button",
                            Center = true,
                            DoClick = function()
                                RiceUI.Animation.Shrink(frame.Elements.Anim_Expand, {
                                    callback = function()
                                        frame.Elements.Anim_Expand:Clear()
                                    end
                                })
                            end
                        }, frame.Elements.Anim_Expand)
                    end
                })
            end
        }
    },

    Panel_3D = {
        {type = "rl_frame",
            Center = true,
            Root = true,

            w = 1000,
            h = 800,

            children = {
                {type = "rl_3dpanel",
                    Theme = {ThemeName = "modern", ThemeType = "Panel", Color = "white"},
                    ID = "panel",
                    DrawBorder = true,

                    children = {
                        {type = "label",Text = "This is a 3D Panel"}
                    }
                }
            },

            PaintOver = function(self,w,h)
                local x,y = self:LocalToScreen()
                local cx,cy = self:CursorPos()
                local cx1,cy1 = w / 2-cx,h / 2-cy

                cam.Start3D(Vector(0,0,60), Angle(90,90,0), 70,x, y, w, h, 5)
                    cam.Start3D2D(Vector(-25,20,0),Angle(-cx1 / w * 180, 0, -cy1 / w * 180),0.1)

                    self.Elements.panel:PaintAt(0,0)

                    cam.End3D2D()
                cam.End3D()
            end
        }
    },

    Playground = {
        {type = "rl_frame",
            Center = true,
            Root = true,

            w = 1000,
            h = 800,

            children = {
                {type = "rl_panel",
                    y = 40,
                    w = 64,
                    h = 64,

                    Theme = {},

                    Paint = function(self,w,h)
                        surface.SetDrawColor(255,255,255)
                        surface.SetMaterial(Material("gui/colors_dark.png"))
                        RL.Draw.TexturedCircle(w / 2, h / 2, h/2, h)
                    end
                }
            }
        }
    }
}

RiceUI.Examples.ModernBlack = table.Copy(RiceUI.Examples.Modern)

RiceUI.Examples.ModernBlack[1].Theme = {
    ThemeName = "modern",
    ThemeType = "RL_Frame",
    Color = "black",
    TextColor = "black",
    Shadow = true,
}

concommand.Add("riceui_examples", function()
    RiceUI.SimpleCreate({type = "rl_frame",
        Text = "Examples",
        Center = true,
        Root = true,
        Alpha = 0,
        w = 400,
        h = 600,

        UseNewTheme = true,
        Theme = {
            ThemeName = "modern",
            ThemeType = "RL_Frame",
            Color = "black1",
            TextColor = "black1",
            Shadow = true,
        },

        Anim = {
            {
                type = "alpha",
                time = 0.075,
                alpha = 255
            }
        },

        children = {
            {type = "scrollpanel",
                ID = "ScrollPanel",
                x = 10,
                y = 40,
                w = 380,
                h = 550,
                OnCreated = function(pnl)
                    for k, v in SortedPairs(RiceUI.Examples) do
                        pnl:AddItem(RiceUI.SimpleCreate({type = "rl_button",
                            Dock = TOP,
                            h = 50,
                            Margin = {0, 0, 5, 5},
                            Text = k,

                            Theme = {
                                ThemeType = "Button",
                                ThemeName = "modern_rect",
                                Color = "white"
                            },

                            DoClick = function()
                                RiceUI.Create(RiceUI.Examples[k])
                            end
                        }, pnl))
                    end
                end
            },
        },
    })
end)