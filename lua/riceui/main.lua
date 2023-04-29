RiceUI = RiceUI or {}
RiceUI.Elements = {}
RiceUI.UniProcess = {}
RiceUI.UniProcess_Legacy = {}
RiceUI.Theme = {}
RiceUI.UI = {}
RiceUI.Prefab = {}
RiceUI.RootName = "main"

RL.Functions.LoadFiles(RiceUI.Elements,"riceui/elements")
RL.Functions.LoadFiles(RiceUI.UniProcess_Legacy,"riceui/uniprocess_legacy")
RL.Functions.LoadFiles(RiceUI.Theme,"riceui/theme")

file.CreateDir("riceui")
file.CreateDir("riceui/web_image")

function RiceUI.SimpleCreate(data,parent)
    if not RiceUI.Elements[data.type] then RiceUI.Elements["error"].Create(data,parent) return end

    local pnl = RiceUI.Elements[data.type].Create(data,parent)

    table.insert(RiceUI.UI,pnl)

    RiceUI.DoProcess(pnl)

    if data.children then
        RiceUI.Create(data.children,pnl)
    end

    if data.OnCreated then data.OnCreated(pnl) end
    if pnl.ChildCreated then pnl.ChildCreated() end

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
    RiceUI.UniProcess_Legacy[name](panel,data)
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

for k,v in pairs(RiceUI.Theme) do
    if !v.OnLoaded then continue end

    v.OnLoaded()
end

RL.IncludeDir("riceui/prefabs",true)

function RiceUI.DoProcess(pnl)
    if !pnl.RiceUI_Data then return end

    for name,data in pairs(pnl.RiceUI_Data) do
        if !RiceUI.UniProcess[name] then continue end

        local processor
        if istable(RiceUI.UniProcess[name]) then
            processor = RiceUI.UniProcess[name][pnl.ProcessID]
        else
            processor = RiceUI.UniProcess[name]
        end

        if processor then
            processor(pnl,data)
        end
    end
end

function RiceUI.DefineUniProcess(name,data)
    RiceUI.UniProcess[name] = data
end

RL.IncludeDir("riceui/uniprocess",true)