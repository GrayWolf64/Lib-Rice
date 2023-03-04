function RiceUI.Prefab.Notify(args)
    table.Inherit(args,{
        Title = "提示",
        Text = "这是一个提示",
        ButtonText = "确定",
        DoClick = function(self) self:GetParent():Remove() end,
    })

    local frame = RiceUI.SimpleCreate({type = "rl_frame",w=400,h=200,Text = args.Title,Center = true,Root = true,children = {
        {type = "panel",x=0,y=30,w=400,h=120,Paint=function(self,w,h)
            draw.SimpleText(args.Text,"SourceHan_35",w/2,h/2,Color(25,25,25),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end},

        {type = "button",ID = "CloseButton",Text=args.ButtonText,Font="SourceHan_25",x=0,y=30,w=50,h=30,DoClick=args.DoClick,
            Paint = RiceUI.GetTheme("modern_rect").Button,
            Theme = {Color="white1"},
        }
    }})

    frame.Elements["CloseButton"]:SizeToContents()
    local w,h = frame.Elements["CloseButton"]:GetSize()
    frame.Elements["CloseButton"]:SetSize(w+10,h+5)

    local w,h = frame.Elements["CloseButton"]:GetSize()
    frame.Elements["CloseButton"]:SetPos(frame:GetWide()/2-w/2,frame:GetTall()-h-10)
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