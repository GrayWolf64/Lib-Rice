local Base = (RiceUI.Notify or {}).Base


local function init()
    Base = RiceUI.SimpleCreate{
        type = "rl_panel",
        NoGTheme = true,
        Paint = function() end,
        w = 400,
        h = 800,
        x = 1500,
        y = 20,
        children = {
            {
                type = "scrollpanel",
                ID = "ScrollPanel",
                Dock = FILL
            }
        }
    }

    RiceUI.Notify.Base = Base
end

local function message(arg)
    if not IsValid(Base) then init() end

    RiceLib.table.Inherit(arg, {
        Title = "Message",
        Text = "Message",
        Icon = "icon16/textfield.png",
        --Sound = "garrysmod/content_downloaded.wav",
        BarColor = Color(0, 0, 0, 0),
        LifeTime = 3
    })

    if arg.Sound then surface.PlaySound(arg.Sound) end

    return RiceUI.SimpleCreate({type = "rl_panel",
        Dock = TOP,
        Margin = {0, 8, 0, 0},
        h = 0,

        UseNewTheme = true,
        ThemeNT = {
            Theme = "Modern",
            Style = "Acrylic",
            --Color = "black"
        },

        OnCreated = function(self)
            self:RiceUI_SizeTo{
                H = RiceUI.Scale.Size(128),
                EaseFunction = math.ease.OutBack,

                Callback = function()
                    self:RiceUI_SizeTo{
                        H = 0,
                        Delay = arg.LifeTime,
                        EaseFunction = math.ease.InBack,

                        Callback = function()
                            self:Remove()
                        end
                    }
                end
            }
        end,

        children = {
            {type = "rl_panel",
                Dock = TOP,
                h = 48,

                children = {
                    {type = "image",
                        Dock = LEFT,
                        Margin = {8, 8, 8, 8},
                        w = 32,

                        Image = arg.Icon
                    },

                    {type = "label",
                        Dock = FILL,

                        Text = arg.Title,
                        Color = color_black
                    }
                }
            },

            {type = "rl_panel",
                Dock = TOP,
                h = 2,

                ThemeNT = {
                    StyleSheet = {
                        Color = arg.BarColor
                    }
                }
            },

            {type = "label",
                x = 8,
                y = 54,

                Text = arg.Text,
                Font = "RiceUI_24",
                Color = color_black
            }
        }
    }, Base:GetElement("ScrollPanel"))

    --[[return RiceUI.SimpleCreate({
        type = "rl_panel",
        Dock = TOP,
        Margin = {0, 5, 0, 0},
        h = 0,
        Theme = {
            ThemeName = "glass",
            ThemeType = "Panel",
            Color = "black",
            TextColor = "black",
            Blur = 3,
            Shadow = true
        },
        children = {
            {
                type = "panel",
                Paint = function() end,
                Dock = TOP,
                h = 40,
                children = {
                    {
                        type = "image",
                        Image = arg.Icon,
                        w = 30,
                        Dock = LEFT,
                        Margin = {10, 10, 0, 0},
                        Color = Color(255, 255, 255)
                    },
                    {
                        type = "panel",
                        Text = arg.Title,
                        Font = "OPSans_35",
                        Dock = LEFT,
                        Margin = {10, 8, 0, 0},
                        Theme = {
                            ThemeName = "modern",
                            ThemeType = "ShadowText"
                        }
                    },
                }
            },
            {
                type = "panel",
                Text = arg.Text,
                Font = "OPSans_30",
                Dock = TOP,
                Margin = {10, 10, 0, 0},
                Theme = {
                    ThemeName = "modern",
                    ThemeType = "ShadowText"
                }
            },
            {
                type = "panel",
                Dock = BOTTOM,
                h = 2,
                BarColor = arg.BarColor,
                Paint = function(self, w, h)
                    surface.SetDrawColor(self.BarColor)
                    surface.DrawRect(0, 0, w, h)
                end
            }
        },
        Anim = {
            {
                type = "resize",
                w = -1,
                h = 90,
                time = 0.2,
                delay = 0,
                CallBack = function(_, pnl)
                    pnl:SizeTo(-1, 0, 0.2, 4.8, 0.3, function()
                        pnl:Remove()
                    end)
                end
            }
        }
    }, Base:GetElement("ScrollPanel"))]]
end

hook.Add("InitPostEntity", "RiceUI_InitNotify", init)

concommand.Add("riceui_notify_clear", function()
    Base:GetElement("ScrollPanel"):Clear()
end)

concommand.Add("riceui_notify_reload", function()
    if IsValid(Base) then
        Base:Remove()
    end

    init()
end)

concommand.Add("riceui_notify_message", function(ply, cmd, args, argStr)
    message{
        Text = argStr,
        Sound = "garrysmod/content_downloaded.wav"
    }
end)

concommand.Add("riceui_notify_warn", function(ply, cmd, args, argStr)
    message{
        Text = argStr,
        Title = "Warning",
        Icon = "vgui/notices/generic",
        Sound = "garrysmod/ui_hover.wav",
        BarColor = Color(255, 255, 0)
    }
end)

concommand.Add("riceui_notify_error", function(ply, cmd, args, argStr)
    message{
        Text = argStr,
        Title = "ERROR",
        Icon = "vgui/notices/error",
        Sound = "garrysmod/ui_hover.wav",
        BarColor = Color(255, 0, 0)
    }
end)

RiceUI.Notify = {
    Message = message
}