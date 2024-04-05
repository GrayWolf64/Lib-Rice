local Element = {}

local classes = {
    Default = function(data, parent)
        local panel = vgui.Create("AvatarImage", parent)
        panel:SetPos(RiceLib.hudScale(data.x, data.y))
        panel:SetSize(RiceLib.hudScale(data.w, data.h))
        panel:SetPlayer(data.ply or data.Player, data.w)

        return panel
    end,

    Rounded = function(data, parent)
        local panel = RiceUI.SimpleCreate({type = "rl_panel",
            NoGTheme = true,
            Theme = {},

            w = data.w,
            h = data.h,

            Paint = function(self, w, h)
                RiceLib.Render.StartStencil()

                RiceLib.Draw.RoundedBox(8, 0, 0, w, h, color_white)

                render.SetStencilCompareFunction(STENCIL_EQUAL)
                render.SetStencilFailOperation(STENCIL_KEEP)

                self.Picture:SetSize(w, h)
                self.Picture:PaintManual()

                render.SetStencilEnable(false)
            end,
        }, parent, parent)

        function panel:OnRemove()
            self.Picture:Remove()
        end

        local picture = vgui.Create("AvatarImage", panel)
        picture:SetPaintedManually(true)
        picture:SetPlayer(data.ply or data.Player, data.w)

        panel.Picture = picture

        return panel
    end,
}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data,{
        x = 10,
        y = 10,
        w = 500,
        h = 300,
        ShadowAlpha = 0,
    })

    local panel = classes[data.Class or "Default"](data, parent)

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element