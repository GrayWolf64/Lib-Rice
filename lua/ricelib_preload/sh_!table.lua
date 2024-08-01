local pairs = pairs

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

	for i = 1, n do
		table.RemoveByValue(t, value)
	end
end

RiceLib.table = {
	Inherit = inherit,
	InheritCopy = inherit_copy,
	GetByString = get_by_str,
	RemoveByValue = remove_by_val
}