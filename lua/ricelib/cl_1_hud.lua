RICELIB_PLAYERCHAT = false

// HUD/UI 位置/大小 缩放

// 兼容旧版本
    function RL_hudScale(x,y)
        return x*(ScrW()/1920),y*(ScrH()/1080)
    end

    function RL_hudScaleX(x)
        return x*(ScrW()/1920)
    end

    function RL_hudScaleY(y)
        return y*(ScrH()/1080)
    end

function RL.hudScale(x,y)
    return x*(ScrW()/1920),y*(ScrH()/1080)
end

function RL.hudScaleX(x)
    return x*(ScrW()/1920)
end

function RL.hudScaleY(y)
    return y*(ScrH()/1080)
end

if file.Exists("ricelib/settings/hud_offset.json", "DATA") then
    RL.VGUI.HUDOffset = util.JSONToTable(file.Read("ricelib/settings/hud_offset.json", "DATA")) or {}
else
    RL.VGUI.HUDOffset = {}
    file.Write("ricelib/settings/hud_offset.json", util.TableToJSON(RL.VGUI.HUDOffset))
end

function RL.hudOffset(x,y,profile)
    if RL.VGUI.HUDOffset[profile] then 
        return RL.VGUI.HUDOffset[profile].x,RL.VGUI.HUDOffset[profile].y
    end

    return x * (ScrW()/1920), y * (ScrH()/1080)
end

function RL.hudOffsetX(x,profile)
    if RL.VGUI.HUDOffset[profile] then return RL.VGUI.HUDOffset[profile].x end

    return x * (ScrW()/1920)
end

function RL.hudOffsetY(y,profile)
    if RL.VGUI.HUDOffset[profile] then return RL.VGUI.HUDOffset[profile].y end

    return y * (ScrH()/1080)
end

function RL.Change_HUDOffset(profile,x,y)
    RL.VGUI.HUDOffset[profile] = {x=x,y=y}

    file.Write("ricelib/settings/hud_offset.json", util.TableToJSON(RL.VGUI.HUDOffset))
end

function RL.Clear_HUDOffset(profile,x,y)
    RL.VGUI.HUDOffset[profile] = nil

    file.Write("ricelib/settings/hud_offset.json", util.TableToJSON(RL.VGUI.HUDOffset))
end

// HUD位置更改按钮
function RL.VGUI.OffsetButton(panel,profile,x,y,show,showName,resetFun)
    resetFun = resetFun or function() end

    local btn = vgui.Create("DButton",panel)
    btn:SetSize(btn:GetParent():GetSize())
    btn:SetText("")
    btn.RLshow = show
    btn.RLshowName = showName
    btn.Paint = function(self,w,h)
        local color = Color(0,255,0,255)
        if RICELIB_PLAYERCHAT then color = Color(0,255,0,100) end
        if self.Dragging then color = Color(0,255,0,255) end

        if self.Dragging or RICELIB_PLAYERCHAT then
            surface.SetDrawColor(color)
            surface.DrawOutlinedRect(0,0,w,h,2)
        end

        if self.RLshow and RICELIB_PLAYERCHAT then
            draw.SimpleText(self.RLshowName,"OPPOSans_30",w/2,h/2,Color(0,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
    btn.DoClick = function(self)
        if not panel.Dragging then
            panel.Dragging = true
            self.Dragging = true

            local x,y = input.GetCursorPos()
            panel.DragOrgX, panel.DragOrgY = panel:GetX() - x,panel:GetY() - y

            return
        else
            panel.Dragging = false 
            self.Dragging = false

            RL.Change_HUDOffset(profile,panel:GetX(),panel:GetY())
        end
    end
    btn.DoRightClick = function(self)
        panel.Dragging = false
        self.Dragging = false
        panel:SetPos(RL.hudScale(x,y))

        RL.Clear_HUDOffset(profile,0,0)

        self.OnPosReset()
        self:SetSize(self:GetParent():GetSize())
    end
    btn.OnPosReset = resetFun

    panel.Think = function(self)
        if not self.Dragging then return end
    
        local x,y = input.GetCursorPos()
    
        self:SetPos(self.DragOrgX + x, self.DragOrgY + y)
    end

    return btn
end


hook.Add("StartChat","RiceLib_StartChat",function()
    RICELIB_PLAYERCHAT = true
end)

hook.Add("FinishChat","RiceLib_FinishChat",function()
    RICELIB_PLAYERCHAT = false
end)