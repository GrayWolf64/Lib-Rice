RiceLib.Cache.Keybinds = RiceLib.Cache.Keybinds or {}
RiceLib.Cache.KeybindLookups = RiceLib.Cache.KeybindLookups or {}
RiceLib.Cache.KeybindFunctions = RiceLib.Cache.KeybindFunctions or {}
RiceLib.Keybinds = {}

local Keybinds = RiceLib.Cache.Keybinds
local KeybindLookups = RiceLib.Cache.KeybindLookups
local KeybindFunctions = RiceLib.Cache.KeybindFunctions

function RiceLib.Keybinds.Register(id, func)
    KeybindFunctions[id] = func
end

function RiceLib.Keybinds.SetKey(func, key)
    RiceLib.Keybinds.Remove(KeybindLookups[func], func)
    RiceLib.Keybinds.Add(key, func)
end

function RiceLib.Keybinds.Add(key, func)
    if not Keybinds[key] then
        Keybinds[key] = {}
    end

    KeybindLookups[func] = key
    table.insert(Keybinds[key], func)

    RiceLib.Config.SaveConfig("ricelib", "keybinds", Keybinds)
end

function RiceLib.Keybinds.Remove(key, func)
    if not Keybinds[key] then return end

    KeybindLookups[func] = nil

    table.RemoveByValue(Keybinds[key], func)

    if table.IsEmpty(Keybinds[key]) then
        Keybinds[key] = nil
    end

    RiceLib.Config.SaveConfig("ricelib", "keybinds", Keybinds)
end

function RiceLib.Keybinds.GetKey(functionName)
    return KeybindLookups[functionName]
end

local function load()
    if not RiceLib.Config then return end

    Keybinds =  RiceLib.Config.LoadConfig("ricelib", "keybinds", {})

    for key, functions in pairs(Keybinds) do
        for _, func in ipairs(functions) do
            KeybindLookups[func] = key
        end
    end
end

load()
hook.Add("InitPostEntity", "RiceLib_LoadKeybind", load)

local function triggerKeybinds(key, pressed)
    for _, func in ipairs(Keybinds[key]) do
        if string.Left(func, 1) == "+" then
            if not pressed then
                func = string.Replace(func, "+", "-")
            end

            RunConsoleCommand(func)

            continue
        end

        local registerdFunction = KeybindFunctions[func]
        if not registerdFunction then return end

        registerdFunction(pressed)
    end
end

hook.Add("PlayerButtonDown", "RiceLib_Keybind", function(_, key)
    if not Keybinds[key] then return end

    triggerKeybinds(key, true)
end)

hook.Add("PlayerButtonUp", "RiceLib_Keybind", function(_, key)
    if not Keybinds[key] then return end

    triggerKeybinds(key, false)
end)

concommand.Add("ricelib_keybind_dump", function()
    print("Keybinds:")
    PrintTable(Keybinds)
    print("\nKeybindLookups:")
    PrintTable(KeybindLookups)
end)