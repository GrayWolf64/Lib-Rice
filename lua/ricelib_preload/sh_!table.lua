RiceLib.table = RiceLib.table or {}

function RiceLib.table.Inherit( t, base, override, blacklist )
	override = override or {}
	blacklist = blacklist or {}

	for k, v in pairs( base ) do
		if blacklist[k] then
			continue
		end

		if override[k] then
			t[ k ] = v
		end

		if ( t[ k ] == nil ) then t[ k ] = v end
	end

	return t

end

function RiceLib.table.InheritCopy( t, base, override, blacklist )
	local tbl = table.Copy(t)

	override = override or {}
	blacklist = blacklist or {}

	for k, v in pairs( base ) do
		if blacklist[k] then
			continue
		end

		if override[k] then
			tbl[ k ] = v
		end

		if ( tbl[ k ] == nil ) then tbl[ k ] = v end
	end

	return tbl

end

function RiceLib.table.GetByString(str)
	local tbl = _G
	for _,v in ipairs(string.Split(str,".")) do
		tbl = tbl[v]
	end

	return tbl
end