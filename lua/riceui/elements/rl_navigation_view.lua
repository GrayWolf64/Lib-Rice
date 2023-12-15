local Element = {}

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        Theme = {
            ThemeType = "NoDraw",
        },

        h = 600,
        NavigationBarSize = 250,

        Choice = {}
    })

    local panel = RiceUI.SimpleCreate({type = "rl_panel",
        Theme = Theme,

        h = data.h,

        OnCreated = function(self)
            local navPanel = self.Elements.NavigationPanel

            navPanel:SetWide(self:RiceUI_GetRoot():GetWide() - self.NavigationBarSize)
        end,

        ClearNavigationPanel = function(self)
            self.Elements.NavigationPanel:Clear()
        end,

        NavigationBarSize = data.NavigationBarSize,

        children = {
            {type = "scrollpanel", ID = "NavigationBar", Dock = LEFT, w = data.NavigationBarSize,
                ClearSelection = function(self)
                    for _,pnl in pairs(self.Elements) do
                        if pnl.ClearSelection == nil then continue end

                        pnl:ClearSelection()
                    end
                end
            },

            {type = "rl_panel", ID = "NavigationPanel", Dock = RIGHT,
                Theme = {ThemeType = "Layer"}
            }
        }
    }, parent)

    local function createCategoryButtons(data, parent, bar, panel)
        for _, choice in ipairs(data[3]) do
            RiceUI.SimpleCreate({type = "rl_button",
                ID = choice[1],
                Text = choice[1],

                Dock = TOP,
                h = 45,

                Theme = {
                    ThemeName = "modern",
                    ThemeType = "Navgation_Button_Transparent"
                },

                ClearSelection = function(self)
                    self.Selected = false
                end,

                DoClick = function(self)
                    parent:ClearSelection()
                    bar:ClearSelection()

                    self.Selected = true

                    choice[2](panel)
                end,
            }, parent)
        end
    end

    local choiceType = {
        Page = function(data, bar, panel)
            return RiceUI.SimpleCreate({type = "rl_button",
                ID = data[2],
                Text = data[2],

                Dock = TOP,
                Margin = {5, 0, 5, 0},
                h = 45,

                Theme = {
                    ThemeName = "modern",
                    ThemeType = "Navgation_Button"
                },

                ClearSelection = function(self)
                    self.Selected = false
                end,

                DoClick = function(self)
                    bar:ClearSelection()
                    self.Selected = true

                    data[3](panel)
                end,
            }, bar)
        end,

        Category = function(data, bar, panel)
            local form = RiceUI.SimpleCreate({type = "rl_form",
                ID = data[2],
                Text = data[2],

                Dock = TOP,
                Margin = {5, 0, 5, 5},
                h = 45,

                Theme = {
                    ThemeName = "modern",
                    ThemeType = "Navgation_Combo"
                },

                ClearSelection = function(self)
                    self.Selected = false

                    for _,pnl in ipairs(self:GetChildren()) do
                        if pnl.ClearSelection == nil then continue end

                        pnl:ClearSelection()
                    end
                end,

                DoClick = function(self)
                    bar:ClearSelection()
                    self:ClearSelection()

                    self.Selected = true

                    self:DoAnim()
                end,
            }, bar)

            createCategoryButtons(data, form, bar, panel)

            return form
        end,
    }

    function panel:CreateNavigation()
        for _, data in ipairs(data.Choice) do
            local pnl = choiceType[data[1]](data, self.Elements.NavigationBar, self.Elements.NavigationPanel)

            RiceUI.ApplyTheme(pnl, self.Theme)
        end
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))
    panel:CreateNavigation()

    return panel
end

return Element