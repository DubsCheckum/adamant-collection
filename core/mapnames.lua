-- Grab all the map names which reside in the keys of GlobalMap and SubstituteMaps tables,
-- to form a list of *all* map names to return.
--
-- This is for the destination suggestions.

local globalMap = require("core/Pathfinder/Maps/GlobalMap")()
local substituteMaps = require("core/Pathfinder/Maps/MapExceptions/SubstituteMaps")

local mapNames = {}
for k,v in pairs(substituteMaps) do
    mapNames[#mapNames+1] = k
end
for k,v in pairs(globalMap) do
    mapNames[#mapNames+1] = k
end

return mapNames