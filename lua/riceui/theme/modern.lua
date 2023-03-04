local tbl = {}
tbl.Color = {
    white = Color(250,250,250),
    white1 = Color(250,250,250),
    white2 = Color(240,240,240),
    white3 = Color(230,230,230),
    black = HSLToColor(0,0,0.2),
    black1 = HSLToColor(0,0,0.2),
    black2 = HSLToColor(0,0,0.18),
    black3 = HSLToColor(0,0,0.16),
}
tbl.TextColor = {
    white = Color(50,50,50),
    black = Color(250,250,250),
}
tbl.OutlineColor = {
    white = HSLToColor(0,0,0.9),
    white1 = HSLToColor(0,0,0.9),
    white1 = HSLToColor(0,0,0.85),
    white1 = HSLToColor(0,0,0.8),
    black = HSLToColor(0,0,0.3),
    black1 = HSLToColor(0,0,0.3),
    black2 = HSLToColor(0,0,0.3),
    black3 = HSLToColor(0,0,0.3),
}

tbl.BarColor = {
    white1 = Color(230,230,230),
    white2 = Color(220,220,220),
    white3 = Color(210,210,210),
    black = HSLToColor(0,0,0.15),
    black1 = HSLToColor(0,0,0.15),
    black2 = HSLToColor(0,0,0.15),
    black3 = HSLToColor(0,0,0.15),
}

tbl.HoverColor = {
    closeButton = Color(255,0,0),
    white = HSLToColor(0,0,0.98),
    white1 = HSLToColor(0,0,0.98),
    white1 = HSLToColor(0,0,0.95),
    white1 = HSLToColor(0,0,0.93),
    black = HSLToColor(0,0,0.35),
    black1 = HSLToColor(0,0,0.35),
    black2 = HSLToColor(0,0,0.40),
    black3 = HSLToColor(0,0,0.45),
}

tbl.FocusColor = {
    white1 = Color(64, 158, 255),
    white2 = Color(64, 158, 255),
    white3 = Color(64, 158, 255),
    black1 = Color(64, 158, 255),
    black2 = Color(64, 158, 255),
    black3 = Color(64, 158, 255),
}

tbl.DisableColor = {
    white = Color(200,200,200),
    white1 = Color(200,200,200),
    white2 = Color(200,200,200),
    white3 = Color(200,200,200),
    black = Color(70,70,70),
    black1 = Color(70,70,70),
    black2 = Color(70,70,70),
    black3 = Color(70,70,70),
}

function tbl.Panel(pnl,w,h)
    if pnl:GetParent():GetClassName() != "CGModBase" then
        draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,RiceUI.GetColor(tbl,pnl,"Outline"))
        draw.RoundedBox(pnl.Theme.Curver or 5,1,1,w-2,h-2,RiceUI.GetColor(tbl,pnl))

        return
    end

    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,RiceUI.GetColor(tbl,pnl))
end

function tbl.RL_Frame(pnl,w,h)
    if pnl:GetParent():GetClassName() != "CGModBase" then
        DisableClipping(true)

        draw.RoundedBox(pnl.Theme.Curver or 5,-1,-1,w+2,h+2,RiceUI.GetColor(tbl,pnl,"Bar"))

        DisableClipping(false)
    end

    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,RiceUI.GetColor(tbl,pnl,"Bar"))
    draw.RoundedBox(pnl.Theme.Curver or 5,0,pnl.Title:GetTall()+10,w,h-pnl.Title:GetTall()-10,RiceUI.GetColor(tbl,pnl))
end

function tbl.Button(pnl,w,h)
    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,pnl.Theme.RawOutlineColor or tbl.OutlineColor[pnl.Theme.Color] or tbl.OutlineColor.white1)

    local color = RiceUI.GetColor(tbl,pnl)

    draw.RoundedBox(pnl.Theme.Curver or 5,1,1,w-2,h-2,color)

    if pnl:IsHovered() then
        draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,ColorAlpha(RiceUI.GetColor(tbl,pnl,"Hover"),150))
    end

    local color = RiceUI.GetColorBase(tbl,pnl,"Text")

    if pnl:IsDown() then color = RiceUI.GetColor(tbl,pnl,"Focus") end

    draw.SimpleText(pnl.Text,pnl:GetFont(),w/2,h/2,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function tbl.TransButton(pnl,w,h)
    local color = RiceUI.GetColor(tbl,pnl,"Hover","closeButton")

    if !pnl.HoverAlpha then pnl.HoverAlpha = 0 end

    if pnl:IsHovered() then
        pnl.HoverAlpha = math.min(pnl.HoverAlpha+(pnl.Theme.Speed or 20)*(RealFrameTime()*100),255)
    else
        pnl.HoverAlpha = math.max(pnl.HoverAlpha-(pnl.Theme.Speed or 20)*(RealFrameTime()*100),0)
    end

    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,ColorAlpha(color,pnl.HoverAlpha))

    draw.SimpleText(pnl.Text,pnl:GetFont(),w/2,h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function tbl.TransButton_F(pnl,w,h)
    local color = RiceUI.GetColor(tbl,pnl,"Hover","closeButton")

    if pnl:IsHovered() then
        pnl.HoverAlpha = 255
    else
        pnl.HoverAlpha = 0
    end

    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,ColorAlpha(color,pnl.HoverAlpha))

    draw.SimpleText(pnl.Text,pnl:GetFont(),w/2,h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function tbl.Entry(pnl,w,h)
    local color = RiceUI.GetColor(tbl,pnl,"Outline")

    if pnl:HasFocus() then
        color = RiceUI.GetColor(tbl,pnl,"Focus")
    end

    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,color)

    local color = RiceUI.GetColor(tbl,pnl)

    draw.RoundedBox(pnl.Theme.Curver or 5,1,1,w-2,h-2,color)

    if pnl:GetValue() == "" then
        draw.SimpleText(pnl:GetPlaceholderText(),pnl:GetFont(),10,h/2,pnl:GetPlaceholderColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(pnl:GetText(),pnl:GetFont(),10,h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

    if pnl:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl,pnl,"Text"),255*math.sin(SysTime()*8%360)))
        surface.DrawRect(10+RL.VGUI.TextWide(pnl:GetFont(),pnl:GetText()),4,1,h-8)
    end
end

function tbl.Switch(pnl,w,h)
    RL.Draw.Circle(h/2,h/2,h/2,32,pnl:GetColor())
    RL.Draw.Circle(w-h/2,h/2,h/2,32,pnl:GetColor())

    surface.SetDrawColor(pnl:GetColor())
    surface.DrawRect(h/2/2+4,0,w-h/2-8,h)

    RL.Draw.Circle(h/2+pnl.togglePos,h/2,h/2-2,32,Color(250,250,250))
end

function tbl.Slider(pnl,w,h)
    local pos = w*pnl:GetSlideX()

    draw.RoundedBox(32,0,h/3,pos,h/3,RiceUI.GetColor(tbl,pnl,"Focus"))
    draw.RoundedBox(32,pos,h/3,w-pos,h/3,RiceUI.GetColor(tbl,pnl,"Disable"))

    DisableClipping(true)
    RL.Draw.Circle(pos,h/2,h/2,32,RiceUI.GetColor(tbl,pnl,"Focus"))
    RL.Draw.Circle(pos,h/2,h/2-2,32,Color(250,250,250))

    if pnl:GetDragging() then
        draw.SimpleText(tostring(pnl:GetValue()),"OPPOSans_"..tostring(h),pos,-h/2,RiceUI.GetColorBase(tbl,pnl,"Text"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    DisableClipping(false)
end

function tbl.ScrollPanel_VBar(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Bar"))
    surface.DrawRect(0,0,w,h)
end

function tbl.ScrollPanel_VBar_Grip(pnl,w,h)
    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl))
    surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(RiceUI.GetColor(tbl,pnl,"Bar"))
    surface.DrawOutlinedRect(0,0,w,h,1)
end

return tbl