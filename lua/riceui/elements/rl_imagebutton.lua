local Element = {}

Element.Editor = {
    Category = "interact"
}

function Element.Create(data, parent, root)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 500,
        h = 300,

        Text = ""
    })

    local panel = RiceUI.SimpleCreate({type = "rl_button",
        Dock = data.Dock,
        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        ThemeNT = {
            Class = "NoDraw",
            Style = "Custom",
            StyleSheet = {
                Draw = function(self, w, h)
                    surface.SetDrawColor(255, 255, 255)

                    if self.Image then
                        if not self.Material then
                            local material = Material(self.Image)

                            if not material:IsError() then
                                self.Material = material
                            end
                        end

                        if not self.Material:IsError() then
                            surface.SetMaterial(self.Material)
                            surface.DrawTexturedRect(0, 0, w, h)

                            return
                        end
                    end

                    if self.URL then
                        -- todo
                    end

                    draw.RoundedBox(RICEUI_SIZE_6, 0, 0, w, h, color_white)
                    draw.SimpleText(self.Text, "RiceUI_M_24", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            }
        }
    }, parent, root)

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element