local function getRoot(vgui)
    local parent = vgui:GetParent()
    if not parent then return vgui end
    if parent:GetClassName() == "CGModBase" then return vgui end

    return getRoot(parent)
end

local BLUR_PASSES = 6
local matBlurScreen = Material"pp/blurscreen"

local function blurPanel(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetMaterial(matBlurScreen)
    surface.SetDrawColor(color_white:Unpack())

    for i = 1, BLUR_PASSES do
        matBlurScreen:SetFloat("$blur", (i / 3) * (amount or BLUR_PASSES))
        matBlurScreen:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end
end

local function blurBackground(self, amount)
    blurPanel(self, amount)

    DisableClipping(DisableClipping(true))
end

local function FadeIn(panel, time, func)
    func = func or function() end

    panel:AlphaTo(0, time / 2, 0, function()
        panel:Clear()
        panel:AlphaTo(255, time / 2, 0)
        func()
    end)
end

local function Notify(text, fontSize, x, y, lifeTime)
    local notify = vgui.Create("DNotify", Panel)
    notify:SetPos(x, y)
    notify:SetLife(lifeTime)
    notify:SetSize(ScrW(), ScrH())
    local panel = vgui.Create("DPanel", notify)

    panel.Paint = function(self) blurPanel(self) end

    local label = RL.VGUI.ModernLabel(text, panel, fontSize, 5, 0, color_white)
    label:SizeToContents()
    panel:SetSize(label:GetWide() + 10, label:GetTall())
    notify:AddItem(panel)

    return notify, label
end

local function DM(l, t, r, b)
    local left, up = RL_hudScale(l or 0, t or 0)
    local right, down = RL_hudScale(r or 0, b or 0)

    return left, up, right, down
end

local function TextWide(font, text)
    surface.SetFont(font)

    return select(1, surface.GetTextSize(text))
end

local function TextHeight(font, text)
    surface.SetFont(font)

    return select(2, surface.GetTextSize(text))
end

RL.VGUI.GetRoot        = getRoot
RL.VGUI.Icon           = function(name) return Material("rl_icons/" .. name .. ".png") end
RL.VGUI.IconRaw        = function(name) return "rl_icons/" .. name .. ".png" end
RL.VGUI.blurPanel      = blurPanel
RL.VGUI.blurBackground = blurBackground
RL.VGUI.FadeIn         = FadeIn
RL.VGUI.Notify         = Notify
RL.VGUI.DM             = DM
RL.VGUI.TextWide       = TextWide
RL.VGUI.TextHeight     = TextHeight