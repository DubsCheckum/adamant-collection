local name = "Exp"
local author = "DubsCheckum"
local desc = [[Some descriptingon that i need to write...
...]]

local path = require("core/path")
local battle = require("core/battle")
local Script = require("core/script")
local exp = Script(name, author, desc)
_G.theScript = exp -- core.lua uses this variable to access the script instance

dofile("core/core.lua")

local pokecenter = ""
local destination = ""

function exp:isHealed()
end

function exp:heal()
end

function exp:getDestination()
end

function exp:pathAction()

end

function onPathAction()
    if isHealed() then
        if getMapName() == destination then
            hunt()
        else
            path.moveTo(destination)
        end
    else
        heal()
    end
end

function onBattleAction()

end