RL.Render = RL.Render or {}

function RL.Render.Start3D2D(self,dis,scale,Pos,u,f,r,func)
    local dis = dis or 500
    local Pos = Pos or Vector(0,0,0)

    if LocalPlayer():EyePos():DistToSqr(self:GetPos()) >= dis * dis then return end

    local Ang = self:GetAngles()
    Ang:RotateAroundAxis(Ang:Up(),u or 0)
    Ang:RotateAroundAxis(Ang:Forward(),f or 0)
    Ang:RotateAroundAxis(Ang:Right(),r or 0)

    cam.Start3D2D( self:LocalToWorld(Pos), Ang, scale or 0.1 )
        func()
    cam.End3D2D()
end

function RL.Render.StartHoloDisplay(self,dis,scale,Pos,func)
    local dis = dis or 500
    local Pos = Pos or Vector(0,0,0)

    if LocalPlayer():EyePos():DistToSqr(self:GetPos()) >= dis * dis then return end

    local angle = EyeAngles()
    angle = Angle(0, angle.y, 0)
    angle:RotateAroundAxis(angle:Up(), -90)
    angle:RotateAroundAxis(angle:Forward(), 90)

    cam.Start3D2D(self:LocalToWorld(Pos), angle, scale or 0.1)
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