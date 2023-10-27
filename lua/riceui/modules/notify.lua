RiceUI = RiceUI or {}
RiceUI.Notify = RiceUI.Notify or {}

function RiceUI.Notify.Message(arg)
    RL.table.Inherit(arg, {
        Title = "Message",
        Text = "Message",
        Icon = "icon16/textfield.png",
        Sound = "garrysmod/content_downloaded.wav",
        BarColor = Color(0, 0, 0, 0)
    })

    surface.PlaySound(arg.Sound)

    return RiceUI.SimpleCreate({
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
    }, RiceUI.Notify.Base.Elements.ScrollPanel)
end

function RiceUI.Notify.Panel(data)
    return RiceUI.SimpleCreate(data, RiceUI.Notify.Base.Elements.ScrollPanel)
end

function RiceUI.Notify.Init()
    RiceUI.Notify.Base = RiceUI.SimpleCreate({
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
    })
end

hook.Add("InitPostEntity", "RiceUI_InitNotify", RiceUI.Notify.Init)

concommand.Add("riceui_notify_clear", function()
    RiceUI.Notify.Base.Elements.ScrollPanel:Clear()
end)

concommand.Add("riceui_notify_reload", function()
    if IsValid(RiceUI.Notify.Base) then
        RiceUI.Notify.Base:Remove()
    end

    RiceUI.Notify.Init()
end)

concommand.Add("riceui_notify_message", function(ply, cmd, args, argStr)
    RiceUI.Notify.Message({
        Text = argStr
    })
end)

concommand.Add("riceui_notify_warn", function(ply, cmd, args, argStr)
    RiceUI.Notify.Message({
        Text = argStr,
        Title = "Warning",
        Icon = "vgui/notices/generic",
        Sound = "garrysmod/ui_hover.wav",
        BarColor = Color(255, 255, 0)
    })
end)

concommand.Add("riceui_notify_error", function(ply, cmd, args, argStr)
    RiceUI.Notify.Message({
        Text = argStr,
        Title = "ERROR",
        Icon = "vgui/notices/error",
        Sound = "garrysmod/ui_hover.wav",
        BarColor = Color(255, 0, 0)
    })
end)