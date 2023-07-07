RL.Draw = RL.Draw or {}

function RL.Draw.Circle(x, y, radius, seg, color)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)

		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts

	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	draw.NoTexture()

	if color ~= nil then
		surface.SetDrawColor(color:Unpack())
	end

	surface.DrawPoly(cir)
end

function RL.Draw.TexturedCircle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)

		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts

	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	surface.DrawPoly(cir)
end

function RL.Draw.RoundedBox(bordersize, x, y, w, h, Color, corner)
	local corner = corner or {true,true,true,true}
	local tl, tr, bl, br = unpack(corner)

	local Color = Color or color_white
	surface.SetDrawColor(Color)

	bordersize = bordersize or 8

	-- Do not waste performance if they don't want rounded corners
	if bordersize <= 0 then
		surface.DrawRect(x, y, w, h)

		return
	end

	bordersize = math.min(math.Round(bordersize), math.floor(w / 2), math.floor(h / 2))

	surface.DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface.DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
	surface.DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

	if tl then
		RL.Draw.Circle(x + bordersize, y + bordersize, bordersize, bordersize)
	else
		surface.DrawRect(x, y, bordersize, bordersize)
	end

	if tr then
		RL.Draw.Circle(x + w - bordersize, y + bordersize, bordersize, bordersize)
	else
		surface.DrawRect(x + w - bordersize, y, bordersize, bordersize)
	end

	if bl then
		RL.Draw.Circle(x + bordersize, y + h - bordersize, bordersize, bordersize)
	else
		surface.DrawRect(x, y + h - bordersize, bordersize, bordersize)
	end

	if br then
		RL.Draw.Circle(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
	else
		surface.DrawRect(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
	end
end