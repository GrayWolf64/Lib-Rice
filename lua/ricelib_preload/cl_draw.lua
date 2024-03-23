local rad          = math.rad
local sin          = math.sin
local cos          = math.cos
local draw_rect    = surface.DrawRect

local function mkvertex(ang)
	return {
		x = x + sin(ang) * r,
		y = y + cos(ang) * r,
		u = sin(ang) / 2 + 0.5,
		v = cos(ang) / 2 + 0.5
	}
end

local function draw_circle(x, y, r, seg, color, do_texture)
	local cir = {{x = x, y = y, u = 0.5, v = 0.5}}

	for i = 0, seg do
		cir[#cir + 1] = mkvertex(rad((i / seg) * -360))
	end

	cir[#cir + 1] = mkvertex(0)

	if not do_texture then draw.NoTexture() end
	if color then surface.SetDrawColor(color:Unpack()) end

	surface.DrawPoly(cir)
end

local function draw_textured_circle(x, y, r, seg)
	draw_circle(x, y, r, seg, nil, true)
end

local function do_corner(do_draw, x_circle, y_circle, x_rect, y_rect, size_border)
	if do_draw then
		draw_circle(x_circle, y_circle, size_border, size_border * 2)
	else
		draw_rect(x_rect, y_rect, size_border, size_border)
	end
end

local function draw_rounded_box(size_border, x, y, w, h, color, corner)
	local corner = corner or {true, true, true, true}
	local top_left, top_right, bottom_left, bottom_right = unpack(corner)
	local color = color or color_white

	size_border = size_border or 8

	surface.SetDrawColor(color)

	if size_border <= 0 then draw_rect(x, y, w, h) return end

	size_border = math.min(math.Round(size_border), math.floor(w / 2), math.floor(h / 2))

	draw_rect(x + size_border, y, w - size_border * 2, h)
	draw_rect(x, y + size_border, size_border, h - size_border * 2)
	draw_rect(x + w - size_border, y + size_border, size_border, h - size_border * 2)

	do_corner(top_left, x + size_border, y + size_border, x, y, size_border)
	do_corner(top_right, x + w - size_border, y + size_border, x + w - size_border, y, size_border)
	do_corner(bottom_left, x + size_border, y + h - size_border, x, y + h - size_border, size_border)
	do_corner(bottom_right, x + w - size_border, y + h - size_border, x + w - size_border, y + h - size_border, size_border)
end

local function drawRoundedBoxOutlined(size_border, x, y, w, h, color, corner, thickness)
	RiceLib.Render.StartStencil()

	draw_rounded_box(size_border, x + thickness, y + thickness, w - thickness * 2, h - thickness * 2, color_white, Corner)

	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)

	draw_rounded_box(size_border, x, y, w, h, color, Corner)

	render.SetStencilEnable(false)
end

RiceLib.Draw = {
	Circle = draw_circle,
	TexturedCircle = draw_textured_circle,
	RoundedBox = draw_rounded_box,
	RoundedBoxOutlined = drawRoundedBoxOutlined
}