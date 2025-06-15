local settings_file = "ricelib/settings.json"
local ratio_w = ScrW() / 1920
local ratio_h = ScrH() / 1080

local function read_settings()
    if not file.Exists(settings_file, "DATA") then
        file.Write(settings_file, util.TableToJSON({
            hud_offsets = {},
            scale_profiles = {}
        }, true))
    end

    return util.JSONToTable(file.Read(settings_file, "DATA"))
end

local function read_hud_offsets()
    return read_settings().hud_offsets
end

function RL_hudScale(x, y) return x * ratio_w, y * ratio_h end
function RL_hudScaleX(x) return x * ratio_w end
function RL_hudScaleY(y) return y * ratio_h end

-- scale profiles are not for HUD coordinates, and reading file is performance heavy
-- Deprecated
--[[local function hud_scale(x, y)
    return x * ratio_w, y * ratio_h
end

local function hud_scale_single(xory, ratio)
    return xory * ratio
end

local function hud_scale_x(x, profile)
    return hud_scale_single(x, ratio_w)
end

local function hud_scale_y(y, profile)
    return hud_scale_single(y, ratio_h)
end]]

local hud_scale
local hud_scale_x
local hud_scale_y

function hud_scale(...)
    hud_scale = RiceUI.Scale.Size

    return hud_scale(...)
end

function hud_scale_x(...)
    hud_scale_x = RiceUI.Scale.PosX

    return hud_scale_x(...)
end

function hud_scale_y(...)
    hud_scale_y = RiceUI.Scale.PosY

    return hud_scale_y(...)
end

local function hud_offset(x, y, profile)
    local offset = read_hud_offsets()[profile]
    if offset then return offset.x, offset.y end
    return x * ratio_w, y * ratio_h
end

local function hud_offset_x(x, profile)
    local offset = read_hud_offsets()[profile]
    if offset then return offset.x end
    return x * ratio_w
end

local function hud_offset_y(y, profile)
    local offset = read_hud_offsets()[profile]
    if offset then return offset.y end
    return y * ratio_h
end

local function update_hud_offset(profile, x, y)
    local data_previous = read_settings()
    data_previous.hud_offsets[profile] = {x = x, y = y}
    file.Write(settings_file, util.TableToJSON(data_previous, true))
end

local function clear_hud_offset(profile)
    local data_previous = read_settings()
    data_previous.hud_offsets[profile] = nil
    file.Write(settings_file, util.TableToJSON(data_previous, true))
end

RiceLib.hudScale = hud_scale
RiceLib.hudScaleX = hud_scale_x
RiceLib.hudScaleY = hud_scale_y

RiceLib.hudOffset = hud_offset
RiceLib.hudOffsetX = hud_offset_x
RiceLib.hudOffsetY = hud_offset_y

RiceLib.UpdateHUDOffset = update_hud_offset
RiceLib.ClearHUDOffset = clear_hud_offset

RiceLib.UI = {
    Scale = hud_scale,
    ScaleX = hud_scale_x,
    ScaleY = hud_scale_y,

    Offset = hud_offset,
    OffsetX = hud_offset_x,
    OffsetY = hud_offset_y,

    UpdateOffset = update_hud_offset,
    ClearOffset = clear_hud_offset,
    ValidOffset = function(profile) return read_hud_offsets()[profile] ~= nil end
}
