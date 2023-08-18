RiceUI = RiceUI or {}
RiceUI.UniProcess = {}

function RiceUI.DoProcess(pnl)
    if not pnl.RiceUI_Data then return end

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