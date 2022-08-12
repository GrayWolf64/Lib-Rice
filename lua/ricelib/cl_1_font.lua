// 一键创建 10 - 100 大小的字体
function RL.VGUI.RegisterFont(FontName, CodeName, addData)
    for i=1,10 do
        local data = {
            font = FontName,
            size = i*10*(ScrH()/1080),
            weight = 500,
            antialias = true,
            additive = false,
            outline = false
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
            outline = false
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*10,data)
    end

    RL.MessageAs("Register FixedFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end

function RL.VGUI.RegisterFontAdv(FontName, CodeName, addData)
    for i=1,20 do
        local data = {
            font = FontName,
            size = i*5*(ScrH()/1080),
            weight = 500,
            antialias = true,
            additive = false,
            outline = false
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*5,data)
    end

    RL.MessageAs("<ADV> RegisterFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end

function RL.VGUI.RegisterFontFixedAdv(FontName, CodeName, addData)
    for i=1,20 do
        local data = {
            font = FontName,
            size = i*5,
            weight = 500,
            antialias = true,
            additive = false,
            outline = false
        }

        table.Merge(data, (addData or {}))

        surface.CreateFont(CodeName.."_"..i*5,data)
    end

    RL.MessageAs("<ADV> Register FixedFont: "..CodeName.." ("..FontName..")","Ricelib Font")
end