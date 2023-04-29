local tbl = {}
tbl.Color = {
    white = Color(255,255,255,50),
    black = Color(0,0,0,50),
}

tbl.BackgroundColor = {
    white = Color(255,255,255,25),
    black = Color(0,0,0,150),
}

tbl.TextColor = {
    white = Color(255,255,255,255),
    black = Color(255,255,255,255),
}

tbl.VBarColor = {
    white = Color(255,255,255,50),
    black = Color(0,0,0,50),
}

tbl.BarColor = {
    white = Color(255,255,255),
    black = Color(50,50,50),
}

tbl.FocusColor = {
    white = Color(64, 158, 255),
    black = Color(64, 158, 255),
}

tbl.DisableColor = {
    white = Color(50, 50, 50,100),
    black = Color(255, 255, 255,50),
}

tbl.HoverColor = {
    closeButton = Color(255,0,0)
}

function tbl.Panel(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,0,w,h)
    
    if pnl.Theme.Blur then RL.VGUI.blurPanel(pnl,pnl.Theme.Blur) end
end

function tbl.RL_Frame(pnl,w,h)
    if pnl.Theme.Blur then RL.VGUI.blurPanel(pnl,pnl.Theme.Blur) end

    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Bar"))
    surface.DrawRect(0,0,w,pnl.Title:GetTall()+10)

    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Background"))
    surface.DrawRect(0,pnl.Title:GetTall()+10,w,h)
end

function tbl.Raw(pnl,w,h)
    RL.VGUI.blurPanel(pnl,pnl.Theme.Blur)
end

function tbl.Button(pnl,w,h)
    if pnl.Theme.Blur then RL.VGUI.blurPanel(pnl,pnl.Theme.Blur) end

    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,0,w,h)

    if pnl:IsHovered() then
        surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
        surface.DrawRect(0,0,w,h)
    end

    local color = RiceUI.GetColorBase(tbl,pnl,"Text")

    if pnl:IsDown() then color = RiceUI.GetColor(tbl,pnl,"Focus") end

    draw.SimpleText(pnl.Text,pnl:GetFont(),w/2,h/2,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function tbl.TransButton(pnl,w,h)
    local color = RiceUI.GetColor(tbl,pnl,"Hover","closeButton")

    if !pnl.HoverAlpha then pnl.HoverAlpha = 0 end

    if pnl:IsHovered() then
        pnl.HoverAlpha = math.min(pnl.HoverAlpha+(pnl.Theme.Speed or 20)*(RealFrameTime()*100),255)
    else
        pnl.HoverAlpha = math.max(pnl.HoverAlpha-(pnl.Theme.Speed or 20)*(RealFrameTime()*100),0)
    end

    surface.SetDrawColor(ColorAlpha(color,pnl.HoverAlpha))
    surface.DrawRect(0,0,w,h)

    draw.SimpleText(pnl.Text,pnl:GetFont(),w/2,h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function tbl.TransButton_F(pnl,w,h)
    local color = RiceUI.GetColor(tbl,pnl,"Hover","closeButton")

    if !pnl.HoverAlpha then pnl.HoverAlpha = 0 end

    if pnl:IsHovered() then
        pnl.HoverAlpha = 255
    else
        pnl.HoverAlpha = 0
    end

    surface.SetDrawColor(ColorAlpha(color,pnl.HoverAlpha))
    surface.DrawRect(0,0,w,h)

    draw.SimpleText(pnl.Text,pnl:GetFont(),w/2,h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function tbl.Entry(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,0,w,h)

    local color = RiceUI.GetColor(tbl,pnl)
    if pnl:HasFocus() then
        color = RiceUI.GetColor(tbl,pnl,"Focus")
    end

    surface.SetDrawColor(color)
    surface.DrawOutlinedRect(0,0,w,h,1)

    if pnl:GetValue() == "" then
        draw.SimpleText(pnl:GetPlaceholderText(),pnl:GetFont(),10,h/2,pnl:GetPlaceholderColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(pnl:GetText(),pnl:GetFont(),10,h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

    if pnl:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl,pnl,"Text"),255*math.sin(SysTime()*8%360)))
        surface.DrawRect(10+RL.VGUI.TextWide(pnl:GetFont(),pnl:GetText()),4,1,h-8)
    end
end

function tbl.Switch(pnl,w,h)
    surface.SetDrawColor(pnl:GetColor())
    surface.DrawRect(0,0,w,h)

    local fraction = (pnl.togglePos/(pnl:GetWide()/2))

    surface.SetDrawColor(Color(250,250,250))
    surface.DrawRect(fraction*w + 3 - ((h/1.5 + 6) *fraction),3,h/1.5,h-6)
end

function tbl.Slider(pnl,w,h)
    local pos = w*pnl:GetSlideX()

    surface.SetDrawColor(RiceUI.GetColorBase(tbl,pnl,"Focus"))
    surface.DrawRect(0,h/3,pos,h/3)

    surface.SetDrawColor(RiceUI.GetColorBase(tbl,pnl,"Disable"))
    surface.DrawRect(pos,h/3,w-pos,h/3)

    DisableClipping(true)
    surface.SetDrawColor(250,250,250)
    surface.DrawRect(pos-h/4,0,h/2,h)

    if pnl:GetDragging() then
        draw.SimpleText(tostring(pnl:GetValue()),"OPPOSans_"..tostring(h),pos,-h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    DisableClipping(false)
end

function tbl.ScrollPanel_VBar(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"VBar"))
    surface.DrawRect(0,0,w,h)
end

function tbl.ScrollPanel_VBar_Grip(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Bar"))
    surface.DrawRect(0,0,w,h)
end

function tbl.OnLoaded()
    RiceUI.Examples.Glass = {
        {type="rl_frame",Text="Example",Center=true,Root=true,Alpha=0,w=1200,h=800,ThemeName="glass",CloseButtonColor=Color(50,50,50),
            Paint = RiceUI.GetTheme("glass").RL_Frame,
            Theme = {Color="white",Blur=5},
            GTheme = {name = "glass",Theme = {Blur=2,Color="white"}},

            Anim = {{type = "alpha",time = 0.075,alpha = 255}},
            children = {
                {type="button",x=10,y=40,w=100,h=50},

                {type="entry",x=10,y=100,w=300,h=30},

                {type="switch",x=120,y=38,w=50,h=25,DisableColor = Color(50,50,50,50)},
                {type="switch",x=120,y=67,w=50,h=25,DisableColor = Color(50,50,50,50),Value=true},

                {type="image",x=320,y=40,w=90,h=90,Image="gui/dupe_bg.png"},
                {type="web_image",x=420,y=40,w=90,h=90,Image="https://i.328888.xyz/2023/01/29/jM97x.jpeg"},

                {type="panel",x=10,y=140,h=645},
                {type="scrollpanel",ID="ScrollPanel",x=15,y=145,h=635,w=490,ThemeName="glass",Theme = {Color = "white"},OnCreated = function(pnl)
                    for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                        Paint = RiceUI.GetTheme("glass").Panel,
                        Theme = {Color = "white"},
                    },pnl)) end
                end},

                {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",ThemeName="glass",CloseButtonColor=Color(50,50,50),
                    Paint = RiceUI.GetTheme("glass").RL_Frame,
                    Theme = {Color="white",Blur=2},
                    GTheme = {name = "glass",Theme = {color = "white"}},
                    children={
                        {type="slider",y=60}
                    }
                }
            },
        }
    }

    RiceUI.Examples.GlassDark = {
        {type="rl_frame",Text="Example",Center=true,Root=true,Alpha=0,w=1200,h=800,ThemeName="glass",TitleColor=Color(250,250,250),CloseButtonColor=Color(250,250,250),
            Paint = RiceUI.GetTheme("glass").RL_Frame,
            Theme = {Color="black",Blur=5},
            GTheme = {name = "glass",Theme = {Blur=2,Color="black"}},

            Anim = {{type = "alpha",time = 0.075,alpha = 255}},
            children = {
                {type="button",x=10,y=40,w=100,h=50},

                {type="entry",x=10,y=100,w=300,h=30},

                {type="switch",x=120,y=38,w=50,h=25,DisableColor = Color(50,50,50,50)},
                {type="switch",x=120,y=67,w=50,h=25,DisableColor = Color(50,50,50,50),Value=true},

                {type="image",x=320,y=40,w=90,h=90,Image="gui/dupe_bg.png"},
                {type="web_image",x=420,y=40,w=90,h=90,Image="https://i.328888.xyz/2023/01/29/jM97x.jpeg"},

                {type="panel",x=10,y=140,h=645},
                {type="scrollpanel",ID="ScrollPanel",x=15,y=145,h=635,w=490,ThemeName="glass",Theme = {Color = "black"},OnCreated = function(pnl)
                    for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                        Paint = RiceUI.GetTheme("glass").Panel,
                        Theme = {Color = "black"},
                    },pnl)) end
                end},

                {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",ThemeName="glass",TitleColor=Color(250,250,250),CloseButtonColor=Color(250,250,250),
                    Paint = RiceUI.GetTheme("glass").RL_Frame,
                    Theme = {Color="black",Blur=2},
                    GTheme = {name = "glass",Theme = {color = "black"}},
                    children={
                        {type="slider",y=60}
                    }
                }
            },
        }
    }
end

return tbl