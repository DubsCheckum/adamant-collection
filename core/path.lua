local path = require("core/Pathfinder/MoveToApp")

--[[ 
	Pathfinder functions inherited:
		cellIsAccessible
		cellIsShoreline
		disableDigPath
		enableDigPath
		getMapSpawn
		getPath
		getPathInMap
		getPokemonEV
		isDigPathEnabled
		mapName
		moveTo
		moveToMapCell
		moveToPC
		moveToShoreline
		useNearestPokecenter
		useNearestPokemart
]]

local lineSwitch = false
function path.moveToLine(x1, y1, x2, y2)
    -- Alternates between 2 positions
	if lineSwitch then
		if _G.getPlayerX() == coords[1] and _G.getPlayerY() == coords[2] then
			lineSwitch = not lineSwitch
		end
		return _G.moveToCell(coords[1], coords[2])
	else
		if _G.getPlayerX() == coords[3] and _G.getPlayerY() == coords[4] then
			lineSwitch = not lineSwitch
		end
		return _G.moveToCell(coords[3], coords[4])
	end
end

return path