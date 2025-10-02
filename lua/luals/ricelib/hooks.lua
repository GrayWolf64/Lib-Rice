-- MARK: Lua Language Server Annotations

---@param eventName string The event to hook on to. This can be any GM_Hooks hook, gameevent after using gameevent.Listen, or custom hook run with hook.Call or hook.Run.
---@param identifier any The unique identifier, usually a string. This can be used elsewhere in the code to replace or remove the hook. The identifier **should** be unique so that you do not accidentally override some other mods hook, unless that's what you are trying to do.
---@param func function The function to be called, arguments given to it depend on the identifier used.
---@overload fun(eventName: "RiceLib_ConfigManager_ValueChanged", identifier: any, func: fun(nameSpace:string, key:string, value:any))
---@overload fun(eventName: "RiceLibClientReady", identifier: any, func: fun(ply:Player))
function hook.Add(eventName, identifier, func) end
