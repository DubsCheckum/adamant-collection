--require("core/debug")
require("core/StatShine/StatShine")
local path = require("core/path")
local options = require("core/options")
local arr = require("core/util/array")

local allMapNames = require("core/mapnames")

local config = {
    name = "Travel",
    author = "DubsCheckum",
    description = "Click 'Show Options' then input your destination.",
    destinationTextOption = true
}

local Travel = require("core/class")(require("core/script"))

function Travel:getDestination(currentMap) 
    local dest = self.textOptions.destination:get()
    self:assert(dest ~= "", "Destination not set. Click 'Show Options' and input your destination.")
    -- if the map doesn't exist, give a close suggestion
    self:assert(arr.contains(allMapNames, dest), 
                "Map '"..dest.."' does not exist, did you mean: "..options.nearest(dest, allMapNames))
    return dest
end

function Travel:shouldHeal()
    return _G.getPokemonHealthPercent(1) < 50
end

function Travel:pathAction()
    self:done("You have arrived at your destination.")
end

--script = Travel(config)
require("core/core")(Travel(config))