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

function Element.Create(data, parent)
    RiceLib.table.Inherit(data, {
        x = 10,
        y = 10,
        w = 300,
        h = 500,
        Theme = {ThemeType = "NoDraw"},
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

                x = 0,
                y = 0,

                Theme = {ThemeType = "NoDraw"},

                PerformLayout = function(self)
                    local base = self:GetParent()

                    local height = 0
                    for _, child in ipairs(self:GetChildren()) do
                        local cheight = child:GetY() + child:GetTall()

                        if cheight > height then
                            height = cheight
                        end
                    end

                    self:SetSize(base:GetWide(), height)
                end
            }
        },

        ScrollAmount = 30,
        ScrollTime = 0.25,
        ScrollEase = 0.3,

        OnMouseWheeled = function(self, delta)
            self:AddScroll(-delta)
        end,

        OnCreated = function(self)
            self.Canvas = self:GetChild(0)
        end,

        GetScroll = function(self)
            return self.Scroll or 0
        end,

        SetScroll = function(self, amount)
            amount = math.Clamp(amount, 0, math.max(self.Canvas:GetTall() - self:GetTall(), 0))

            self.Scroll = amount
            self.Canvas:SetPos(0, -amount)
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

            return math.Clamp(self:GetScroll() + tScroll, 0, self.Canvas:GetTall()) ~= self:GetScroll()
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