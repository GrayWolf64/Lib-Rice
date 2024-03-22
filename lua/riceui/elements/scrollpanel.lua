local Element = {}

Element.Editor = {
    Category = "base"
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        ThemeName = "modern_rect",
        Theme = {
            ThemeName = "modern",
            ThemeType = "ScrollPanel",
            Color = "white",
            TextColor = "white"
        },
    })

    local x, y = RiceLib.hudScale(data.x, data.y)
    local w, h = RiceLib.hudScale(data.w, data.h)
    local panel = RiceLib.VGUI.ScrollPanel(parent, x, y, w, h)
    panel.ProcessID = "ScrollPanel"
    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    function panel:RefreshVBar()
        local VBar = self:GetVBar()

        VBar.Theme = RiceLib.table.Inherit({
            ThemeType = "ScrollPanel_VBar"
        }, self.Theme)

        VBar.btnGrip.Theme = RiceLib.table.Inherit({
            ThemeType = "ScrollPanel_VBar_Grip"
        }, self.Theme)

        RiceUI.RefreshTheme(VBar)
        RiceUI.RefreshTheme(VBar.btnGrip)
    end

    function panel:ChildCreated()
        if self.UseNewTheme then
            local canvas = self:GetCanvas()
            local cTheme = table.Copy(self.Theme)
            cTheme.ThemeType = "NoDraw"
            canvas.Theme = cTheme

            RiceUI.ApplyTheme(canvas)
        end

        self:RefreshVBar()
    end

    return panel
end

return Element