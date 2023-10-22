local Element = {}

Element.Editor = {
    Category = "display"
}

function Element.Create(data, parent)
    RL.table.Inherit(data, {
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
    panel:SetPos(RL.hudScale(data.x, data.y))
    panel:SetSize(RL.hudScale(data.w, data.h))
    panel.NoGTheme = true

    if data.AutoSize then
        panel:SetTall(RL.VGUI.TextHeight(data.Font, data.Text))
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

        draw.DrawText(self.Text, self.Font, w / 2, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        --RiceUI.Render.DrawIndicator(w, h)
    end

    panel.ProcessID = "Label"
    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element