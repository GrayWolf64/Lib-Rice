local tbl = {}
tbl.Color = {
    white = Color(250,250,250),
    white1 = Color(250,250,250),
    white2 = Color(240,240,240),
    white3 = Color(230,230,230),
    black = Color(70,70,70),
    black1 = Color(70,70,70),
    black2 = Color(50,50,50),
    black3 = Color(30,30,30),
}
tbl.OutlineColor = {
    white1 = Color(230,230,230),
    white2 = Color(220,220,220),
    white3 = Color(210,210,210),
    black1 = Color(50,50,50),
    black2 = Color(30,30,30),
    black3 = Color(10,10,10),
}

tbl.BarColor = {
    white1 = Color(230,230,230),
    white2 = Color(220,220,220),
    white3 = Color(210,210,210),
    black1 = Color(90,90,90),
    black2 = Color(70,70,70),
    black3 = Color(50,50,50),
}

tbl.HoverColor = {
    closeButton = Color(255,0,0),
    white1 = Color(230,230,230),
    white2 = Color(220,220,220),
    white3 = Color(210,210,210),
    black1 = Color(50,50,50),
    black2 = Color(30,30,30),
    black3 = Color(10,10,10),
}

tbl.FocusColor = {
    white1 = Color(0,150,255),
    white2 = Color(0,150,255),
    white3 = Color(0,150,255),
    black1 = Color(0,150,255),
    black2 = Color(0,150,255),
    black3 = Color(0,150,255),
}

function tbl.Panel(pnl,w,h)
    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,pnl.Theme.RawColor or tbl.Color[pnl.Theme.Color] or tbl.Color.white1)
    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,pnl.Theme.RawColor or tbl.Color[pnl.Theme.Color] or tbl.Color.white1)
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

    --draw.SimpleText(pnl:GetText(),pnl:GetFont(),w/2,h/2,pnl:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
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

    --draw.SimpleText(pnl:GetText(),pnl:GetFont(),w/2,h/2,pnl:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function tbl.TransButton_F(pnl,w,h)
    local color = RiceUI.GetColor(tbl,pnl,"Hover","closeButton")

    if pnl:IsHovered() then
        pnl.HoverAlpha = 255
    else
        pnl.HoverAlpha = 0
    end

    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,ColorAlpha(color,pnl.HoverAlpha))

    --draw.SimpleText(pnl:GetText(),pnl:GetFont(),w/2,h/2,pnl:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
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

    draw.SimpleText(pnl:GetText(),pnl:GetFont(),10,h/2,pnl:GetTextColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

    if pnl:HasFocus() then
        surface.SetDrawColor(50,50,50,255*math.sin(SysTime()*8%360))
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

return tbl