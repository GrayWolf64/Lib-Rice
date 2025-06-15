RiceUI.DefineMixin("RegisterPage", function(self, pageName, page, noSetVisible)
    if not self.RiceUI_Pages then self.RiceUI_CurrentPage = pageName end

    self.RiceUI_Pages = self.RiceUI_Pages or {}
    self.RiceUI_Pages[pageName] = page

    if not noSetVisible then
        page:SetVisible(false)
    end
end)

local defaultTransition = {Type = "Default"}

local transitionAnimations = {
    Default = function(prevPage, newPage)
        prevPage:SetVisible(false)
        newPage:SetVisible(true)
    end,

    Fade = function(prevPage, newPage, transitionInfo)
        local time = transitionInfo.Time or RiceUI.Animation.GetTime("Fast")

        newPage:SetVisible(true)
        newPage:RiceUI_AlphaTo{
            Alpha = 255,
            Time = time
        }

        prevPage:RiceUI_AlphaTo{
            Alpha = 0,
            Time = time,

            Callback = function()
                if not IsValid(prevPage) then return end

                prevPage:SetVisible(false)
            end
        }
    end,
}

RiceUI.DefineMixin("SwitchPage", function(self, pageName, transitionInfo)
    local prevPage = self.RiceUI_Pages[self.RiceUI_CurrentPage]
    local newPage = self.RiceUI_Pages[pageName]

    transitionInfo = transitionInfo or defaultTransition
    local transitionFunction = transitionAnimations[transitionInfo.Type]

    transitionFunction(prevPage, newPage, transitionInfo)

    self.RiceUI_CurrentPage = pageName
end)

RiceUI.DefineMixin("GetPage", function(self, pageName)
    if not self.RiceUI_Pages then return end
    return self.RiceUI_Pages[pageName]
end)