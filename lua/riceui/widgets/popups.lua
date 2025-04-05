RiceUI.DefineWidget("RiceUI_RequestInput", function(data, parent, root)
    local data = RiceLib.Table.Inherit(data, {
        Title = "请求输入",
        Text = "请输入文本",

        Theme = "Modern",
        Style = "Acrylic",
        Color = "black",

        w = 448,

        OnConfirm = function(self, val)
            return true
        end,

        OnCancel = function(self, val)
            return true
        end,
    })

    local frame = RiceUI.SimpleCreate({type = "rl_frame2",
        w = data.w,
        Title = data.Title,

        ThemeNT = {
            Theme = data.Theme,
            Class = "Frame",
            Style = data.Style,
            Color = data.Color
        },

        children = {
            {type = "label",
                ID = "Text",

                Dock = TOP,
                Margin = {16, 8, 16, 0},

                Text = data.Text,
                Font = "RiceUI_28"
            },

            {type = "entry",
                ID = "Input",
                Dock = TOP,

                Margin = {16, 16, 16, 0},
            },

            {type = "rl_panel",
                Dock = TOP,
                Margin = {0, 16, 0, 0},
                h = 72,

                ThemeNT = {
                    Style = "Layer",
                    StyleSheet = {
                        Corner = {false, false, false, false}
                    }
                },

                children = {
                    {type = "rl_button",
                        ID = "Confirm",

                        Dock = LEFT,
                        Margin = {16, 16, 0, 16},

                        ThemeNT = {
                            Style = "Accent",
                        },

                        Text = "确认",

                        DoClick = function(self)
                            local root = self:RiceUI_GetRootPanel()
                            local input = root:GetElementValue("Input")

                            if not data.OnConfirm(self, root, input) then return end

                            root:RiceUI_Animation()
                        end
                    },

                    {type = "rl_button",
                        ID = "Cancel",

                        Dock = RIGHT,
                        Margin = {0, 16, 16, 16},

                        Text = "取消",

                        DoClick = function(self)
                            local root = self:RiceUI_GetRootPanel()
                            local input = root:GetElementValue("Input")

                            if not data.OnCancel(self, root, input) then return end

                            root:RiceUI_Animation()
                        end
                    }
                }
            }
        }
    }, parent, root)

    local wide = math.max(data.w, RiceLib.VGUI.TextWide(RiceUI.Font.Get("RiceUI_28"), data.Text) + RICEUI_SIZE_32)
    frame:SetWide(wide)

    frame:GetElement("Confirm"):SetWide(wide / 2 - RICEUI_SIZE_32)
    frame:GetElement("Cancel"):SetWide(wide / 2 - RICEUI_SIZE_32)

    frame:FitContents_Vertical()
    frame:Center()
end)

RiceUI.DefineWidget("RiceUI_Confirm", function(data, parent, root)
    local data = RiceLib.Table.Inherit(data, {
        Title = "确认",
        Text = "请确认操作",

        Theme = "Modern",
        Style = "Acrylic",
        Color = "black",

        w = 448,

        OnConfirm = function(self, val)
            return true
        end,

        OnCancel = function(self, val)
            return true
        end,
    })

    local frame = RiceUI.SimpleCreate({type = "rl_frame2",
        w = data.w,
        Title = data.Title,

        ThemeNT = {
            Theme = data.Theme,
            Class = "Frame",
            Style = data.Style,
            Color = data.Color
        },

        children = {
            {type = "label",
                ID = "Text",

                Dock = TOP,
                Margin = {16, 8, 16, 0},

                Text = data.Text,
                Font = "RiceUI_28"
            },

            {type = "rl_panel",
                Dock = TOP,
                Margin = {0, 16, 0, 0},
                h = 72,

                ThemeNT = {
                    Style = "Layer",
                    StyleSheet = {
                        Corner = {false, false, false, false}
                    }
                },

                children = {
                    {type = "rl_button",
                        ID = "Confirm",

                        Dock = LEFT,
                        Margin = {16, 16, 0, 16},

                        ThemeNT = {
                            Style = "Accent",
                        },

                        Text = "确认",

                        DoClick = function(self)
                            local root = self:RiceUI_GetRootPanel()
                            if not data.OnConfirm(self, root) then return end

                            root:RiceUI_Animation()
                        end
                    },

                    {type = "rl_button",
                        ID = "Cancel",

                        Dock = RIGHT,
                        Margin = {0, 16, 16, 16},

                        Text = "取消",

                        DoClick = function(self)
                            local root = self:RiceUI_GetRootPanel()
                            if not data.OnCancel(self, root) then return end

                            root:RiceUI_Animation()
                        end
                    }
                }
            }
        }
    }, parent, root)

    local wide = math.max(data.w, RiceLib.VGUI.TextWide(RiceUI.Font.Get("RiceUI_28"), data.Text) + RICEUI_SIZE_32)
    frame:SetWide(wide)

    frame:GetElement("Confirm"):SetWide(wide / 2 - RICEUI_SIZE_32)
    frame:GetElement("Cancel"):SetWide(wide / 2 - RICEUI_SIZE_32)

    frame:FitContents_Vertical()
    frame:Center()
end)