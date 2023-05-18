RiceUI = RiceUI or {}

RiceUI.Examples = {
    Modern = {
        {type="rl_frame",Text="Example",
            Center=true,
            Root=true,
            Alpha=0,
            w=1200,
            h=800,

            UseNewTheme = true,

            Anim = {{type = "alpha",time = 0.075,alpha = 255}},
            children = {
                {type="button",x=10,y=40,w=100,h=50},

                {type="entry",x=10,y=100,w=300,h=30},

                {type="switch",x=120,y=38,w=50,h=25},
                {type="switch",x=120,y=67,w=50,h=25,Value=true},

                {type="image",x=320,y=40,w=90,h=90,Image="gui/dupe_bg.png"},
                {type="web_image",x=420,y=40,w=90,h=90,Image="https://i.328888.xyz/2023/01/29/jM97x.jpeg"},

                {type="rl_numberwang",x=10,y=140},
                {type="rl_numberwang",x=140,y=140,Step=5},

                {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",
                    UseNewTheme = true,

                    children={
                        {type="slider",y=40},
                        {type="rl_combo",y=80,Choice={
                            {"选项1"},
                            {"选项2"},
                            {"选项3"}
                        }},
                    },
                },

                {type="button",ID="btn_Anim_Expand",Text="Animation 1",x=10,y=180,w=200,h=50,},
                {type="button",ID="btn_Menu",Text="Menu 1",x=10,y=240,w=200,h=50,
                    DoClick = function(self)
                        RiceUI.SimpleCreate({type="rl_menu"})
                    end
                },

                {type="rl_form",Text="Form",x=10,y=300,
                    children = {
                        {type="rl_button",Dock=TOP}
                    }
                },

                {type="rl_panel",ID="Anim_Expand",w=0,h=0,
                    NoGTheme=true,
                    Theme={ThemeName="modern",ThemeType="Panel",Color="black"},
                }
            },

            RiceUI_Event = function(event,id,data)
                if id ~= "btn_Anim_Expand" then return end

                local frame = data:GetParent()

                RiceUI.Animation.ExpandFromPos(frame.Elements.Anim_Expand,{
                    StartX=gui.MouseX()-frame:GetX(),
                    StartY=gui.MouseY()-frame:GetY(),
                    EndX = 0,
                    EndY = 30,
                    SizeW = 1200,
                    SizeH = 770,
                    callback = function()
                        RiceUI.SimpleCreate({type="rl_button",Center=true,
                            DoClick=function()
                                RiceUI.Animation.Shrink(frame.Elements.Anim_Expand,{
                                    callback = function()
                                        frame.Elements.Anim_Expand:Clear()
                                    end
                                })
                            end
                        },frame.Elements.Anim_Expand)
                    end
                })
            end
        }
    },
}

RiceUI.Examples.ModernBlack = table.Copy(RiceUI.Examples.Modern)
RiceUI.Examples.ModernBlack[1].Theme = {ThemeName="modern",ThemeType="RL_Frame",Color="black",TextColor="black"}

concommand.Add("riceui_examples",function()
    RiceUI.SimpleCreate({type="rl_frame",Text="Examples",Center=true,Root=true,Alpha=0,w=400,h=600,TitleColor=Color(250,250,250),CloseColor="black",
        Theme = {ThemeName="modern",ThemeType="RL_Frame",Color="black1",TextColor="black1"},
        GTheme = {name = "modern",Theme = {Color="black1",TextColor="black1"}},

        Anim = {{type = "alpha",time = 0.075,alpha = 255}},
        children = {
            {type="scrollpanel",ID="ScrollPanel",x=10,y=40,w=380,h=550,OnCreated = function(pnl)
                for k,v in SortedPairs(RiceUI.Examples) do
                    pnl:AddItem(RiceUI.SimpleCreate({type="rl_button",Dock=TOP,h=50,Margin={0,0,5,5},Text=k,
                        Theme = {ThemeType="Button",ThemeName="modern_rect",Color = "white"},

                        DoClick = function()
                            RiceUI.Create(RiceUI.Examples[k])
                        end
                    },pnl))
                end
            end},
        },
    })
end)