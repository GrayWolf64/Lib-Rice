RL.table = RL.table or {}

function RL.table.Inherit( t, base )

	for k, v in pairs( base ) do
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