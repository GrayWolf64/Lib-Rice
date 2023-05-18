RiceUI = RiceUI or {}
RiceUI.Elements = {}
RiceUI.UI = {}
RiceUI.Prefab = {}
RiceUI.RootName = "main"

RL.Functions.LoadFiles(RiceUI.Elements, "riceui/elements")

file.CreateDir("riceui")
file.CreateDir("riceui/web_image")

function RiceUI.SimpleCreate(data, parent)
    if not RiceUI.Elements[data.type] then
        RiceUI.Elements["error"].Create(data, parent)

        return
    end

    local pnl = RiceUI.Elements[data.type].Create(data, parent)
    table.insert(RiceUI.UI, pnl)
    RiceUI.DoProcess(pnl)

    if data.children then
        RiceUI.Create(data.children, pnl)
    end

    if data.OnCreated then
        data.OnCreated(pnl)
    end

    if pnl.ChildCreated then
        pnl:ChildCreated()
    end

    if data.ID then
        if not IsValid(parent) then return pnl end

        parent.Elements = parent.Elements or {}
        parent.Elements[data.ID] = pnl
    end

    return pnl
end

function RiceUI.Create(tbl, parent)
    for i, data in ipairs(tbl) do
        local pnl = RiceUI.SimpleCreate(data, parent)
        local parent = parent or pnl
        parent.Elements = parent.Elements or {}

        if data.ID then
            parent.Elements[data.ID] = pnl
        end
    end
end

concommand.Add("riceui_panic", function()
    for _, v in pairs(RiceUI.UI) do
        if IsValid(v) then
            v:Remove()
        end
    end
end)

concommand.Add("riceui_elements", function()
    PrintTable(RiceUI.Elements)
end)

concommand.Add("riceui_theme", function()
    PrintTable(RiceUI.Theme)
end)

concommand.Add("riceui_all", function()
    PrintTable(RiceUI.UI)
end)

concommand.Add("riceui_reload", function()
    RL.Functions.LoadFiles(RiceUI.Elements, "riceui/elements")
    RL.Functions.LoadFiles(RiceUI.UniProcess, "riceui/uniprocess")
    RL.Functions.LoadFiles(RiceUI.Theme, "riceui/theme")
end)

RL.IncludeDir("riceui/prefabs", true)