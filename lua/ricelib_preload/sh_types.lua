RL = RL or {}

RL.Vector = {}

function RL.Vector.RoundVector(vec, dec)
    dec = dec or 2
    local x, y, z = vec:Unpack()

    return Vector(math.Round(x, dec), math.Round(y, dec), math.Round(z, dec))
end

function RL.Vector.ConvertString(str)
    local x,y,z = unpack(string.Split(str," "))

    return Vector(tonumber(x),tonumber(y),tonumber(z))
end