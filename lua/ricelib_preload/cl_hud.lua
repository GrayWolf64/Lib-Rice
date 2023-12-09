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

local function read_scale_profiles()
    return read_settings().scale_profiles
end

function RL_hudScale(x, y) return x * ratio_w, y * ratio_h end
function RL_hudScaleX(x) return x * ratio_w end
function RL_hudScaleY(y) return y * ratio_h end

local function hud_scale(x, y, profile)
    local scale = read_scale_profiles()[profile]
    if scale then return x * ratio_w * scale, y * ratio_h * scale end
    return x * ratio_w, y * ratio_h
end

local function hud_scale_single(xory, profile, ratio)
    local scale = read_scale_profiles()[profile]
    if scale then return xory * ratio * scale end
    return xory * ratio
end

local function hud_scale_x(x, profile)
    return hud_scale_single(x, profile, ratio_w)
end

local function hud_scale_y(y, profile)
    return hud_scale_single(y, profile, ratio_h)
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
    local data_previous = read_hud_offsets()
    data_previous[profile] = {x = x, y = y}
    file.Write(settings_file, util.TableToJSON(data_previous, true))
end

local function clear_hud_offset(profile)
    local data_previous = read_hud_offsets()
    data_previous[profile] = nil
    file.Write(settings_file, util.TableToJSON(data_previous, true))
end

RL.hudScale = hud_scale
RL.hudScaleX = hud_scale_x
RL.hudScaleY = hud_scale_y

RL.hudOffset = hud_offset
RL.hudOffsetX = hud_offset_x
RL.hudOffsetY = hud_offset_y

RL.UpdateHUDOffset = update_hud_offset
RL.ClearHUDOffset = clear_hud_offset