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
	local instances = {}

	for index, val in ipairs(t) do
		if val == value then table.insert(instances, index) end
	end

	if not table.IsEmpty(instances) then table.remove(t, instances[1]) end

	if #instances > 1 then
		remove_by_val(t, value)
	end
end

RiceLib.table = {
	Inherit = inherit,
	InheritCopy = inherit_copy,
	GetByString = get_by_str,
	RemoveByValue = remove_by_val
}