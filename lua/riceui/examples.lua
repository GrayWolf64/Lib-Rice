RiceUI = RiceUI or {}

RiceUI.Examples = {
    Modern = {
        {type="rl_frame",Text="Example",Center=true,Root=true,Alpha=0,w=1200,h=800,
            GTheme = {name = "modern",Theme = {Color="white1"}},

            Anim = {{type = "alpha",time = 0.075,alpha = 255}},
            children = {
                {type="button",x=10,y=40,w=100,h=50},

                {type="entry",x=10,y=100,w=300,h=30},

                {type="switch",x=120,y=38,w=50,h=25},
                {type="switch",x=120,y=67,w=50,h=25,Value=true},

                {type="image",x=320,y=40,w=90,h=90,Image="gui/dupe_bg.png"},
                {type="web_image",x=420,y=40,w=90,h=90,Image="https://i.328888.xyz/2023/01/29/jM97x.jpeg"},

                {type="panel",x=520,y=350,w=670,h=300},
                {type="scrollpanel",ID="ScrollPanel",x=525,y=355,h=290,w=660,OnCreated = function(pnl)
                    for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                        Paint = RiceUI.GetTheme("modern").Panel,
                        Theme = {Color = "white2"},
                    },pnl)) end
                end},

                {type="rl_numberwang",x=10,y=140},
                {type="rl_numberwang",x=140,y=140,Step=5},

                {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",
                    GTheme = {name = "modern",Theme = {color = "white1"}},
                    children={
                        {type="slider",y=40},
                        {type="rl_combo",y=80,Choice={
                            {"选项1"},
                            {"选项2"},
                            {"选项3"}
                        }},
                    },
                },
            },
        }
    },

    ModernBlack = {
        {type="rl_frame",Text="Example",Center=true,Root=true,Alpha=0,w=1200,h=800,TitleColor=Color(250,250,250),CloseColor="black",
            Theme = {Color="black1",TextColor="black1"},
            GTheme = {name = "modern",Theme = {Color="black1",TextColor="black1"}},

            Anim = {{type = "alpha",time = 0.075,alpha = 255}},
            children = {
                {type="button",x=10,y=40,w=100,h=50},

                {type="entry",x=10,y=100,w=300,h=30},

                {type="switch",x=120,y=38,w=50,h=25,DisableColor=Color(70,70,70)},
                {type="switch",x=120,y=67,w=50,h=25,DisableColor=Color(70,70,70),Value=true},

                {type="image",x=320,y=40,w=90,h=90,Image="gui/dupe_bg.png"},
                {type="web_image",x=420,y=40,w=90,h=90,Image="https://i.328888.xyz/2023/01/29/jM97x.jpeg"},

                {type="panel",x=520,y=350,w=670,h=300},
                {type="scrollpanel",ID="ScrollPanel",x=525,y=355,h=290,w=660,Theme = {Color = "black1"},OnCreated = function(pnl)
                    for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                        Paint = RiceUI.GetTheme("modern").Panel,
                        Theme = {Color = "black2"},
                    },pnl)) end
                end},

                {type="rl_numberwang",x=10,y=140,
                    Theme = {ThemeName = "modern",ThemeType="NumberWang",Color="black",TextColor="black"}
                },
                {type="rl_numberwang",x=140,y=140,Step=5,
                    Theme = {ThemeName = "modern",ThemeType="NumberWang",Color="black",TextColor="black"}
                },

                {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",TitleColor=Color(250,250,250),CloseColor = "black",
                    GTheme = {name = "modern",Theme = {Color = "black1",TextColor="black"}},
                    Theme = {Color="black1",TextColor="black1"},

                    children={
                        {type="slider",y=40},
                        {type="rl_combo",y=80,Choice={
                            {"选项1"},
                            {"选项2"},
                            {"选项3"}
                        }},
                    },
                },
            },
        }
    }
}

concommand.Add("RiceUI_Examples",function()
    RiceUI.SimpleCreate({type="rl_frame",Text="Examples",Center=true,Root=true,Alpha=0,w=400,h=600,TitleColor=Color(250,250,250),CloseColor="black",
        Theme = {Color="black1",TextColor="black1"},
        GTheme = {name = "modern",Theme = {Color="black1",TextColor="black1"}},

        Anim = {{type = "alpha",time = 0.075,alpha = 255}},
        children = {
            {type="scrollpanel",ID="ScrollPanel",x=10,y=40,w=380,h=550,OnCreated = function(pnl)
                for k,v in SortedPairs(RiceUI.Examples) do
                    pnl:AddItem(RiceUI.SimpleCreate({type="button",Dock=TOP,h=50,Margin={0,0,5,5},Text=k,
                    Paint = RiceUI.GetTheme("modern_rect").Button,
                    Theme = {Color = "white"},

                    DoClick = function()
                        RiceUI.Create(RiceUI.Examples[k])
                    end
                    },pnl))
                end
            end},
        },
    })
end)