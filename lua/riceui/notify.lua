RiceUI = RiceUI or {}
RiceUI.Notify = RiceUI.Notify or {}

function RiceUI.Notify.Message(arg)
    RL.table.Inherit(arg,{
        Text = "Message",
        Color = Color(0,255,0,100),
        Sound = "garrysmod/content_downloaded.wav"
    })

    surface.PlaySound(arg.Sound)

    local pnl = RiceUI.SimpleCreate({type="rl_panel",Dock=TOP,Margin={0,5,0,0},h=40,
        Paint = function(self,w,h)
            draw.RoundedBox(5,0,0,w,h,arg.Color)
        end,

        children = {
            {type="label",Text=arg.Text,Font="OPSans_30",Dock=LEFT,Margin={10,0,0,0},Color=Color(255,255,255)}
        },

        Anim = {
            {type="resize",w=-1,h=0,time=0.5,delay=5,CallBack = function(_,pnl) pnl:Remove() end}
        }
    },RiceUI.Notify.Base.Elements.ScrollPanel)
end

function RiceUI.Notify.Panel(data)
    local pnl = RiceUI.SimpleCreate(data,RiceUI.Notify.Base.Elements.ScrollPanel)
end

function RiceUI.Notify.Init()
    RiceUI.Notify.Base = RiceUI.SimpleCreate({type="rl_panel",
        NoGTheme = true,
        Paint = function()end,
        w = 400,
        h = 800,

        x = 1500,
        y = 20,

        children = {
            {type="scrollpanel",ID="ScrollPanel",Dock=FILL}
        }
    })
end

hook.Add("InitPostEntity","RiceUI_InitNotify",RiceUI.Notify.Init)

concommand.Add("riceui_notify_clear",function()
    RiceUI.Notify.Base.Elements.ScrollPanel:Clear()
end)

concommand.Add("riceui_notify_reload",function()
    if IsValid(RiceUI.Notify.Base) then RiceUI.Notify.Base:Remove() end
    RiceUI.Notify.Init()
end)

concommand.Add("riceui_notify_message",function(ply,cmd,args,argStr)
    RiceUI.Notify.Message({Text=argStr})
end)

concommand.Add("riceui_notify_warn",function(ply,cmd,args,argStr)
    RiceUI.Notify.Message({Text = argStr, Color = Color(255,255,0,150), Sound= "garrysmod/ui_hover.wav"})
end)

concommand.Add("riceui_notify_error",function(ply,cmd,args,argStr)
    RiceUI.Notify.Message({Text = argStr, Color = Color(255,0,0,150), Sound = "garrysmod/ui_hover.wav"})
end)