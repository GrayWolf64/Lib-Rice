local tbl = {}
tbl.Color = {
    white = Color(250,250,250),
    white1 = Color(250,250,250),
    white2 = Color(240,240,240),
    white3 = Color(230,230,230),
    black = HSLToColor(0,0,0.2),
    black1 = HSLToColor(0,0,0.2),
    black2 = HSLToColor(0,0,0.18),
    black3 = HSLToColor(0,0,0.16),
}
tbl.TextColor = {
    white = Color(50,50,50),
    black = Color(250,250,250),
}
tbl.OutlineColor = {
    white = HSLToColor(0,0,0.9),
    white1 = HSLToColor(0,0,0.9),
    white1 = HSLToColor(0,0,0.85),
    white1 = HSLToColor(0,0,0.8),
    black = HSLToColor(0,0,0.3),
    black1 = HSLToColor(0,0,0.3),
    black2 = HSLToColor(0,0,0.3),
    black3 = HSLToColor(0,0,0.3),
}

tbl.BarColor = {
    white1 = Color(230,230,230),
    white2 = Color(220,220,220),
    white3 = Color(210,210,210),
    black = HSLToColor(0,0,0.15),
    black1 = HSLToColor(0,0,0.15),
    black2 = HSLToColor(0,0,0.15),
    black3 = HSLToColor(0,0,0.15),
}

tbl.HoverColor = {
    closeButton = Color(255,0,0),
    white = HSLToColor(0,0,0.85),
    white1 = HSLToColor(0,0,0.85),
    white1 = HSLToColor(0,0,0.8),
    white1 = HSLToColor(0,0,0.75),
    black = HSLToColor(0,0,0.35),
    black1 = HSLToColor(0,0,0.35),
    black2 = HSLToColor(0,0,0.40),
    black3 = HSLToColor(0,0,0.45),
}

tbl.FocusColor = {
    white1 = Color(64, 158, 255),
    white2 = Color(64, 158, 255),
    white3 = Color(64, 158, 255),
    black1 = Color(64, 158, 255),
    black2 = Color(64, 158, 255),
    black3 = Color(64, 158, 255),
}

tbl.DisableColor = {
    white = Color(200,200,200),
    white1 = Color(200,200,200),
    white2 = Color(200,200,200),
    white3 = Color(200,200,200),
    black = Color(70,70,70),
    black1 = Color(70,70,70),
    black2 = Color(70,70,70),
    black3 = Color(70,70,70),
}

function tbl.Panel(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,0,w,h)

    if pnl:GetParent():GetClassName() != "CGModBase" then
        surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Outline"))
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
end

function tbl.RL_Frame(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Bar"))
    surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,pnl.Title:GetTall()+10,w,h)

    if pnl:GetParent():GetClassName() != "CGModBase" then
        DisableClipping(true)

        surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Outline"))
        surface.DrawOutlinedRect(-1,-1,w+2,h+2,1)

        DisableClipping(false)
    end
end

function tbl.Button(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,0,w,h)

    local color = RiceUI.GetColor(tbl,pnl,"Outline")
    if pnl:IsHovered() then
        color = RiceUI.GetColor(tbl,pnl,"Hover")
    end
    if pnl:IsDown() then color = RiceUI.GetColor(tbl,pnl,"Focus") end

    surface.SetDrawColor(color)
    surface.DrawOutlinedRect(0,0,w,h,1)

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

    local color = RiceUI.GetColor(tbl,pnl,"Outline")
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
    RL.Draw.Circle(h/2,h/2,h/2,32,pnl:GetColor())
    RL.Draw.Circle(w-h/2,h/2,h/2,32,pnl:GetColor())

    surface.SetDrawColor(pnl:GetColor())
    surface.DrawRect(h/2/2+4,0,w-h/2-8,h)

    RL.Draw.Circle(h/2+pnl.togglePos,h/2,h/2-2,32,Color(250,250,250))
end

function tbl.Slider(pnl,w,h)
    local pos = w*pnl:GetSlideX()

    draw.RoundedBox(32,0,h/3,pos,h/3,RiceUI.GetColor(tbl,pnl,"Focus"))
    draw.RoundedBox(32,pos,h/3,w-pos,h/3,RiceUI.GetColor(tbl,pnl,"Disable"))

    DisableClipping(true)
    RL.Draw.Circle(pos,h/2,h/2,32,RiceUI.GetColor(tbl,pnl,"Focus"))
    RL.Draw.Circle(pos,h/2,h/2-2,32,Color(250,250,250))

    if pnl:GetDragging() then
        draw.SimpleText(tostring(pnl:GetValue()),"OPPOSans_"..tostring(h),pos,-h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    DisableClipping(false)
end

function tbl.ScrollPanel_VBar(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Bar"))
    surface.DrawRect(0,0,w,h)
end

function tbl.ScrollPanel_VBar_Grip(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Bar"))
    surface.DrawOutlinedRect(0,0,w,h,1)
end

function tbl.OnLoaded()
    table.Merge(RiceUI.Examples,{
        ModernRect = {
            {type="rl_frame",Text="Example",Center=true,Root=true,Alpha=0,w=1200,h=800,ThemeName="modern_rect",
                Paint = RiceUI.GetTheme("modern_rect").RL_Frame,
                GTheme = {name = "modern_rect",Theme = {Color="white1"}},
    
                Anim = {{type = "alpha",time = 0.075,alpha = 255}},
                children = {
                    {type="button",x=10,y=40,w=100,h=50},
    
                    {type="entry",x=10,y=100,w=300,h=30},
    
                    {type="switch",x=120,y=38,w=50,h=25},
                    {type="switch",x=120,y=67,w=50,h=25,Value=true},
    
                    {type="image",x=320,y=40,w=90,h=90,Image="gui/dupe_bg.png"},
                    {type="web_image",x=420,y=40,w=90,h=90,Image="https://i.328888.xyz/2023/01/29/jM97x.jpeg"},
    
                    {type="panel",x=10,y=140,h=645},
                    {type="scrollpanel",ID="ScrollPanel",x=15,y=145,h=635,w=490,OnCreated = function(pnl)
                        for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                            Paint = RiceUI.GetTheme("modern_rect").Panel,
                            Theme = {Color = "white2"},
                        },pnl)) end
                    end},
    
                    {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",ThemeName="modern_rect",
                        Paint = RiceUI.GetTheme("modern_rect").RL_Frame,
                        GTheme = {name = "modern_rect",Theme = {color = "white1"}},
                        children={
                            {type="slider",y=40}
                        }
                    }
                },
            }
        },
    
        ModernRectBlack = {
            {type="rl_frame",Text="Example",Center=true,Root=true,Alpha=0,w=1200,h=800,TitleColor=Color(250,250,250),CloseColor="black",ThemeName="modern_rect",
                Paint = RiceUI.GetTheme("modern_rect").RL_Frame,
                Theme = {Color="black1",TextColor="black1"},
                GTheme = {name = "modern_rect",Theme = {Color="black1",TextColor="black1"}},
    
                Anim = {{type = "alpha",time = 0.075,alpha = 255}},
                children = {
                    {type="button",x=10,y=40,w=100,h=50},
    
                    {type="entry",x=10,y=100,w=300,h=30},
    
                    {type="switch",x=120,y=38,w=50,h=25,DisableColor=Color(70,70,70)},
                    {type="switch",x=120,y=67,w=50,h=25,DisableColor=Color(70,70,70),Value=true},
    
                    {type="image",x=320,y=40,w=90,h=90,Image="gui/dupe_bg.png"},
                    {type="web_image",x=420,y=40,w=90,h=90,Image="https://i.328888.xyz/2023/01/29/jM97x.jpeg"},
    
                    {type="panel",x=10,y=140,h=645},
                    {type="scrollpanel",ID="ScrollPanel",x=15,y=145,h=635,w=490,Theme = {Color = "black1"},OnCreated = function(pnl)
                        for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                            Paint = RiceUI.GetTheme("modern_rect").Panel,
                            Theme = {Color = "black2"},
                        },pnl)) end
                    end},
    
                    {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",TitleColor=Color(250,250,250),CloseColor="black",ThemeName="modern_rect",
                        Paint = RiceUI.GetTheme("modern_rect").RL_Frame,
                        Theme = {Color="black1",TextColor="black1"},
                        GTheme = {name = "modern_rect",Theme = {Color="black1",TextColor="black1"}},
    
                        children={
                            {type="slider",y=40}
                        }
                    }
                },
            }
        }
    })
end

return tbl