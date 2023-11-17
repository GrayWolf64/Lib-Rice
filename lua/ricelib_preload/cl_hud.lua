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

function RL.VGUI.OffsetButton(panel, profile, x, y, show, showName, resetFun)
    resetFun = resetFun or function() end

    local btn = vgui.Create("DButton", panel)
    btn:SetSize(btn:GetParent():GetSize())
    btn:SetText("")
    btn.RLshow = show
    btn.RLshowName = showName
    btn.Paint = function(self, w, h)
        local color = Color(0, 255, 0, 255)
        local chatVisible = LocalPlayer():IsTyping()
        if chatVisible then color = Color(0, 255, 0, 100) end
        if self.Dragging then color = Color(0, 255, 0, 255) end

        if self.Dragging or chatVisible then
            surface.SetDrawColor(color)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end

        if self.RLshow and chatVisible then
            draw.SimpleText(self.RLshowName, "OPPOSans_30", w / 2, h / 2, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    btn.DoClick = function(self)
        if not panel.Dragging then
            panel.Dragging = true
            self.Dragging = true

            local x, y = input.GetCursorPos()
            panel.DragOrgX, panel.DragOrgY = panel:GetX() - x, panel:GetY() - y

            return
        else
            panel.Dragging = false
            self.Dragging = false

            update_hud_offset(profile, panel:GetX(), panel:GetY())
        end
    end
    btn.DoRightClick = function(self)
        panel.Dragging = false
        self.Dragging = false
        panel:SetPos(RL.hudScale(x, y))

        clear_hud_offset(profile, 0, 0)

        self:SetSize(self:GetParent():GetSize())
        self.OnPosReset(self)
    end
    btn.OnPosReset = resetFun

    btn.Think = function(self)
        if not self:GetParent().Dragging then return end
        local x, y = input.GetCursorPos()
        self:GetParent():SetPos(self:GetParent().DragOrgX + x, self:GetParent().DragOrgY + y)
    end

    return btn
end

RL.hudScale = hud_scale
RL.hudScaleX = hud_scale_x
RL.hudScaleY = hud_scale_y

RL.hudOffset = hud_offset
RL.hudOffsetX = hud_offset_x
RL.hudOffsetY = hud_offset_y

RL.UpdateHUDOffset = update_hud_offset
RL.ClearHUDOffset = clear_hud_offset