local tbl = {}
tbl.Color = {
    white1 = Color(250,250,250),
    white2 = Color(240,240,240),
    white3 = Color(230,230,230),
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

function tbl.Panel(pnl,w,h)
    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,pnl.Theme.RawColor or tbl.Color[pnl.Theme.Color] or tbl.Color.white1)
end

function tbl.Button(pnl,w,h)
    draw.RoundedBox(pnl.Theme.Curver or 5,0,0,w,h,pnl.Theme.RawOutlineColor or tbl.OutlineColor[pnl.Theme.Color] or tbl.OutlineColor.white1)

    local color = pnl.Theme.RawColor or tbl.Color[pnl.Theme.Color] or tbl.Color.white1

    draw.RoundedBox(pnl.Theme.Curver or 5,2,2,w-4,h-4,color)

    draw.SimpleText(pnl:GetText(),pnl:GetFont(),w/2,h/2,pnl:GetColor(),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

return tbl