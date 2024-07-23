RiceUI = RiceUI or {}

RiceUI.Examples = {
    Modern = {
        {type = "rl_frame2",
            Text = "Example",
            Center = true,
            Root = true,

            w = 1200,
            h = 800,

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
                {type = "button",
                    x = 120,
                    y = 40,
                    w = 100,
                    h = 50,

                    Theme = {ThemeType = "Button_Accent"}
                },
                {type = "entry",
                    x = 10,
                    y = 100,
                    w = 300,
                    h = 30
                },
                {type = "switch",
                    x = 230,
                    y = 38,
                    w = 50,
                    h = 25
                },
                {type = "switch",
                    x = 230,
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
                {type = "rl_frame2",
                    x = 520,
                    y = 40,
                    w = 670,
                    h = 300,

                    Text = "Frame In Frame",

                    Theme = {ThemeType = "RL_Frame2"},

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

                RiceUI.Animation.ExpandFromPos(frame.riceui_elements.Anim_Expand, {
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
                                RiceUI.Animation.Shrink(frame.riceui_elements.Anim_Expand, {
                                    callback = function()
                                        frame.riceui_elements.Anim_Expand:Clear()
                                    end
                                })
                            end
                        }, frame.riceui_elements.Anim_Expand)
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

                    x = 0,
                    y = 0,

                    children = {
                        {type = "label",Text = "This is a 3D Panel"}
                    }
                }
            },

            PaintOver = function(self,w,h)
                local x,y = self:LocalToScreen()

                cam.Start3D(Vector(0,0,34), Angle(90,90,0), 74.5, x, y, w, h, 5)
                    cam.Start3D2D(Vector(-w * 0.05 / 2, h * 0.05 / 2, 0), Angle(180, 180, 180), 0.05)

                    self.riceui_elements.panel:PaintAt(0,0)

                    cam.End3D2D()
                cam.End3D()
            end
        }
    },

    Playground = {
        {type = "rl_frame",
            Center = true,
            Root = true,

            Text = "Playground",

            w = 1280,
            h = 960,

            NoGTheme = true,
            Theme = {},

            children = {
                {type = "rl_panel",
                    y = 40,
                    w = 64,
                    h = 64,

                    Theme = {},

                    Paint = function(self,w,h)
                        surface.SetDrawColor(255,255,255)
                        surface.SetMaterial(Material("gui/colors_dark.png"))
                        RiceLib.Draw.TexturedCircle(w / 2, h / 2, h / 2, h)
                    end
                },

                {type = "rl_frame",
                    w = 256,
                    h = 256,

                    x = 96,
                    y = 48,

                    NoGTheme = true,
                    Theme = {},

                    Text = "Shadow",

                    children = {
                        {type = "slider",
                            ID = "Intensity",

                            Dock = TOP,
                            Margin = {16, 8, 16, 0},

                            Max = 100,
                            Value = 1
                        },

                        {type = "slider",
                            ID = "Spread",

                            Dock = TOP,
                            Margin = {16, 8, 16, 0},

                            Max = 100,
                            Value = 1
                        },

                        {type = "slider",
                            ID = "Blur",

                            Dock = TOP,
                            Margin = {16, 8, 16, 0},

                            Max = 100,
                            Value = 2
                        },

                        {type = "slider",
                            ID = "Alpha",

                            Dock = TOP,
                            Margin = {16, 8, 16, 0},

                            Max = 255,
                            Value = 255
                        },

                        {type = "slider",
                            ID = "Angle",

                            Dock = TOP,
                            Margin = {16, 8, 16, 0},

                            Min = -180,
                            Max = 180,
                            Value = 0,
                        },

                        {type = "slider",
                            ID = "Distance",

                            Dock = TOP,
                            Margin = {16, 8, 16, 0},

                            Max = 100,
                        },
                    },

                    Paint = function(self, w, h)
                        local x, y = self:LocalToScreen()
                        local root = self:RiceUI_GetRoot()

                        local instensity = root:GetElement("Intensity"):GetValue()
                        local spread = root:GetElement("Spread"):GetValue()
                        local blur = root:GetElement("Blur"):GetValue()
                        local alpha = root:GetElement("Alpha"):GetValue()
                        local angle = root:GetElement("Angle"):GetValue()
                        local distance = root:GetElement("Distance"):GetValue()

                        RiceUI.Render.StartShadow()
                        draw.RoundedBox(6, x, y, w, h, color_white)
                        RiceUI.Render.EndShadow(instensity, spread, blur, alpha, angle, distance, true)

                        draw.RoundedBox(6, 0, 0, w, h, color_white)
                    end
                }
            },

            Paint = function(self, w, h)
                local x, y = self:LocalToScreen()

                RiceUI.Render.StartShadow()
                draw.RoundedBox(6, x, y, w, h, color_white)
                RiceUI.Render.EndShadow(1, 2, 2, 255, 0, 0, true)

                draw.RoundedBox(6, 0, 0, w, h, color_white)
            end
        }
    },

    Blur = {
        {type = "rl_frame",
            Center = true,
            Root = true,

            Text = "Playground",

            w = 768,
            h = 512,

            NoGTheme = true,
            Theme = {},

            BlurAmount = 0,

            children = {
                {type = "slider",
                    Min = 0,
                    Max = 16,
                    Value = 0,

                    UseNewTheme = true,
                    Theme = {
                        ThemeName = "modern",
                        ThemeType = "Slider",
                        Color = "black",
                        TextColor = "black",
                    },

                    OnValueChanged = function(self, val)
                        self:GetParent().BlurAmount = self:GetValue()
                    end
                },
            },

            Paint = function(self, w, h)
                RiceLib.VGUI.blurPanel(self, self.BlurAmount)
            end
        }
    },

    ModernNT = {
        {type = "rl_frame2",
            Center = true,
            Root = true,

            ThemeNT = {
                Theme = "Modern",
                Class = "Frame",
                --Style = "Acrylic",
                Color = "black"
            },

            w = 1000,
            h = 800,

            children = {
                {type = "rl_scrollpanel",
                    Dock = LEFT,
                    Margin = {8, 0, 0, 8},
                    w = 256,

                    UseNewTheme = true,
                    ThemeNT = {
                        Theme = "Modern",
                        Class = "NoDraw",
                        Color = "black"
                    },

                    ScrollAmount = 100,

                    OnCreated = function(self)
                        for i = 1, 100 do
                            RiceUI.SimpleCreate({type = "rl_button",
                                Dock = TOP,
                                Margin = {0, 8, 0, 0},
                                h = 48
                            }, self)
                        end

                        RiceUI.ApplyTheme(self)
                    end
                },

                {type = "rl_panel",
                    Dock = LEFT,
                    Margin = {8, 0, 0, 8},
                    w = 296,

                    children = {
                        {type = "entry",
                            Dock = TOP,
                            Margin = {8, 8, 8, 0}
                        }
                    }
                },
            }
        }
    },

    Animations = {
        {type = "rl_frame2",
            Center = true,
            Root = true,

            w = 1200,
            h = 960,

            children = {
                {type = "slider",
                    Dock = TOP,
                    Margin = {16, 0, 16, 0},

                    Min = 1,
                    Max = 10,
                    Decimals = 2,

                    OnValueChanged = function(self, val)
                        RiceUI.Animation.SetRate(self:GetValue())
                    end
                },

                {type = "rl_scrollpanel",
                    ID = "SP",

                    Dock = LEFT,
                    Margin = {0, 0, 16, 0},
                    w = 512,
                },

                {type = "rl_scrollpanel",
                    ID = "SP2",

                    Dock = FILL,
                    Margin = {0, 0, 16, 0}
                }
            },

            OnCreated = function(self)
                local index = 0
                for funcName, func in SortedPairs(math.ease) do
                    if not isfunction(func) then continue end

                    RiceUI.SimpleCreate({type = "rl_button",
                        y = 54 * index,
                        w = 128,

                        Text = funcName,

                        --[[ThemeNT = {
                            Theme = "Modern",
                            Class = "NoDraw",
                            Style = "Custom",
                            StyleSheet = {
                                Draw = function(self, w, h)
                                    local Corner = Corner or {true, true, true, true}
                                    local x, y = self:LocalToScreen()
                                    local unit_1 = RiceUI.Scale.Size(1)
                                    local textColor = self:RiceUI_GetColor("Text", "Primary")

                                    if self:IsHovered() then textColor = self:RiceUI_GetColor("Text", "Secondary") end

                                    local c = HSVToColor((SysTime() % 360) * 300 + self:GetY() / 8, 1, 1)

                                    draw.RoundedBoxEx(8, 0, 0, w, h, c, unpack(Corner))
                                    render.SetScissorRect(x, y + h - unit_1, x + w, y + h, true)
                                    draw.RoundedBoxEx(8, 0, 0, w, h, c, unpack(Corner))
                                    render.SetScissorRect(0, 0, 0, 0, false)

                                    draw.RoundedBoxEx(8, unit_1, unit_1, w - unit_1 * 2, h - unit_1 * 2, self:RiceUI_GetColor("Fill", "Control", "Default"), unpack(Corner))

                                    draw.SimpleText(self.Text, self:GetFont(), w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                                end
                            }
                        },]]

                        DoClick = function(btn)
                            local x = btn:GetPos()
                            if x == RiceUI.Scale.PosX(10) then
                                x = RiceUI.Scale.PosX(372)
                            else
                                x = RiceUI.Scale.PosX(10)
                            end

                            btn:RiceUI_MoveTo{X = x, EaseFunction = func}
                        end
                    }, self:GetElement("SP"))

                    RiceUI.SimpleCreate({type = "rl_button",
                        y = 54 * index,
                        w = 128,

                        Text = funcName,

                        DoClick = function(btn)
                            local w = btn:GetWide()
                            if w == RiceUI.Scale.Size(128) then
                                w = RiceUI.Scale.Size(648)
                                h = RiceUI.Scale.Size(648)
                            else
                                w = RiceUI.Scale.Size(128)
                                h = RiceUI.Scale.Size(48)
                            end

                            btn:RiceUI_SizeTo{W = w, h = H, EaseFunction = func}
                        end
                    }, self:GetElement("SP2"))

                    index = index + 1
                end
            end
        }
    }
}

RiceUI.Examples.ModernBlack = table.Copy(RiceUI.Examples.Modern)

RiceUI.Examples.ModernBlack[1].Theme = {
    ThemeName = "modern",
    ThemeType = "RL_Frame2",
    Color = "black",
    TextColor = "black",
    Shadow = true,
}

local function createSegment(parent, radius)
    local segment = {
        X = 0,
        Y = 0,
        Radius = radius or 16,
        Parent = parent,
        NextUpdate = CurTime()
    }

    function segment:SetPos(x, y)
        self.X = x or self.X
        self.Y = y or self.Y
    end

    function segment:SetPosVector(pos)
        self.X = pos.x or self.X
        self.Y = pos.y or self.Y
    end

    function segment:GetPos()
        return self.X, self.Y
    end

    function segment:GetPosVector()
        return Vector(self.X, self.Y)
    end

    function segment:Draw()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawCircle(self.X, self.Y, self.Radius)

        --RiceLib.Draw.Circle(self.x, self.y, self.radius, 32, color_white)

        if self.Children then
            self:Update()

            self.Children:Draw()
        end
    end

    function segment:Update()
        local children = self.Children
        if not children then return end

        children:SetPosVector(self:GetPosVector() + (children:GetPosVector() - self:GetPosVector()):GetNormalized() * (self.Radius + children.Radius))
    end

    if parent then parent.Children = segment end

    return segment
end

local head = createSegment(_, 24)
local tail = createSegment(createSegment(createSegment(createSegment(createSegment(createSegment(createSegment(head, 22), 23), 20), 20), 20), 18), 16)

local function r(nextSeg, iter)
    if iter > 10 then return end

    r(createSegment(nextSeg or tail), iter + 1)
end

r(rail, 1)

RiceUI.Examples.ProceduralAnimation = {
    {type = "rl_frame2",
        Center = true,
        Root = true,

        ThemeNT = {
            Theme = "Modern",
            Class = "Frame",
            Color = "black"
        },

        children = {
            {type = "rl_canvas",
                Dock = FILL,

                Paint = function(self, w, h)
                    head:Draw()
                end,

                Think = function(self)
                    local x, y = input.GetCursorPos()
                    local lx, ly = self:LocalToScreen()

                    --head:SetPos(x - lx, y - ly)

                    local deltaTime = FrameTime() * 100

                    head:SetPosVector(head:GetPosVector() + (Vector(x - lx, y - ly, 0) - head:GetPosVector()):GetNormalized() * 5 * deltaTime)
                end
            }
        }
    }
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
            {type = "rl_scrollpanel",
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
                            Margin = {0, 0, 0, 5},
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