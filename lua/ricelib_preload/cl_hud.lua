RICELIB_PLAYERCHAT = false

if file.Exists("ricelib/settings/hud_offset.json", "DATA") then
    RL.VGUI.HUDOffset = util.JSONToTable(file.Read("ricelib/settings/hud_offset.json", "DATA")) or {}
else
    RL.VGUI.HUDOffset = {}
    file.Write("ricelib/settings/hud_offset.json", util.TableToJSON({}))
end

if file.Exists("ricelib/settings/scale.json", "DATA") then
    RL.VGUI.ScaleProfile = util.JSONToTable(file.Read("ricelib/settings/scale.json", "DATA")) or {}
else
    RL.VGUI.ScaleProfile = {}
    file.Write("ricelib/settings/scale.json", util.TableToJSON({}))
end

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

function RL.hudScale(x,y,profile)
    if RL.VGUI.ScaleProfile[profile] then
        return x * (ScrW()/1920) * RL.VGUI.ScaleProfile[profile], y * (ScrH()/1080) * RL.VGUI.ScaleProfile[profile]
    end 

    return x*(ScrW()/1920),y*(ScrH()/1080)
end

function RL.hudScaleX(x,profile)
    if RL.VGUI.ScaleProfile[profile] then
        return x * (ScrW()/1920) * RL.VGUI.ScaleProfile[profile]
    end 

    return x*(ScrW()/1920)
end

function RL.hudScaleY(y,profile)
    if RL.VGUI.ScaleProfile[profile] then
        return y * (ScrH()/1080) * RL.VGUI.ScaleProfile[profile]
    end 

    return y*(ScrH()/1080)
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

    file.Write("ricelib/settings/hud_offset.json", util.TableToJSON(RL.VGUI.HUDOffset,true))
end

function RL.Clear_HUDOffset(profile,x,y)
    RL.VGUI.HUDOffset[profile] = nil

    file.Write("ricelib/settings/hud_offset.json", util.TableToJSON(RL.VGUI.HUDOffset,true))
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
        if pace and pace.Active then return end

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
        if pace and pace.Active then return end

        panel.Dragging = false
        self.Dragging = false
        panel:SetPos(RL.hudScale(x,y))

        RL.Clear_HUDOffset(profile,0,0)

        self:SetSize(self:GetParent():GetSize())
        self.OnPosReset(self)
    end
    btn.OnPosReset = resetFun

    btn.Think = function(self)
        if not self:GetParent().Dragging then return end
    
        local x,y = input.GetCursorPos()
    
        self:GetParent():SetPos(self:GetParent().DragOrgX + x, self:GetParent().DragOrgY + y)
    end

    return btn
end

hook.Add("StartChat","RiceLib_StartChat",function()
    RICELIB_PLAYERCHAT = true
end)

hook.Add("FinishChat","RiceLib_FinishChat",function()
    RICELIB_PLAYERCHAT = false
end)