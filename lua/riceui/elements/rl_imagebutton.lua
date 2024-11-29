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

        Color = color_white,

        Stretch = RICELIB_IMAGE_STRETCH_UNIFORMFILL
    })

    local panel = RiceUI.SimpleCreate({type = "rl_button",
        Dock = data.Dock,
        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        Text = "",

        ThemeNT = {
            Class = "NoDraw",
            Style = "Custom",
            StyleSheet = {
                Draw = function(self, w, h)
                    if self.Image then
                        if not self.Material then
                            local material = Material(self.Image, "smooth")

                            if material and not material:IsError() then
                                self.Material = material
                            end
                        end

                        if self.Material and not self.Material:IsError() then
                            local x, y = self:LocalToScreen()
                            RiceLib.Draw.Image(0, 0, w, h, self.Material, self.Color, self.Stretch, _, false)

                            return
                        end
                    end

                    if self.URL then
                        -- todo
                    end

                    if not self.Material or self.Material:IsError() then
                        draw.RoundedBox(RICEUI_SIZE_6, 0, 0, w, h, color_white)
                        draw.SimpleText(self.Text, "RiceUI_M_24", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end
            }
        },

        SetImage = function(self, image)
            self.Material = nil
            self.Image = image
        end
    }, parent, root)

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element