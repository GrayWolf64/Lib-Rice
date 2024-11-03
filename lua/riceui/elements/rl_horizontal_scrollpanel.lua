local Element = {}

Element.Editor = {
    Category = "base"
}

-- SmoothScroll From https://github.com/Minbird/Smooth_Scroll
local function sign(num)
    return num > 0
end

local function getBiggerPos(signOld, signNew, old, new)
    if signOld ~= signNew then return new end

    if signNew then
        return math.max(old, new)
    else
        return math.min(old, new)
    end
end

local tScroll = 0
local newerT = 0

local function recersiveGetWide(pnl, wide)
    for _, child in ipairs(pnl:GetChildren()) do
        local cwide = child:GetX() + child:GetWide()

        if cwide > wide then
            wide = cwide
        end

        if #child:GetChildren() > 0 then
            wide = recersiveGetWide(child, wide)
        end
    end

    return wide
end

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 300,
        h = 500,
        Theme = {ThemeType = "NoDraw"},
        ScrollSpeed = 1
    })

    local panel = RiceUI.SimpleCreate({type = "rl_panel",
        x = data.x,
        y = data.y,
        w = data.w,
        h = data.h,

        Theme = {ThemeType = "NoDraw"},

        children = {
            {type = "rl_panel",
                SubID = "Canvas",
                PreventClear = true,

                x = 0,
                y = 0,

                Theme = {ThemeType = "NoDraw"},

                PerformLayout = function(self)
                    local base = self:GetParent()

                    local wide = recersiveGetWide(self, 0)

                    self:SetSize(wide, base:GetTall())
                end,

                GetSize = function(self)
                    return self:GetParent():GetSize()
                end,

                LocalToScreen = function(self)
                    return self:GetParent():LocalToScreen()
                end,
            }
        },

        ScrollAmount = 30,
        ScrollTime = 0.25,
        ScrollEase = 0.3,
        HasCanvas = true,

        OnMouseWheeled = function(self, delta)
            if delta == 0 then return end

            self:AddScroll(-delta * self.ScrollSpeed)
        end,

        OnCreated = function(self)
            self.Canvas = self:GetChild(0)
        end,

        GetScroll = function(self)
            return self.Scroll or 0
        end,

        SetScroll = function(self, amount)
            amount = math.Clamp(amount, 0, math.max(self.Canvas:GetWide() - self:GetWide(), 0))

            self.Scroll = amount
            self.Canvas:SetPos(-amount, 0)
        end,

        AddItem = function(self, pnl)
            pnl:SetParent(self.Canvas)
        end,

        AddScroll = function(self, amount)
            self.Old_Pos = nil
            self.Old_Sign = nil
            local OldScroll = self:GetScroll()
            amount = amount * self.ScrollAmount
            local anim = self:NewAnimation(self.ScrollTime, 0, self.ScrollEase)
            anim.StartPos = OldScroll
            anim.TargetPos = OldScroll + amount + tScroll
            tScroll = tScroll + amount
            local ctime = RealTime()
            local doing_scroll = true
            newerT = ctime

            anim.Think = function(anim, pnl, fraction)
                local nowpos = Lerp(fraction, anim.StartPos, anim.TargetPos)

                if ctime == newerT then
                    self:SetScroll(getBiggerPos(self.Old_Sign, sign(amount), self.Old_Pos, nowpos))
                    tScroll = tScroll - (tScroll * fraction)
                end

                if doing_scroll then
                    self.Old_Sign = sign(amount)
                    self.Old_Pos = nowpos
                end

                if ctime ~= newerT then
                    doing_scroll = false
                end
            end

            return math.Clamp(self:GetScroll() + tScroll, 0, self.Canvas:GetWide()) ~= self:GetScroll()
        end,

        AddScrollRaw = function(self, amount)
            self.Old_Pos = nil
            self.Old_Sign = nil
            local OldScroll = self:GetScroll()
            local anim = self:NewAnimation(self.ScrollTime, 0, self.ScrollEase)
            anim.StartPos = OldScroll
            anim.TargetPos = OldScroll + amount + tScroll
            tScroll = tScroll + amount
            local ctime = RealFrameTime()
            local doing_scroll = true
            newerT = ctime

            anim.Think = function(anim, pnl, fraction)
                local nowpos = Lerp(fraction, anim.StartPos, anim.TargetPos)

                if ctime == newerT then
                    self:SetScroll(getBiggerPos(self.Old_Sign, sign(amount), self.Old_Pos, nowpos))
                    tScroll = tScroll - (tScroll * fraction)
                end

                if doing_scroll then
                    self.Old_Sign = sign(amount)
                    self.Old_Pos = nowpos
                end

                if ctime ~= newerT then
                    doing_scroll = false
                end
            end

            return math.Clamp(self:GetScroll() + tScroll, 0, self.Canvas:GetWide()) ~= self:GetScroll()
        end,

        Clear = function(self)
            for _, pnl in ipairs(self:GetChildren()) do
                if pnl.PreventClear then continue end

                pnl:Remove()
            end
        end,

        GetChildren = function(self)
            return self.Canvas:GetChildren()
        end
    }, parent, parent)

    function panel:OnChildAdded(child)
        if child.SubID == "Canvas" then return end

        child:SetParent(self.Canvas)
    end

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element