local inputs = {
    Label = function(panel, data)
        RiceUI.SimpleCreate(RiceLib.table.Inherit(data, {type = "label",
            Dock = TOP,
            Margin = {16, 0, 16, 16},
            h = 32,
        }), panel)
    end,

    Entry = function(panel, data)
        RiceUI.SimpleCreate(RiceLib.table.Inherit(data, {type = "entry",
            Dock = TOP,
            Margin = {16, 0, 16, 16},
            h = 32,
        }), panel)
    end,

    NumberWang = function(panel, data)
        RiceUI.SimpleCreate(RiceLib.table.Inherit(data ,{type = "rl_numberwang",
            Dock = TOP,
            Margin = {16, 0, 16, 16},
            h = 32,
        }), panel)
    end,

    Combo = function(panel, data)
        RiceUI.SimpleCreate(RiceLib.table.Inherit(data ,{type = "rl_combo",
            Dock = TOP,
            Margin = {16, 0, 16, 16},
            h = 32,
        }), panel)
    end,

    Spacer = function(panel, data)
        RiceUI.SimpleCreate({type = "rl_panel",
            Dock = TOP,
            Margin = {16, 0, 16, 16},
            h = 32,

            Theme = {ThemeType = "NoDraw"}
        }, panel)
    end,
}

function RiceUI.Prefab.RequestInputs(args)
    RiceLib.table.Inherit(args,{
        Title = "请求输入",

        Inputs = {
            {"Label", {
                Text = "文本"
            }},

            {"Entry", {
                ID = "String",
                Placeholder = "文本输入"
            }},

            {"NumberWang", {
                ID = "Number",
                Text = "数字输入"
            }},

            {"Combo", {
                ID = "Combo",
                Text = "选项"
            }}
        },

        OnConfirm = function(self) self:Remove() end,
        OnCancel = function(self) self:Remove() end,

        Theme = {
            ThemeName = "modern",
            ThemeType = "Panel",

            Color = "white",
            TextColor = "white"
        },
    })

    local frame = RiceUI.SimpleCreate({type = "rl_panel",
        w = 512,
        h = 180 + #args.Inputs * 40,

        Center = true,
        OnTop = true,

        UseNewTheme = true,
        Theme = args.Theme,

        children = {
            {type = "label",
                Text = args.Title,
                Font = "RiceUI_M_36",

                Dock = TOP,
                Margin = {16, 16, 16, 16}
            },

            {type = "rl_panel",
                Theme = {
                    ThemeType = "PanelNT",
                    Corner = {false,false,true,true},

                    ColorNT = {"Background", "Soild", "Primary"},
                    BorderColor = {"Stroke", "Solid"},
                    Border = true,
                },

                h = 80,

                Dock = BOTTOM,
                Margin = {0, 0, 0, 0},

                children = {
                    {type = "rl_button",
                        Text = "确定",
                        Font = "RiceUI_30",

                        Dock = LEFT,
                        Margin = {16, 16, 0, 16},

                        w = RiceLib.hudScaleX(232),

                        Theme = {ThemeType = "Button_Accent"},

                        DoClick = function(self)
                            local frame = self:RiceUI_GetRoot()
                            local values = {}

                            for id, panel in pairs(frame.riceui_elements) do
                                values[id] = panel:GetValue()
                            end

                            args.OnConfirm(frame, values)
                        end
                    },

                    {type = "rl_button",
                        Text = "取消",
                        Font = "RiceUI_30",

                        Dock = RIGHT,
                        Margin = {0, 16, 16, 16},

                        w = RiceLib.hudScaleX(232),

                        Theme = {ThemeType = "Button_NT"},

                        DoClick = function(self)
                            args.OnCancel(self:RiceUI_GetRoot())
                        end
                    },
                }
            }
        }
    })

    for _, data in ipairs(args.Inputs) do
        local func = inputs[data[1]]
        if func == nil then continue end

        func(frame, data[2])
    end

    RiceUI.ApplyTheme(frame)
end

function RiceUI.Prefab.RequestInput(args)
    RiceLib.table.Inherit(args,{
        Title = "请求输入",
        Placeholder = "Request Input",

        OnConfirm = function(self) self:Remove() end,
        OnCancel = function(self) self:Remove() end,

        Theme = {
            ThemeName = "modern",
            ThemeType = "Panel",

            Color = "white",
            TextColor = "white"
        },
    })

    local wide = math.max(500,RiceLib.VGUI.TextWide("RiceUI_36", args.Title))

    return RiceUI.SimpleCreate({type = "epanel",
        w = wide,
        h = 200,

        Center = true,
        OnTop = true,

        UseNewTheme = true,
        Theme = args.Theme,

        children = {
            {type = "label",
                Text = args.Title,
                Font = "RiceUI_M_36",

                Dock = TOP,
                Margin = {16, 16, 0, 0}
            },

            {type = "entry",
                ID = "Entry",
                Placeholder = args.Placeholder,

                Dock = TOP,
                Margin = {16, 16, 16,0}
            },

            {type = "rl_panel",
                Theme = {
                    ThemeType = "PanelNT",
                    Corner = {false,false,true,true},

                    ColorNT = {"Background", "Soild", "Primary"},
                    BorderColor = {"Stroke", "Solid"},
                    Border = true,
                },

                h = 80,

                Dock = BOTTOM,
                Margin = {0, 0, 0, 0},

                children = {
                    {type = "rl_button",
                        Text = "确定",
                        Font = "RiceUI_30",

                        Dock = LEFT,
                        Margin = {16, 16, 0, 16},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_Accent"},

                        DoClick = function(self)
                            args.OnConfirm(self:RiceUI_GetRootPanel(), self:RiceUI_GetRootPanel():GetElement("Entry"):GetValue())
                        end
                    },

                    {type = "rl_button",
                        Text = "取消",
                        Font = "RiceUI_30",

                        Dock = RIGHT,
                        Margin = {0, 16, 16, 16},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_NT"},

                        DoClick = function(self)
                            args.OnCancel(self:RiceUI_GetRootPanel())
                        end
                    },
                }
            }
        }
    })
end

function RiceUI.Prefab.RequestKey(args)
    RiceLib.table.Inherit(args,{
        Title = "请求按键输入",

        OnConfirm = function(self) self:Remove() end,
        OnCancel = function(self) self:Remove() end,

        Theme = {
            ThemeName = "modern",
            ThemeType = "Panel",

            Color = "white",
            TextColor = "white"
        },
    })

    local wide = math.max(500,RiceLib.VGUI.TextWide("RiceUI_36", args.Title))

    RiceUI.SimpleCreate({type = "epanel",
        w = wide,
        h = 216,

        Center = true,
        OnTop = true,

        UseNewTheme = true,
        Theme = args.Theme,

        KeyCode = 0,

        OnKeyCodePressed = function(self, code)
            self.riceui_elements.Key.Text = input.GetKeyName(code)
            self.KeyCode = code
        end,

        children = {
            {type = "label",
                Text = args.Title,
                Font = "RiceUI_M_36",

                Dock = TOP,
                Margin = {16, 16, 0, 0}
            },

            {type = "rl_button",
                ID = "Key",

                Dock = TOP,
                Margin = {16, 16, 16, 0}
            },

            {type = "rl_panel",
                Theme = {
                    ThemeType = "PanelNT",
                    Corner = {false,false,true,true},

                    ColorNT = {"Background", "Soild", "Primary"},
                    BorderColor = {"Stroke", "Solid"},
                    Border = true,
                },

                h = 80,

                Dock = BOTTOM,
                Margin = {0, 0, 0, 0},

                children = {
                    {type = "rl_button",
                        Text = "确定",
                        Font = "RiceUI_30",

                        Dock = LEFT,
                        Margin = {16, 16, 0, 16},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_Accent"},

                        DoClick = function(self)
                            args.OnConfirm(self:RiceUI_GetRoot(), self:RiceUI_GetRoot().KeyCode)
                        end
                    },

                    {type = "rl_button",
                        Text = "取消",
                        Font = "RiceUI_30",

                        Dock = RIGHT,
                        Margin = {0, 16, 16, 16},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_NT"},

                        DoClick = function(self)
                            args.OnCancel(self:RiceUI_GetRoot())
                        end
                    },
                }
            }
        }
    })
end

function RiceUI.Prefab.Confirm(args)
    RiceLib.table.Inherit(args,{
        Title = "确认",
        Text = "确定进行此操作吗？",

        OnConfirm = function(self) self:Remove() end,
        OnCancel = function(self) self:Remove() end,

        Theme = {
            ThemeName = "modern",
            ThemeType = "Panel",

            Color = "white",
            TextColor = "white"
        },
    })

    local wide = math.max(500,RiceLib.VGUI.TextWide("RiceUI_36", args.Text))

    RiceUI.SimpleCreate({type = "rl_panel",
        w = wide,
        h = 230,

        Center = true,
        OnTop = true,

        UseNewTheme = true,
        Theme = args.Theme,

        children = {
            {type = "label",
                Text = args.Title,
                Font = "RiceUI_M_36",

                Dock = TOP,
                Margin = {20,20,0,0}
            },

            {type = "label",
                Text = args.Text,
                Font = "RiceUI_28",

                Dock = TOP,
                Margin = {20,10,0,0}
            },

            {type = "rl_panel",
                Theme = {
                    ThemeType = "PanelNT",
                    Corner = {false,false,true,true},

                    ColorNT = {"Background", "Soild", "Primary"},
                    BorderColor = {"Stroke", "Solid"},
                    Border = true,
                },

                h = 80,

                Dock = BOTTOM,
                Margin = {0,0,0,0},

                children = {
                    {type = "rl_button",
                        Text = "确定",
                        Font = "RiceUI_30",

                        Dock = LEFT,
                        Margin = {20,20,0,20},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_Accent"},

                        DoClick = function(self)
                            args.OnConfirm(self:RiceUI_GetRoot())
                        end
                    },

                    {type = "rl_button",
                        Text = "取消",
                        Font = "RiceUI_30",

                        Dock = RIGHT,
                        Margin = {0,20,20,20},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_NT"},

                        DoClick = function(self)
                            args.OnCancel(self:RiceUI_GetRoot())
                        end
                    },
                }
            }
        }
    })
end

RiceUI.DefineWidget("RiceUI_Confirm", function(data, parent)
    RiceLib.table.Inherit(data, {
        Title = "确认",
        Text = "确定进行此操作吗？",

        OnConfirm = function(self) self:Remove() end,
        OnCancel = function(self) self:Remove() end,

        ThemeNT = {
            Theme = "Modern",
            Class = "Frame",
            Style = "Shadow"
        },
    })

    local wide = math.max(500,RiceLib.VGUI.TextWide("RiceUI_36", data.Text))

    return RiceUI.SimpleCreate({type = "rl_panel",
        w = wide,
        h = 230,

        Center = true,
        OnTop = true,

        UseNewTheme = true,
        ThemeNT = data.ThemeNT,

        ChildrenIgnoreRoot = true,
        children = {
            {type = "label",
                Text = data.Title,
                Font = "RiceUI_M_36",

                Dock = TOP,
                Margin = {20,20,0,0}
            },

            {type = "label",
                Text = data.Text,
                Font = "RiceUI_28",

                Dock = TOP,
                Margin = {20,10,0,0}
            },

            {type = "rl_panel",
                ThemeNT = {
                    StyleSheet = {
                        Corner = {false,false,true,true},
                        Color = Color(0, 0, 0, 25)
                    }
                },

                h = 80,

                Dock = BOTTOM,
                Margin = {0,0,0,0},

                children = {
                    {type = "rl_button",
                        Text = "确定",
                        Font = "RiceUI_30",

                        Dock = LEFT,
                        Margin = {20,20,0,20},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_Accent"},

                        DoClick = function(self)
                            data.OnConfirm(self:RiceUI_GetRootPanel())
                        end
                    },

                    {type = "rl_button",
                        Text = "取消",
                        Font = "RiceUI_30",

                        Dock = RIGHT,
                        Margin = {0,20,20,20},

                        w = wide / 2 - RiceLib.hudScaleX(25),

                        Theme = {ThemeType = "Button_NT"},

                        DoClick = function(self)
                            data.OnCancel(self:RiceUI_GetRootPanel())
                        end
                    },
                }
            }
        }
    }, parent)
end)