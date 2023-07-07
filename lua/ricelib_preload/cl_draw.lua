local mathRad = math.rad
local mathSin = math.sin
local mathCos = math.cos
local tableInsert = table.insert
local surfaceDrawRect = surface.DrawRect

local function drawCircle(x, y, radius, seg, color, doTexture)
	local cir = {}

	local function mkVertex(ang)
		return {
			x = x + mathSin(ang) * radius,
			y = y + mathCos(ang) * radius,
			u = mathSin(ang) / 2 + 0.5,
			v = mathCos(ang) / 2 + 0.5
		}
	end

	tableInsert(cir, {x = x, y = y, u = 0.5, v = 0.5})

	for i = 0, seg do
		tableInsert(cir, mkVertex(mathRad((i / seg) * -360)))
	end

	tableInsert(cir, mkVertex(mathRad(0)))

	if not doTexture then
		draw.NoTexture()
	end

	if color ~= nil then
		surface.SetDrawColor(color:Unpack())
	end

	surface.DrawPoly(cir)
end

local function drawTexturedCircle(x, y, radius, seg)
	drawCircle(x, y, radius, seg, nil, true)
end

local function drawRoundedBox(borderSize, x, y, w, h, color, corner)
	local corner = corner or {true,true,true,true}
	local topLeft, topRight, bottomLeft, bottomRight = unpack(corner)

	local color = color or color_white
	surface.SetDrawColor(color)

	borderSize = borderSize or 8

	if borderSize <= 0 then
		surfaceDrawRect(x, y, w, h)

		return
	end

	borderSize = math.min(math.Round(borderSize), math.floor(w / 2), math.floor(h / 2))

	surfaceDrawRect(x + borderSize, y, w - borderSize * 2, h)
	surfaceDrawRect(x, y + borderSize, borderSize, h - borderSize * 2)
	surfaceDrawRect(x + w - borderSize, y + borderSize, borderSize, h - borderSize * 2)

	local function doCorner(bDraw, circleX, circleY, rectX, rectY)
		if bDraw then
			drawCircle(circleX, circleY, borderSize, borderSize)
		else
			surfaceDrawRect(rectX, rectY, borderSize, borderSize)
		end
	end

	doCorner(topLeft, x + borderSize, y + borderSize, x, y)
	doCorner(topRight, x + w - borderSize, y + borderSize, x + w - borderSize, y)
	doCorner(bottomLeft, x + borderSize, y + h - borderSize, x, y + h - borderSize)
	doCorner(bottomRight, x + w - borderSize, y + h - borderSize, x + w - borderSize, y + h - borderSize)
end

RL.Draw = RL.Draw or {
	Circle = drawCircle,
	TexturedCircle = drawTexturedCircle,
	RoundedBox = drawRoundedBox
}