local tbl = {}

tbl.Color = {
    white = Color(250, 250, 250),
    white1 = Color(250, 250, 250),
    white2 = Color(245, 245, 245),
    white3 = Color(240, 240, 240),
    black = HSLToColor(0, 0, 0.2),
    black1 = HSLToColor(0, 0, 0.2),
    black2 = HSLToColor(0, 0, 0.18),
    black3 = HSLToColor(0, 0, 0.16),
}

tbl.TextColor = {
    white = Color(50, 50, 50),
    black = Color(250, 250, 250),
}

tbl.OutlineColor = {
    white = HSLToColor(0, 0, 0.8),
    white1 = HSLToColor(0, 0, 0.8),
    white2 = HSLToColor(0, 0, 0.75),
    white3 = HSLToColor(0, 0, 0.7),
    black = HSLToColor(0, 0, 0.3),
    black1 = HSLToColor(0, 0, 0.3),
    black2 = HSLToColor(0, 0, 0.3),
    black3 = HSLToColor(0, 0, 0.3),
}

tbl.BarColor = {
    white1 = Color(230, 230, 230),
    white2 = Color(220, 220, 220),
    white3 = Color(210, 210, 210),
    black = HSLToColor(0, 0, 0.15),
    black1 = HSLToColor(0, 0, 0.12),
    black2 = HSLToColor(0, 0, 0.9),
    black3 = HSLToColor(0, 0, 0.6),
}

tbl.HoverColor = {
    closeButton = Color(255, 0, 0),
    white = HSLToColor(0, 0, 0.93),
    white1 = HSLToColor(0, 0, 0.93),
    white2 = HSLToColor(0, 0, 0.91),
    white3 = HSLToColor(0, 0, 0.89),
    black = HSLToColor(0, 0, 0.35),
    black1 = HSLToColor(0, 0, 0.35),
    black2 = HSLToColor(0, 0, 0.40),
    black3 = HSLToColor(0, 0, 0.45),
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
    white = Color(200, 200, 200),
    white1 = Color(200, 200, 200),
    white2 = Color(200, 200, 200),
    white3 = Color(200, 200, 200),
    black = Color(70, 70, 70),
    black1 = Color(70, 70, 70),
    black2 = Color(70, 70, 70),
    black3 = Color(70, 70, 70),
}

/*

    Drawing functions

*/

function tbl.DrawOutline(pnl, w, h, Color)
    draw.RoundedBox(pnl.Theme.Curver or 5, 0, 0, w, h, Color or RiceUI.GetColor(tbl, pnl, "Outline"))
end

function tbl.DrawInnerBox(pnl, w, h, Color)
    draw.RoundedBox(pnl.Theme.Curver or 5, 1, 1, w - 2, h - 2, Color or RiceUI.GetColor(tbl, pnl))
end

function tbl.DrawOutlineBox(pnl, w, h, Color)
    tbl.DrawOutline(pnl, w, h, Color or RiceUI.GetColor(tbl, pnl, "Outline"))
    tbl.DrawInnerBox(pnl, w, h)
end

function tbl.DrawBox(pnl, w, h, Color)
    draw.RoundedBox(pnl.Theme.Curver or 5, 0, 0, w, h, Color or RiceUI.GetColor(tbl, pnl))
end

function tbl.DrawButton(pnl, w, h, Color)
    tbl.DrawOutlineBox(pnl, w, h)

    if pnl:IsHovered() then
        tbl.DrawBox(pnl, w, h, ColorAlpha(RiceUI.GetColor(tbl, pnl, "Hover"), 150))
    end
end

function tbl.DrawEntry(pnl, w, h, Color)
    local color = RiceUI.GetColor(tbl, pnl, "Outline")

    if pnl:HasFocus() then
        color = RiceUI.GetColor(tbl, pnl, "Focus")
    end

    tbl.DrawOutlineBox(pnl, w, h, color)
end

function tbl.DrawTextCursor(pnl,w,h)
    if pnl:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl, pnl, "Text"), 255 * math.abs(math.sin(SysTime() * 6 % 360))))

        local len = 0
        for i=1,pnl:GetCaretPos() do
            local w,_ = RL.VGUI.TextWide(pnl:GetFont(), utf8.sub(pnl:GetText(),i,i))

            len = len + w
        end
        surface.DrawRect(RL.hudScaleX(10) + len, 4, 1, h - 8)
    end
end

/*

    Elements

*/

function tbl.Panel(pnl, w, h)
    if pnl.DrawBorder or pnl:GetParent():GetClassName() ~= "CGModBase" then
        tbl.DrawOutlineBox(pnl, w, h)

        return
    end

    tbl.DrawBox(pnl, w, h)
end

function tbl.RL_Frame(pnl, w, h)
    if pnl.DrawBorder or pnl:GetParent():GetClassName() ~= "CGModBase" then
        DisableClipping(true)
        draw.RoundedBox(pnl.Theme.Curver or 5, -1, -1, w + 2, h + 2, RiceUI.GetColor(tbl, pnl, "Bar"))
        DisableClipping(false)
    end

    tbl.DrawBox(pnl, w, h, RiceUI.GetColor(tbl, pnl, "Bar"))
    draw.RoundedBox(pnl.Theme.Curver or 5, 0, pnl.Title:GetTall() + 10, w, h - pnl.Title:GetTall() - 10, RiceUI.GetColor(tbl, pnl))
end

function tbl.Button(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() then
        color = RiceUI.GetColor(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.Button_TextLeft(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() then
        color = RiceUI.GetColor(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), RL.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.TransButton(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")

    if not pnl.HoverAlpha then
        pnl.HoverAlpha = 0
    end

    if pnl:IsHovered() then
        pnl.HoverAlpha = math.min(pnl.HoverAlpha + (pnl.Theme.Speed or 20) * (RealFrameTime() * 100), 255)
    else
        pnl.HoverAlpha = math.max(pnl.HoverAlpha - (pnl.Theme.Speed or 20) * (RealFrameTime() * 100), 0)
    end

    tbl.DrawBox(pnl, w, h, ColorAlpha(color, pnl.HoverAlpha))
    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_TextLeft(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")

    if not pnl.HoverAlpha then
        pnl.HoverAlpha = 0
    end

    if pnl:IsHovered() then
        pnl.HoverAlpha = math.min(pnl.HoverAlpha + (pnl.Theme.Speed or 20) * (RealFrameTime() * 100), 255)
    else
        pnl.HoverAlpha = math.max(pnl.HoverAlpha - (pnl.Theme.Speed or 20) * (RealFrameTime() * 100), 0)
    end

    tbl.DrawBox(pnl, w, h, ColorAlpha(color, pnl.HoverAlpha))

    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() then
        color = RiceUI.GetColor(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), RL.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_F(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")

    if pnl:IsHovered() then
        pnl.HoverAlpha = 255
    else
        pnl.HoverAlpha = 0
    end

    tbl.DrawBox(pnl, w, h, ColorAlpha(color, pnl.HoverAlpha))
    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local cross = Material("rl_icons/xmark.png")

function tbl.CloseButton(pnl, w, h)
    local color = ColorAlpha(RiceUI.GetColorBase(tbl, pnl), 150)

    if pnl:IsHovered() then
        color = RiceUI.GetColorBase(tbl, pnl)
    end

    surface.SetDrawColor(color)
    surface.SetMaterial(cross)
    surface.DrawTexturedRect(0, 0, w, h)
end

local point = Material("gui/point.png")

function tbl.RL_Combo(pnl, w, h)
    tbl.DrawButton(pnl, w, h)

    if pnl.Value then
        draw.SimpleText(pnl.Value, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(pnl.Text, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, pnl.a_pointang)
end

function tbl.Choice(pnl, w, h)
    if pnl:IsHovered() then
        tbl.DrawBox(pnl, w, h, ColorAlpha(RiceUI.GetColor(tbl, pnl, "Hover"), 150))
    end

    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl.Selected then
        color = RiceUI.GetColor(tbl, pnl, "Focus")
    end

    draw.SimpleText(pnl.Text, pnl:GetFont(), h / 2, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.RL_NumberWang(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Outline")

    if pnl:HasFocus() then
        color = RiceUI.GetColor(tbl, pnl, "Focus")
    end

    tbl.DrawOutlineBox(pnl, w, h, color)
    draw.SimpleText(pnl:GetValue(), pnl:GetFont(), 10, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if pnl:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl, pnl, "Text"), 255 * math.sin(SysTime() * 8 % 360)))
        surface.DrawRect(10 + RL.VGUI.TextWide(pnl:GetFont(), pnl:GetText()), 4, 1, h - 8)
    end
end

function tbl.NumberWang_Button(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    local size = h / 2 + RL.hudScaleY(pnl.Theme.Scale or 0)
    surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, pnl.Theme.Ang)
end

function tbl.Entry(pnl, w, h)
    tbl.DrawEntry(pnl, w, h)

    if pnl:GetValue() == "" then
        draw.SimpleText(pnl:GetPlaceholderText(), pnl:GetFont(), 10, h / 2, pnl:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(pnl:GetText(), pnl:GetFont(), 10, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    tbl.DrawTextCursor(pnl,w,h)
end

local zoom = Material("icon16/zoom.png")

function tbl.Entry_Search(pnl, w, h)
    tbl.DrawEntry(pnl, w, h)

    if pnl:GetValue() == "" then
        draw.SimpleText(pnl:GetPlaceholderText(), pnl:GetFont(), 10, h / 2, pnl:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(zoom)
    surface.DrawTexturedRect(0, 0, w, h)
    draw.SimpleText(pnl:GetText(), pnl:GetFont(), 32, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    tbl.DrawTextCursor(pnl,w,h)
end

function tbl.Switch(pnl, w, h)
    RL.Draw.Circle(h / 2, h / 2, h / 2, 32, pnl:GetColor())
    RL.Draw.Circle(w - h / 2, h / 2, h / 2, 32, pnl:GetColor())
    surface.SetDrawColor(pnl:GetColor())
    surface.DrawRect(h / 2 / 2 + 4, 0, w - h / 2 - 8, h)
    RL.Draw.Circle(h / 2 + pnl.togglePos, h / 2, h / 2 - 2, 32, Color(250, 250, 250))
end

function tbl.Slider(pnl, w, h)
    local pos = w * pnl:GetSlideX()
    draw.RoundedBox(32, 0, h / 3, pos, h / 3, RiceUI.GetColor(tbl, pnl, "Focus"))
    draw.RoundedBox(32, pos, h / 3, w - pos, h / 3, RiceUI.GetColor(tbl, pnl, "Disable"))
    DisableClipping(true)
    RL.Draw.Circle(pos, h / 2, h / 2, 32, RiceUI.GetColor(tbl, pnl, "Focus"))
    RL.Draw.Circle(pos, h / 2, h / 2 - 2, 32, Color(250, 250, 250))

    if pnl:GetDragging() then
        draw.SimpleText(tostring(pnl:GetValue()), "OPPOSans_" .. tostring(h), pos, -h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    DisableClipping(false)
end

function tbl.ScrollPanel_VBar(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl, "Bar"))
    surface.DrawRect(0, 0, w, h)
end

function tbl.ScrollPanel_VBar_Grip(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl, "Bar"))
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

function tbl.CheckBox(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    draw.RoundedBox(pnl.Theme.Curver or 5, 4, 4, w - 8, h - 8, ColorAlpha(RiceUI.GetColor(tbl, pnl, "Focus"), pnl.a_Alpha))
end

function tbl.Form(pnl, w, h)
    tbl.DrawButton(pnl, w, h)

    if pnl.Value then
        draw.SimpleText(pnl.Value, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(pnl.Text, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local h = pnl.h
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, pnl.a_pointang)
end

function tbl.Spacer(pnl, w, h)
    local len = pnl.Theme.SpacerLen or 5

    surface.SetDrawColor(RiceUI.GetColorBase(tbl,pnl,"Text"))
    surface.DrawRect(len,h/2-RL.hudOffsetY(2),w-len*2,RL.hudOffsetY(2))
end

return tbl