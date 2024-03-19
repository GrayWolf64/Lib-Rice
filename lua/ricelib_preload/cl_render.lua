RiceLib.Render = RiceLib.Render or {}

local function start3D2D(self, dist, scale, pos, u, f, r, func)
    local dist = dist or 500
    local pos = pos or Vector(0, 0, 0)
    if LocalPlayer():EyePos():DistToSqr(self:GetPos()) >= dist * dist then return end
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), u or 0)
    ang:RotateAroundAxis(ang:Forward(), f or 0)
    ang:RotateAroundAxis(ang:Right(), r or 0)
    cam.Start3D2D(self:LocalToWorld(pos), ang, scale or 0.1)
    func()
    cam.End3D2D()
end

local function startHoloDisplay(self, dist, scale, pos, func)
    local dist = dist or 500
    local pos = pos or Vector(0, 0, 0)
    if LocalPlayer():EyePos():DistToSqr(self:GetPos()) >= dist * dist then return end
    local ang = EyeAngles()
    ang = Angle(0, ang.y, 0)
    ang:RotateAroundAxis(ang:Up(), -90)
    ang:RotateAroundAxis(ang:Forward(), 90)
    cam.Start3D2D(self:LocalToWorld(pos), ang, scale or 0.1)
    func()
    cam.End3D2D()
end

local function startStencil()
    render.ClearStencil()

    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)

    render.SetStencilEnable(true)
end

local blur_passes = 6
local blur_mat = Material"pp/blurscreen"

local function blur(x, y, w, h, amount)
    surface.SetMaterial(blur_mat)
    surface.SetDrawColor(color_white:Unpack())

    render.SetScissorRect(x, y, x + w, y + h, true)

    for i = 1, blur_passes do
        blur_mat:SetFloat("$blur", (i / 3) * (amount or blur_passes))
        blur_mat:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end

    render.SetScissorRect(0, 0, 0, 0 , false)
end

RiceLib.Render = {
    StartStencil = startStencil,
    Start3D2D = start3D2D,
    StartHoloDisplay = startHoloDisplay,
    Blur = blur,
}