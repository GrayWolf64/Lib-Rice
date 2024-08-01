local ratio_w = ScrW() / 1920
local ratio_h = ScrH() / 1080
local scaleFactor = ratio_h

local function scale_pos(x, y)
    return x * ratio_w, y * ratio_h
end

local function scale_pos_single(xory, ratio)
    return xory * ratio
end

local function scale_pos_x(x)
    return scale_pos_single(x, ratio_w)
end

local function scale_pos_y(y)
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

RICEUI_SIZE_2 = size(2)
RICEUI_SIZE_4 = size(4)
RICEUI_SIZE_6 = size(6)
RICEUI_SIZE_8 = size(8)
RICEUI_SIZE_16 = size(16)
RICEUI_SIZE_32 = size(32)
RICEUI_SIZE_64 = size(64)
RICEUI_SIZE_128 = size(128)
RICEUI_SIZE_512 = size(512)