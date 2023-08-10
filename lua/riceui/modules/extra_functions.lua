RiceUI = RiceUI or {}
RiceUI.ExtraFunctions = {}

function RiceUI.ApplyExtraFunctions(self)
    for name,func in pairs(RiceUI.ExtraFunctions) do

        if istable(func) then
            if func[self.ProcessID] then
                self:GetTable()[name] = func
            end
        else
            self:GetTable()[name] = func
        end
    end
end

function RiceUI.DefineExtraFunction(name,data)
    RiceUI.ExtraFunctions[name] = data
end

RL.IncludeDir("riceui/extra_functions",true)