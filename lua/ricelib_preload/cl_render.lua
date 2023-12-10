RL.Render = RL.Render or {}

function RL.Render.Start3D2D(self, dist, scale, pos, u, f, r, func)
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

function RL.Render.StartHoloDisplay(self, dist, scale, pos, func)
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

function RL.Render.StartStencil()
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)
end