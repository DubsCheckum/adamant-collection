return function (script)

require("core/StatShine/StatShine")
local path = require("core/path")

_G.name = script.name
_G.author = script.author
_G.description = script.description

function _G.onPathAction()
    for _,v in ipairs(script.timeouts) do
        v:update()
    end

    local map = path.mapName()
    local destination = script:getDestination(map)

    if script:shouldHeal() then
        script:heal()
    elseif map == destination then    
        script:pathAction()
    else
        path.moveTo(destination)
    end
end

function _G.onBattleAction()
    if _G.isWildBattle() then
        script:onWildBattle()
    else
        script:onTrainerBattle()
    end
end

function _G.onBattleMessage(message)
    
end

function _G.onStart()
    -- if script.mount then
    --     _G.setMount(script.mount)
    -- end
    -- if script.waterMount then
    --     _G.setWaterMount(script.waterMount)
    -- end
end

function _G.onStop()
    
end

function _G.onPause()
    
end

function _G.onLearningMove(moveName, pokemonIndex)
    _G.forgetAnyMoveExcept({"Cut", "Surf", "Flash", "Dig"})
end

function _G.onDialogMessage(message)
    
end

function _G.onSystemMessage(message)
    
end

--script:initialize()

-- local core = {}

-- function core.huntGrass()
--     return moveToGrass()
-- end

-- function core.huntGround()
--     return moveToNormalGround()
-- end

-- function core.huntWater()
--     return moveToWater()
-- end

-- function core.huntRect(x1, y1, x2, y2)
--     if type(x1) == "table" then
--         return moveToRectangle(x1)
--     end
--     return moveToRectangle(x1, y1, x2, y2)
-- end

-- function core.huntLine(x1, y1, x2, y2)
-- end

-- return core
end