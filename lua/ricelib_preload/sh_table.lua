RL.table = RL.table or {}

function RL.table.Inherit( t, base, override )
	override = override or {}

	for k, v in pairs( base ) do
		if override[k] then
			t[ k ] = v
		end

		if ( t[ k ] == nil ) then t[ k ] = v end
	end

	return t

end

function RL.table.GetByString(str)
	local tbl = _G
	for _,v in ipairs(string.Split(str,".")) do
		tbl = tbl[v]
	end

	return tbl
end