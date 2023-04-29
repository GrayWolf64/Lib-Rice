RL.table = RL.table or {}

function RL.table.Inherit( t, base )

	for k, v in pairs( base ) do
		if ( t[ k ] == nil ) then t[ k ] = v end
	end

	return t

end