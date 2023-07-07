// 一键创建 10 - 100 大小的字体
function RL.VGUI.RegisterFont(FontName, CodeName, addData)
    for i=1,10 do
        local data = {
            font = FontName,
            size = i*10*(ScrW()/1920),
            weight = 500,
            antialias = true,
            additive = false,
            outline = false,
            extended = true
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*10,data)
    end

    RL.MessageAs("RegisterFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end

function RL.VGUI.RegisterFontFixed(FontName, CodeName, addData)
    for i=1,10 do
        local data = {
            font = FontName,
            size = i*10,
            weight = 500,
            antialias = true,
            additive = false,
            outline = false,
            extended = true
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*10,data)
    end

    RL.MessageAs("Register FixedFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end

function RL.VGUI.RegisterFontAdv(FontName, CodeName, addData)
    for i=1,60 do
        local data = {
            font = FontName,
            size = i*5*(ScrW()/1920),
            weight = 500,
            antialias = true,
            additive = false,
            outline = false,
            extended = true
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*5,data)
    end

    RL.MessageAs("<ADV> RegisterFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end

function RL.VGUI.RegisterFontFixedAdv(FontName, CodeName, addData)
    for i=1,60 do
        local data = {
            font = FontName,
            size = i*5,
            weight = 500,
            antialias = true,
            additive = false,
            outline = false,
            extended = true
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*5,data)
    end

    RL.MessageAs("<ADV> Register FixedFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end

function RL.VGUI.RegisterFont_New(data)
    local CodeName, FontName = data.CodeName, data.FontName or "OPlusSans 3.0"

    for i=1, 100 do
        local base = {
            font = FontName,
            size = i * 2 * (ScrW()/1920),
            weight = 500,
            antialias = true,
            additive = false,
            outline = false,
            extended = true
        }

        local FontData = RL.table.Inherit(base,data)

        if data.Debug then print(i * 2 * (ScrW()/1920), FontData.size) end

        surface.CreateFont(CodeName .. "_" .. i * 2, FontData )
    end

    if not data.ShowMessage then return end

    RL.MessageAs("<ADV> RegisterFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end

concommand.Add("RiceLib_VGUI_FontView",function(ply,cmd,args)
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(1800,900))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib VGUI Font Viewer "..args[1])
    frame:SetTheme("ModernDark")

    local panel,bar,barGrip = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("ModernDark")

    RL.VGUI.RegisterFontAdv(args[1],"FontView"..args[1])

    for i = 1,20 do
        local button = vgui.Create("DLabel",panel)
        button:Dock(TOP)
        button:DockMargin(0,RL.hudScaleY(5),0,0)
        button:SetText(" "..tostring(i*5).." Innovation in China 中国智造，慧及全球 0123456789")
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i*5+10))
        button:SetFont("FontView"..args[1].."_"..i*5)

        panel:AddItem(button)
    end
end)

concommand.Add("RiceLib_VGUI_FontView_Raw",function(ply,cmd,args)
    local frame = vgui.Create("DFrame")
    frame:SetSize(RL.hudScale(1800,900))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("RiceLib VGUI Font Viewer "..args[1])
    frame:SetTheme("ModernDark")

    local panel,bar,barGrip = RL.VGUI.ScrollPanel(frame)
    panel:Dock(FILL)
    panel:SetTheme("ModernDark")

    for i = 1,20 do
        local button = vgui.Create("DLabel",panel)
        button:Dock(TOP)
        button:DockMargin(0,RL.hudScaleY(5),0,0)
        button:SetText(" "..tostring(i*5).." Innovation in China 中国智造，慧及全球 0123456789")
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i*5+10))
        button:SetFont(args[1].."_"..i*5)

        panel:AddItem(button)
    end
end)

concommand.Add("RiceLib_VGUI_FontView_New",function(ply,cmd,args)
    local frame = RiceUI.SimpleCreate({type = "rl_frame",
        Center = true,
        Root = true,

        w = 1800,
        h = 900,
    })

    for i = 1,20 do
        local button = vgui.Create("DLabel",panel)
        button:Dock(TOP)
        button:DockMargin(0,RL.hudScaleY(5),0,0)
        button:SetText(" "..tostring(i*5).." Innovation in China 中国智造，慧及全球 0123456789")
        button:SetTheme("ModernDark")
        button:SetTall(RL.hudScaleY(i*5+10))
        button:SetFont(args[1].."_"..i*5)

        panel:AddItem(button)
    end
end)