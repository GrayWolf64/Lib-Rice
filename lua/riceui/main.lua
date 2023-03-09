RiceUI = RiceUI or {}
RiceUI.Elements = {}
RiceUI.UniProcess = {}
RiceUI.Theme = {}
RiceUI.UI = {}
RiceUI.Prefab = {}
RiceUI.Examples = {}
RiceUI.RootName = "main"

RL.Functions.LoadFiles(RiceUI.Elements,"riceui/elements")
RL.Functions.LoadFiles(RiceUI.UniProcess,"riceui/uniprocess")
RL.Functions.LoadFiles(RiceUI.Theme,"riceui/theme")

file.CreateDir("riceui")
file.CreateDir("riceui/web_image")

function RiceUI.SimpleCreate(data,parent)
    if not RiceUI.Elements[data.type] then RiceUI.Elements["error"](data,parent) return end

    local pnl = RiceUI.Elements[data.type](data,parent)

    if data.children then
        RiceUI.Create(data.children,pnl)
    end

    if data.OnCreated then data.OnCreated(pnl) end
    if pnl.ChildCreated then pnl.ChildCreated() end

    table.insert(RiceUI.UI,pnl)

    return pnl
end

function RiceUI.Create(tbl,parent)
    for i,data in ipairs(tbl) do
        local pnl = RiceUI.SimpleCreate(data,parent)
        local parent = parent or pnl

        parent.Elements = parent.Elements or {}

        if data.ID then parent.Elements[data.ID] = pnl end
    end
end

function RiceUI.Process(name,panel,data)
    RiceUI.UniProcess[name](panel,data)
end

function RiceUI.GetTheme(name) return RiceUI.Theme[name] end

function RiceUI.GetColor(tbl,pnl,name,default)
    local name = name or ""
    local default = default or "white1"

    return pnl.Theme["Raw"..name.."Color"] or tbl[name.."Color"][pnl.Theme.Color] or tbl[name.."Color"][default]
end

function RiceUI.GetColorBase(tbl,pnl,name,default)
    local name = name or ""
    local default = default or "white"
    local color = string.match(pnl.Theme[name.."Color"] or "white","^[a-zA-Z]*")

    return pnl.Theme["Raw"..name.."Color"] or tbl[name.."Color"][color] or tbl[name.."Color"][default]
end

concommand.Add("RiceUI_Panic",function()
    for _,v in pairs(RiceUI.UI) do
        if IsValid(v) then v:Remove() end
    end
end)

concommand.Add("RiceUI_Elements",function() PrintTable(RiceUI.Elements) end)
concommand.Add("RiceUI_Theme",function() PrintTable(RiceUI.Theme) end)
concommand.Add("RiceUI_All",function() PrintTable(RiceUI.UI) end)

concommand.Add("RiceUI_Reload",function()
    RL.Functions.LoadFiles(RiceUI.Elements,"riceui/elements")
    RL.Functions.LoadFiles(RiceUI.UniProcess,"riceui/uniprocess")
    RL.Functions.LoadFiles(RiceUI.Theme,"riceui/theme")
end)

concommand.Add("RiceUI_Create",function(ply,cmd,args,argstr)
    RiceUI.SimpleCreate({type="rl_frame",h=80,Text="UI测试",Center=true,Root=true,
        GTheme = {name = "modern",Theme = {Color="white1"}},
        children={
            {type="entry",y=40,w=480,OnEnter=function(self,text)
                RiceUI.SimpleCreate(util.JSONToTable(text) or {})

                PrintTable(util.JSONToTable(text))
            end}
        }
    })
end)

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

                {type="panel",x=10,y=140,h=645},
                {type="scrollpanel",ID="ScrollPanel",x=15,y=145,h=635,w=490,OnCreated = function(pnl)
                    for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                        Paint = RiceUI.GetTheme("modern").Panel,
                        Theme = {Color = "white2"},
                    },pnl)) end
                end},

                {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",
                    GTheme = {name = "modern",Theme = {color = "white1"}},
                    children={
                        {type="slider",y=40}
                    }
                }
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

                {type="panel",x=10,y=140,h=645},
                {type="scrollpanel",ID="ScrollPanel",x=15,y=145,h=635,w=490,Theme = {Color = "black1"},OnCreated = function(pnl)
                    for i=1,20 do pnl:AddItem(RiceUI.SimpleCreate({type="panel",Dock=TOP,h=150,Margin={0,0,5,5},
                        Paint = RiceUI.GetTheme("modern").Panel,
                        Theme = {Color = "black2"},
                    },pnl)) end
                end},

                {type="rl_frame",x=520,y=40,w=670,Text="Frame In Frame",TitleColor=Color(250,250,250),CloseColor="black",
                    Theme = {Color="black1",TextColor="black1"},
                    GTheme = {name = "modern",Theme = {Color="black1",TextColor="black1"}},

                    children={
                        {type="slider",y=40}
                    }
                }
            },
        }
    }
}

for k,v in pairs(RiceUI.Theme) do
    if !v.OnLoaded then continue end

    v.OnLoaded()
end

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

RL.IncludeDir("riceui/prefabs",true)