RiceUI = {}
RiceUI.Elements = {}
RiceUI.UniProcess = {}
RiceUI.Theme = {}

RL.Functions.LoadFiles(RiceUI.Elements,"riceui/elements")
RL.Functions.LoadFiles(RiceUI.UniProcess,"riceui/uniprocess")
RL.Functions.LoadFiles(RiceUI.Theme,"riceui/theme")

file.CreateDir("riceui")
file.CreateDir("riceui/web_image")

function RiceUI.Create(tbl,parent)
    local returns = {}

    for _,data in ipairs(tbl) do
        if not RiceUI.Elements[data.type] then RiceUI.Elements["error"](data,parent) continue end

        local pnl = RiceUI.Elements[data.type](data,parent)

        table.insert(returns,pnl)

        if data.children then
            RiceUI.Create(data.children,pnl)
        end
    end
end

function RiceUI.SimpleCreate(data,parent)
    if not RiceUI.Elements[data.type] then RiceUI.Elements["error"](data,parent) return end

    local pnl = RiceUI.Elements[data.type](data,parent)

    if data.children then
        RiceUI.Create(data.children,pnl)
    end

    return pnl
end

function RiceUI.Process(name,panel,data)
    RiceUI.UniProcess[name](panel,data)
end

function RiceUI.GetTheme(name) return RiceUI.Theme[name] end

concommand.Add("RiceUI_Example",function()
    RiceUI.Create({
        {type = "frame",w = 500,h = 1000,Root = true,Center = true,Alpha = 0,
            Anim = {{type = "alpha",time = 0.075,alpha = 255}},
            children = {
                {type = "panel",w = 480,h = 955,x = 10,y = 35,
                    children = {
                        {type = "panel",w = 330,h = 120,x = 5,y = 5,
                            Paint = RiceUI.GetTheme("modern").Panel,
                            Theme = {RawColor = Color(200,200,200)},
                        },
    
                        {type = "panel",w = 100,h = 50,x = 10,y = 10,
                            Paint = RiceUI.GetTheme("modern").Panel,
                            Theme = {Color = "black1"},
                        },
    
                        {type = "panel",w = 100,h = 50,x = 120,y = 10,
                            Paint = RiceUI.GetTheme("modern").Panel,
                            Theme = {Color = "black2"},
                        },
    
                        {type = "panel",w = 100,h = 50,x = 230,y = 10,
                            Paint = RiceUI.GetTheme("modern").Panel,
                            Theme = {Color = "black3"},
                        },
    
                        {type = "panel",w = 100,h = 50,x = 10,y = 70,
                            Paint = RiceUI.GetTheme("modern").Panel,
                            Theme = {Color = "white1"},
                        },
    
                        {type = "panel",w = 100,h = 50,x = 120,y = 70,
                            Paint = RiceUI.GetTheme("modern").Panel,
                            Theme = {Color = "white2"},
                        },
    
                        {type = "panel",w = 100,h = 50,x = 230,y = 70,
                            Paint = RiceUI.GetTheme("modern").Panel,
                            Theme = {Color = "white3"},
                        },
    
                        {type = "label",x = 10,y = 130,Resize = true},
                        {type = "textentry",x = 10,y = 175},
    
                        {type = "button",x = 10,y = 220,
                            DoClick = function() surface.PlaySound("buttons/button22.wav") end,
                        },

                        {type = "button",x = 180,y = 220,
                            Paint = RiceUI.GetTheme("modern").Button,
                            Theme = {Color = "white1"},
                            DoClick = function() surface.PlaySound("buttons/button22.wav") end,
                        },

                        {type = "button",x = 285,y = 220,
                            Paint = RiceUI.GetTheme("modern").Button,
                            Theme = {Color = "black1"},
                            Color = Color(200,200,200),
                            DoClick = function() surface.PlaySound("buttons/button22.wav") end,
                        },

                        {type = "image",x = 120,y = 220,
                            DoClick = function() surface.PlaySound("buttons/button22.wav") end,
                        },
                    }
                }
            }
        }
    })
end)