local function vertical(self, offset)
    if not self:GetChildren()[1] then
        self:SetTall(0)

        return
    end

    self:GetChildren()[1]:InvalidateParent(true)
    self:SetTall(select(2, self:ChildrenSize()) + (offset or 0))
end

local function horizontal(self, offset)
    if not self:GetChildren()[1] then
        self:SetWide(0)

        return
    end

    self:GetChildren()[1]:InvalidateParent(true)
    self:SetWide(select(1, self:ChildrenSize()) + (offset or 0))
end

RiceUI.DefineMixin("FitContents_Vertical", vertical)
RiceUI.DefineMixin("FitContents_Horizontal", horizontal)
RiceUI.DefineMixin("FitContents", function(self, offsetW, offsetH)
    vertical(self, offsetW)
    horizontal(self, offsetH)
end)