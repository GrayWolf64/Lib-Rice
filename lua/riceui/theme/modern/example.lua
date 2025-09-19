RiceUI.Examples.Register("ModernNT", {
    {type = "rl_frame2",
        Center = true,
        Root = true,

        ThemeNT = {
            Theme = "Modern",
            Class = "Frame",
            Style = "Acrylic",
            Color = "white"
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

                ScrollSpeed = 3,

                OnCreated = function(self)
                    for i = 1, 100 do
                        RiceUI.SimpleCreate({type = "rl_button",
                            Dock = TOP,
                            Margin = {0, 0, 0, 8},
                            h = 48,

                            Text = "按钮" .. i
                        }, self)
                    end

                    RiceUI.ApplyTheme(self)
                end
            },

            {type = "rl_panel",
                Dock = LEFT,
                Margin = {8, 0, 0, 8},
                w = 296,

                ThemeNT = {
                    Class = "Layer"
                },

                children = {
                    {widget = "labeled_switch",
                        Dock = TOP,
                        Margin = {16, 16, 16, 0},
                        h = 32,

                        Text = "暗色模式",

                        OnValueChanged = function(self, val)
                            local root = self:RiceUI_GetRootPanel()

                            root.ThemeNT.Color = "white"

                            if val then root.ThemeNT.Color = "black" end

                            RiceUI.ApplyTheme(root)
                        end
                    },

                    {widget = "labeled_switch",
                        Dock = TOP,
                        Margin = {16, 16, 16, 0},
                        h = 32,

                        Text = "开关",

                        OnValueChanged = function(self, val)
                        end
                    },

                    {type = "entry",
                        Dock = TOP,
                        Margin = {16, 16, 16, 0},
                        h = 32,
                    },

                    {type = "rl_panel",
                        Dock = TOP,
                        Margin = {16, 16, 16, 0},
                        h = 32,

                        ThemeNT = {
                            Class = "NoDraw"
                        },

                        children = {
                            {type = "rl_combo",
                                Dock = RIGHT,
                                w = 128,

                                Choice = {
                                    {"红", "red and"},
                                    {"蓝", "blue and"},
                                    {"绿", "green"}
                                }
                            },

                            {type = "label",
                                Dock = LEFT,

                                Text = "多项选择",
                                Font = "RiceUI_M_24",
                            }
                        }
                    },

                    {type = "rl_panel",
                        Dock = TOP,
                        Margin = {16, 16, 16, 0},
                        h = 32,

                        ThemeNT = {
                            Class = "NoDraw"
                        },

                        children = {
                            {type = "rl_slider",
                                Dock = RIGHT,
                                Margin = {0, 6, 0, 6},
                                w = 128,
                            },

                            {type = "label",
                                Dock = LEFT,

                                Text = "滑动条",
                                Font = "RiceUI_M_24",
                            }
                        }
                    }
                }
            },

        }
    }
})