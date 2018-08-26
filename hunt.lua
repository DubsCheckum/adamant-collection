local options = require("core/options")
local arr = require("core/util/array")

local allMapNames = require("core/mapnames")

local config = {
    name = "Hunt",
    author = "DubsCheckum",
    description = "An example description.",
    destinationTextOption = true,
    huntTypeTextOption = true
}

local Hunt = require("core/class")(require("core/script"))

function Hunt:getDestination(currentMap) 
    local dest = self.textOptions.destination:get()
    self:assert(dest ~= "", "Destination not set. Click 'Show Options' and input your destination.")
    -- if the map doesn't exist, give a close suggestion
    self:assert(arr.contains(allMapNames, dest), 
                "Map '"..dest.."' does not exist, did you mean: "..options.nearest(dest, allMapNames))
    return dest
end

function Hunt:pathAction()
    self:hunt(self.textOptions.huntType:getAndParse())
end

require("core/core")(Hunt(config))