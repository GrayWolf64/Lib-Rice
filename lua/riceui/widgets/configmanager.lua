RiceUI.DefineWidget("RiceLib_ConfigManager_Number", function(data, parent)
    local entry = data.Entry

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 32,

        ThemeNT = {
            Class = "NoDraw"
        },

        ConfigEntry = entry,

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "rl_numberwang",
                Dock = RIGHT,
                w = 196,

                Min = entry.Min,
                Max = entry.Max,
                Dec = entry.Dec,
                Step = entry.Step,

                Value = entry:GetValue(),
                OnValueChanged = function(self, val)
                    entry:SetValue(val)
                end
            }
        }
    }, parent)
end)

RiceUI.DefineWidget("RiceLib_ConfigManager_String", function(data, parent)
    local entry = data.Entry

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 32,

        ThemeNT = {
            Class = "NoDraw"
        },

        ConfigEntry = entry,

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "entry",
                Dock = RIGHT,
                w = 196,

                Text = entry:GetValue(),
                OnValueChange = function(self, val)
                    entry:SetValue(val)
                end
            }
        }
    }, parent)
end)

RiceUI.DefineWidget("RiceLib_ConfigManager_Bool", function(data, parent)
    local entry = data.Entry

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 32,

        ThemeNT = {
            Class = "NoDraw"
        },

        ConfigEntry = entry,

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "rl_switch",
                Dock = RIGHT,
                w = 64,

                Value = entry:GetValue(),
                OnValueChanged = function(self, val)
                    entry:SetValue(val)
                end
            }
        }
    }, parent)
end)

RiceUI.DefineWidget("RiceLib_ConfigManager_Keybind", function(data, parent)
    local entry = data.Entry

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 40,

        ThemeNT = {
            Class = "NoDraw"
        },

        ConfigEntry = entry,

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "rl_keybinder",
                Dock = RIGHT,
                w = 64,

                KeybindID = entry.KeybindID,

                Value = RiceLib.Keybinds.GetKeybinds(entry.KeybindID)
            }
        }
    }, parent)
end)

RiceUI.DefineWidget("RiceLib_ConfigManager_FunctionEntry", function(data, parent)
    local entry = data.Entry

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 40,

        ThemeNT = {
            Class = "NoDraw"
        },

        children = {
            {type = "label",
                Dock = LEFT,

                Text = entry.DisplayName
            },

            {type = "rl_button",
                Dock = RIGHT,
                w = 128,

                Text = entry.ButtonText or "",

                ThemeNT = {
                    Style = "Accent"
                },

                DoClick = function()
                    entry.Function()
                end
            }
        }
    }, parent)
end)

local listCards = {}
RiceUI.DefineWidget("RiceLib_ConfigManager_List", function(data, parent)
    local entry = data.Entry
    local nameSpace, key = entry.NameSpace, entry.Key

    local card = RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {16, 16, 16, 0},
        h = 448,

        ThemeNT = {
            Class = "Panel",
        },

        Update = function(self)
            local values = {}
            local scrollpanel = self:GetElement("List")
            scrollpanel:Clear()

            for index, value in pairs(entry:GetValue()) do
                table.insert(values, {type = "rl_panel",
                    Dock = TOP,
                    Margin = {12, 0, 12, 0},
                    h = 40,

                    ThemeNT = {
                        Class = "NoDraw"
                    },

                    children = {
                        {type = "label",
                            Dock = LEFT,
                            NoResize = true,
                            w = 64,

                            Text = index
                        },

                        {type = "label",
                            Dock = FILL,

                            Text = value
                        },

                        {type = "rl_imagebutton",
                            Dock = RIGHT,
                            Margin = {0, 12, 12, 0},
                            w = 28,

                            Image = "rl_icons/xmark.png",

                            DoClick = function(self)
                                RiceUI.SimpleCreate({widget = "RiceUI_Confirm",
                                    Title = "删除记录",

                                    Text = Format("确定删除 序号 [ %s ] 的数据吗?", index),

                                    OnConfirm = function(_, popup)
                                        entry:RemoveValue(index)

                                        popup:RiceUI_Animation()
                                    end
                                }, RiceLib.Config.MenuPanel)
                            end
                        }
                    }
                })
            end

            RiceUI.Create(values, scrollpanel)
            RiceUI.ApplyTheme(scrollpanel)
        end,

        OnRemove = function()
            if IsValid(listCards[nameSpace .. key]) then
                listCards[nameSpace .. key] = nil
            end
        end,

        ChildrenIgnoreRoot = true,
        children = {
            {type = "rl_panel",
                Dock = TOP,

                h = 40,

                ThemeNT = {
                    Class = "NoDraw"
                },

                children = {
                    {type = "label",
                        Dock = FILL,
                        Margin = {12, 12, 0, 0},

                        Text = entry.DisplayName,
                    },
                }
            },

            {type = "rl_panel",
                Dock = TOP,
                Margin = {12, 12, 12, 0},
                h = 3,

                ThemeNT = {
                    Class = "Spacer",
                    Style = "Horizontal"
                }
            },

            {type = "rl_panel",
                Dock = TOP,
                Margin = {12, 12, 12, 0},
                h = 40,

                ThemeNT = {
                    Class = "NoDraw"
                },

                children = {
                    {type = "label",
                        Dock = LEFT,
                        NoResize = true,
                        w = 64,

                        Text = "序号"
                    },

                    {type = "label",
                        Dock = LEFT,
                        NoResize = true,
                        w = 256,

                        Text = entry.ValueName or "数据"
                    },

                    {type = "rl_imagebutton",
                        Dock = RIGHT,
                        Margin = {0, 6, 12, 6},
                        w = 28,

                        Image = "icon16/add.png",

                        DoClick = function(self)
                            local steamid64

                            local request = RiceUI.SimpleCreate({type = "rl_frame2",
                                w = 512,

                                Title = "添加记录",
                                ThemeNT = {
                                    Class = "Frame",
                                    Style = "Shadow"
                                },

                                children = {
                                    {type = "entry",
                                        Dock = TOP,
                                        Margin = {16, 0, 16, 0},

                                        Placeholder = entry.ValueName or "数据",

                                        OnValueChange = function(self, val)
                                            steamid64 = val
                                        end
                                    },

                                    {type = "rl_button",
                                        Dock = TOP,
                                        Margin = {16, 16, 16, 0},
                                        h = 40,

                                        ThemeNT = {
                                            Style = "Accent"
                                        },

                                        Text = "添加",

                                        DoClick = function(self)
                                            if not steamid64 then return end

                                            entry:AddValue(steamid64)

                                            self:GetParent():RiceUI_Animation()
                                        end
                                    }
                                }
                            }, RiceLib.Config.MenuPanel)

                            request:FitContents_Vertical(RICEUI_SIZE_16)
                            request:Center()

                            RiceUI.ThemeNT.ApplyTheme(request, RiceLib.Config.MenuPanel.ThemeNT)
                        end
                    }
                }
            },

            {type = "rl_panel",
                Dock = TOP,
                Margin = {12, 12, 12, 12},
                h = 3,

                ThemeNT = {
                    Class = "Spacer",
                    Style = "Horizontal"
                }
            },

            {type = "rl_scrollpanel",
                ID = "List",
                Dock = FILL,

                ScrollSpeed = 3
            }
        }
    }, parent)

    card:Update()

    listCards[nameSpace .. key] = card

    return card
end)

hook.Add("RiceLib_ConfigManager_ValueChanged", "RiceLib_ConfigManager", function(nameSpace, key)
    local card = listCards[nameSpace .. key]

    if IsValid(card) then
        card:Update()
    end
end)
