function RiceUI.Prefab.Notify(args)
    RL.table.Inherit(args,{
        Title = "通知",
        Text = "这是一个通知",

        Theme = {
            ThemeName = "modern",
            ThemeType = "Panel",

            Color = "white",
            TextColor = "white"
        },
    })

    local wide = math.max(500,RL.VGUI.TextWide("RiceUI_36", args.Text))

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


            {type = "rl_button",
                    Text = "确定",
                    Font = "RiceUI_30",

                    Dock = BOTTOM,
                    Margin = {20,0,20,20},

                    h = 48,

                    Theme = {ThemeType = "Button_Accent"},

                    DoClick = function(self)
                        self:RiceUI_GetRoot():Remove()
                    end
                },
            }
    })
end

local lol = Material("rl_resource/lol.jpg")

function RiceUI.Prefab.Notify_LOL(args)
    table.Inherit(args,{
        Text = "喜报",
        DoClick = function(self) self:Remove() end,
        Scale = 1,
        FontSize = 30,
    })

    local frame = RiceUI.SimpleCreate({type = "button",w=467*args.Scale,h=350*args.Scale,Text="",Font="SourceHan_"..tostring(args.FontSize),Center = true,Root = true,
        Paint = function(self,w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(lol)
            surface.DrawTexturedRect(0,0,w,h)

            draw.DrawText(args.Text,"SourceHan_"..tostring(args.FontSize),w/2,h/2-(args.FontSize/2),Color(255,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end,

        DoClick = args.DoClick
    })
end

function RiceUI.Prefab.Notify_LOL_FullScreen(args)
    table.Inherit(args,{
        Text = "喜报",
        DoClick = function(self) self:Remove() end,
        FontSize = 30,
    })

    local frame = RiceUI.SimpleCreate({type = "button",w=ScrW(),h=ScrH(),Center = true,Root = true,
        Paint = function(self,w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(lol)
            surface.DrawTexturedRect(0,0,w,h)

            draw.DrawText(args.Text,"SourceHan_"..tostring(args.FontSize),w/2,h/2-(args.FontSize/2),Color(255,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end,

        DoClick = args.DoClick
    })
end