local ratio_w = ScrW() / 1920
local ratio_h = ScrH() / 1080
local scaleFactor = ratio_h

local function scale_pos(x, y)
    return x * ratio_w, y * ratio_h
end

local function scale_pos_single(xory, ratio)
    return xory * ratio
end

local function scale_pos_x(x, profile)
    return scale_pos_single(x, ratio_w)
end

local function scale_pos_y(y, profile)
    return scale_pos_single(y, ratio_h)
end

local function size(w, h)
    if not h then return w * scaleFactor end

    return w * scaleFactor, h * scaleFactor
end


RiceLib.UI.Scale = scale_pos
RiceLib.UI.ScaleX = scale_pos_x
RiceLib.UI.ScaleY = scale_pos_y

RiceUI.Scale = {
    Pos = scale_pos,
    PosX = scale_pos_x,
    PosY = scale_pos_y,

    Size = size
}