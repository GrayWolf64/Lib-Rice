if SERVER then return end

RiceLib.Cache.Keybinds = RiceLib.Cache.Keybinds or {}
RiceLib.Cache.KeybindRegistrations = RiceLib.Cache.KeybindRegistrations or {}
RiceLib.Cache.KeybindLookup = RiceLib.Cache.KeybindLookup or {}

RiceLib.Keybinds = {}

local KeybindRegistrations = RiceLib.Cache.KeybindRegistrations
local Keybinds = RiceLib.Cache.Keybinds
local KeybindLookup = RiceLib.Cache.KeybindLookup

local baseKeyBindInfo = {
    DisplayName = "按键绑定",
    Category = "RiceLib",
}

local keybindMeta = {}
keybindMeta.__index = keybindMeta

function keybindMeta:OnPressed()
    print("Im Being Pressed! ID:" .. self.ID)
end

function keybindMeta:OnReleased()
    print("Im Being Released! ID:" .. self.ID)
end

function keybindMeta:GetKey()
    return Keybinds[self.ID]
end

function keybindMeta:GetKeyName()
    return input.GetKeyName(Keybinds[self.ID])
end

local function buildKeybindLookup()
    KeybindLookup = {}

    for id, key in pairs(Keybinds) do
        if not KeybindLookup[key] then
            KeybindLookup[key] = {}
        end

        table.insert(KeybindLookup[key], KeybindRegistrations[id])
    end
end

function RiceLib.Keybinds.Register(id, info)
    local keybindInfo = RiceLib.Table.InheritCopy(info, baseKeyBindInfo)
    keybindInfo.ID = id
    setmetatable(keybindInfo, keybindMeta)

    if keybindInfo.DefaultKey and not Keybinds[id] then
        RiceLib.Keybinds.SetKey(id, keybindInfo.DefaultKey)
    end

    KeybindRegistrations[id] = keybindInfo

    buildKeybindLookup()

    return keybindInfo
end

function RiceLib.Keybinds.SetKey(id, key)
    if isstring(key) then
        key = input.GetKeyCode(key)
    end

    Keybinds[id] = key
    RiceLib.Config.SaveConfig("ricelib", "keybinds", Keybinds)

    buildKeybindLookup()
end

function RiceLib.Keybinds.GetKeybindRegistrations(id)
    if id then
        return KeybindRegistrations[id]
    end

    return KeybindRegistrations
end

function RiceLib.Keybinds.GetKeybinds(id)
    if id then
        return Keybinds[id]
    end

    return Keybinds
end

function RiceLib.Keybinds.BindedToKey(id)
    if Keybinds[id] then return true end

    return false
end

local function loadKeybinds()
    Keybinds = RiceLib.Config.LoadConfig("ricelib", "keybinds", {})

    buildKeybindLookup()
end

hook.Add("PlayerButtonDown", "RiceLib_Keybind", function(_, button)
    if not IsFirstTimePredicted() then return end
    if not KeybindLookup[button] then return end

    for _, keybindObject in ipairs(KeybindLookup[button]) do
        keybindObject:OnPressed()
    end
end)

hook.Add("PlayerButtonUp", "RiceLib_Keybind", function(_, button)
    if not IsFirstTimePredicted() then return end
    if not KeybindLookup[button] then return end

    for _, keybindObject in ipairs(KeybindLookup[button]) do
        keybindObject:OnReleased()
    end
end)

concommand.Add("ricelib_keybind_dump", function()
    print("keybinds")
    PrintTable(Keybinds)

    print("lookup")
    PrintTable(KeybindLookup)
end)

concommand.Add("ricelib_keybind_dump_registrations", function()
    PrintTable(KeybindRegistrations)
end)

concommand.Add("ricelib_keybind_reload", function()
    loadKeybinds()
end)

RiceLib.Keybinds.Register("ricelib_test", {
    DisplayName = "测试按键",
})

loadKeybinds()