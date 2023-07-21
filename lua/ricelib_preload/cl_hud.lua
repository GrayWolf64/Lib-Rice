RICELIB_PLAYERCHAT = false
local offsetFile = "ricelib/settings/hud_offset.json"
local scaleFile = "ricelib/settings/scale.json"
local ratioW, ratioH = ScrW() / 1920, ScrH() / 1080

if file.Exists(offsetFile, "DATA") then
    RL.VGUI.HUDOffset = util.JSONToTable(file.Read(offsetFile, "DATA"))
else
    RL.VGUI.HUDOffset = {}
    file.Write(offsetFile, "[]")
end

if file.Exists(scaleFile, "DATA") then
    RL.VGUI.ScaleProfile = util.JSONToTable(file.Read(scaleFile, "DATA"))
else
    RL.VGUI.ScaleProfile = {}
    file.Write(scaleFile, "[]")
end

function RL_hudScaleX(x) return x * ratioW end
function RL_hudScaleY(y) return y * ratioH end
function RL_hudScale(x, y) return x * ratioW, y * ratioH end

function RL.hudScale(x, y, profile)
    local scale = RL.VGUI.ScaleProfile[profile]
    if scale then return x * ratioW * scale, y * ratioH * scale end
    return x * ratioW, y * ratioH
end

function RL.hudScaleX(x, profile)
    local scale = RL.VGUI.ScaleProfile[profile]
    if scale then return x * ratioW * scale end
    return x * ratioW
end

function RL.hudScaleY(y, profile)
    local scale = RL.VGUI.ScaleProfile[profile]
    if scale then return y * ratioH * scale end
    return y * ratioH
end

function RL.hudOffset(x, y, profile)
    local offset = RL.VGUI.HUDOffset[profile]
    if offset then return offset.x, offset.y end
    return x * ratioW, y * ratioH
end

function RL.hudOffsetX(x, profile)
    local offset = RL.VGUI.HUDOffset[profile]
    if offset then return offset.x end
    return x * ratioW
end

function RL.hudOffsetY(y, profile)
    local offset = RL.VGUI.HUDOffset[profile]
    if offset then return offset.y end
    return y * ratioH
end

function RL.Change_HUDOffset(profile, x, y)
    RL.VGUI.HUDOffset[profile] = {x = x, y = y}
    file.Write(offsetFile, util.TableToJSON(RL.VGUI.HUDOffset, true))
end

function RL.Clear_HUDOffset(profile)
    RL.VGUI.HUDOffset[profile] = nil
    file.Write(offsetFile, "[]")
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
        if RICELIB_PLAYERCHAT then color = Color(0, 255, 0, 100) end
        if self.Dragging then color = Color(0, 255, 0, 255) end

        if self.Dragging or RICELIB_PLAYERCHAT then
            surface.SetDrawColor(color)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end

        if self.RLshow and RICELIB_PLAYERCHAT then
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

            RL.Change_HUDOffset(profile, panel:GetX(), panel:GetY())
        end
    end
    btn.DoRightClick = function(self)
        panel.Dragging = false
        self.Dragging = false
        panel:SetPos(RL.hudScale(x, y))

        RL.Clear_HUDOffset(profile, 0, 0)

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

hook.Add("StartChat", "RiceLib_StartChat", function() RICELIB_PLAYERCHAT = true end)
hook.Add("FinishChat", "RiceLib_FinishChat", function() RICELIB_PLAYERCHAT = false end)