RL.VGUI = RL.VGUI or {}

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
    if RL.VGUI.HUDOffset[profile] then x = RL.VGUI.HUDOffset[profile].x end
    if RL.VGUI.HUDOffset[profile] then y = RL.VGUI.HUDOffset[profile].y end

    return x * (ScrW()/1920), y * (ScrH()/1080)
end

function RL.hudOffsetX(x,profile)
    if RL.VGUI.HUDOffset[profile] then x = RL.VGUI.HUDOffset[profile].x end

    return x * (ScrW()/1920)
end

function RL.hudOffsetY(y,profile)
    if RL.VGUI.HUDOffset[profile] then y = RL.VGUI.HUDOffset[profile].y end

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
function RL.VGUI.OffsetButton(panel,profile,x,y)
    local btn = vgui.Create("DButton",panel)
    btn:SetSize(btn:GetParent():GetSize())
    btn:SetText("")
    btn.Paint = function() end
    btn.DoClick = function(self)
        if not panel.Dragging then
            panel.Dragging = true

            local x,y = input.GetCursorPos()
            panel.DragOrgX, panel.DragOrgY = panel:GetX() - x,panel:GetY() - y

            return
        else
            panel.Dragging = false 

            RL.Change_HUDOffset(profile,panel:GetX(),panel:GetY())
        end
    end
    btn.DoRightClick = function()
        panel.Dragging = false
        panel:SetPos(RL.hudScale(x,y))

        RL.Clear_HUDOffset(profile,0,0)
    end

    panel.Think = function(self)
        if not self.Dragging then return end
    
        local x,y = input.GetCursorPos()
    
        self:SetPos(self.DragOrgX + x, self.DragOrgY + y)
    end
end

// 一键创建 10 - 100 大小的字体
function RL.VGUI.RegisterFont(FontName, CodeName, addData)
    for i=1,10 do
        local data = {
            font = FontName,
            size = i*10,
            weight = 500,
            antialias = true,
            additive = false,
            outline = false
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*10,data)
    end

    print("[Ricelib Font] RegisterFont: "..CodeName.." ("..FontName..")")
end

// 现代VGUI组件
function RL.VGUI.ModernLabel(Text,Panel,FontSize,X,Y)
    local lb = Label(Text, Panel)
    lb:SetPos(RL_hudScale(X,Y))
    lb:SetFont("OPPOSans_"..FontSize)
    lb:SetColor(Color(30,30,30))
    lb:SizeToContents()

    return lb
end

function RL.VGUI.ModernButton(Text,Panel,FontSize,X,Y,W,H,DoClickFun,...)
    local var = {...}
    DoClickFun = DoClickFun or function() end

    local btn = vgui.Create("DButton", Panel)
    btn:SetPos(RL_hudScale(X,Y))
    btn:SetSize(RL_hudScale(W,H))
    btn:SetText(Text)
    btn:SetTheme("ModernButton")
    btn:SetFont("OPPOSans_"..FontSize)
    btn.DoClick = function()
        DoClickFun(unpack(var))
    end

    return btn
end

function RL.VGUI.ModernTextEntry(Text,Panel,FontSize,X,Y,W,H,TEW,OnEnter)
    OnEnter = OnEnter or function() end
    
    local body = vgui.Create("DPanel", Panel)
    body:SetSize(RL_hudScale(W,H))
    body:SetPos(RL_hudScale(X,Y))
    body.Paint = function() end

    RL.VGUI.ModernLabel(Text,body,FontSize,0,0):Dock(LEFT)

    local TE = vgui.Create("DTextEntry", body)
    TE:Dock(RIGHT)
    TE:SetWide(RL_hudScaleX(TEW))
    TE:SetFont("OPPOSans_"..FontSize)
    TE.OnEnter = function(self,text)
        OnEnter(text)
    end

    return body,TE
end