RiceUI.DefineMixin("RegisterPage", function(self, pageName, page)
    if not self.RiceUI_Pages then self.RiceUI_CurrentPage = pageName end

    self.RiceUI_Pages = self.RiceUI_Pages or {}
    self.RiceUI_Pages[pageName] = page
end)

local function closePage(self, pageName)
    if not self.RiceUI_Pages then return end

    local page = self.RiceUI_Pages[pageName]
    if IsValid(page) then page:SetVisible(false) end
end

local function openPage(self, pageName)
    if not self.RiceUI_Pages then return end

    local page = self.RiceUI_Pages[pageName]
    if IsValid(page) then page:SetVisible(true) end
end

RiceUI.DefineMixin("SwitchPage", function(self, pageName)
    closePage(self, self.RiceUI_CurrentPage)
    openPage(self, pageName)

    self.RiceUI_CurrentPage = pageName
end)

RiceUI.DefineMixin("GetPage", function(self, pageName)
    if not self.RiceUI_Pages then return end
    return self.RiceUI_Pages[pageName]
end)