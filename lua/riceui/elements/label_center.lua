local Element = {}

Element.Editor = {
    Category = "display"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 100,
        h = 30,
        Font = "OPPOSans_30",
        Color = Color(30, 30, 30),
        Text = "HelloWorld!, 你好中国",
        Wrap = false,
        AutoSize = true,
    })

    local panel = vgui.Create("DPanel", parent)
    panel:SetPos(RiceLib.hudScale(data.x, data.y))
    panel:SetSize(RiceLib.hudScale(data.w, data.h))
    panel.ProcessID = "Label"

    if data.AutoSize then
        panel:SetTall(RiceLib.VGUI.TextHeight(data.Font, data.Text))
    end

    function panel:SetText(text)
        self.Text = text
    end

    function panel:SetFont(font)
        self.Font = font
    end

    function panel:SetColor(color)
        self.Color = color
    end

    function panel:Paint(w, h)
        local color = self.Color
        if self.Colors then
            color = self:RiceUI_GetColor("Text", "Primary")
        end

        draw.DrawText(self.Text, RiceUI.Font.Get(self.Font), w / 2, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        --RiceUI.Render.DrawIndicator(w, h)
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element