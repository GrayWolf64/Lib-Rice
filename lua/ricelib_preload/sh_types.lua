RL = RL or {}

RiceLib.Vector = {}

function RiceLib.Vector.RoundVector(vec, dec)
    dec = dec or 2
    local x, y, z = vec:Unpack()

    return Vector(math.Round(x, dec), math.Round(y, dec), math.Round(z, dec))
end