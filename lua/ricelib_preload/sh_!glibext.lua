--- Rice's extension for game's various libs
local pairs         = pairs
local ipairs        = ipairs
local t_remove_by_v = table.RemoveByValue

local function inherit(t, base, override, blacklist)
	override  = override or {}
	blacklist = blacklist or {}

	for k, v in pairs(base) do
		if blacklist[k] then
			continue
		end

		if override[k] then
			t[k] = v
		end

		if t[k] == nil then t[k] = v end
	end

	return t
end

local function inherit_copy(t, base, override, blacklist)
	return inherit(table.Copy(t), table.Copy(base), override, blacklist)
end

local function get_by_str(str)
	local t = _G

	for _, v in ipairs(str:Split(".")) do
		t = t[v]
	end

	return t
end

local function remove_by_val(t, value)
	local n = 0

	for _, v in pairs(t) do
		if v == value then n = n + 1 end
	end

	for _ = 1, n do
		t_remove_by_v(t, value)
	end
end

RiceLib.table = {
	Inherit = inherit,
	InheritCopy = inherit_copy,
	GetByString = get_by_str,
	RemoveByValue = remove_by_val
}

local function CubicSmooth5(input, store)
    store = store or {}
    table.insert(store, input)
	local output

    if #store > 5 then
        output = (-3 * store[1]
			    + 12 * store[2]
				+ 17 * store[3]
				+ 12 * store[4]
				-  3 * store[5]) / 35

        table.remove(store, 1)
    else
        return store[#store]
    end

    return output
end

local function CubicSmooth7(input, store)
    store = store or {}
    table.insert(store, input)
	local output

    if #store > 7 then
        output = (-2 * store[1]
				 + 3 * store[2]
				 + 6 * store[3]
				 + 7 * store[4]
				 + 6 * store[5]
				 + 3 * store[6]
				 - 2 * store[7]) / 21

        table.remove(store, 1)
    else
        return store[#store]
    end

    return output
end

local function sin(speed)
    return math.abs(math.sin(SysTime() * (speed or 6) % 360))
end

local function cos(speed)
    return math.abs(math.cos(SysTime() * (speed or 6) % 360))
end

RiceLib.math = {
	CubicSmooth5 = CubicSmooth5,
	CubicSmooth7 = CubicSmooth7,
	Sin = sin,
	Cos = cos
}