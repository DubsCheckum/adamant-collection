--require("core/debug")
local json = require("core/StatShine/json")

local npcs
local npcSwitched
local currentNpc
local currentMap

local function pathAction()
    if _G.isWildBattle() then return end
    local map = _G.getMapName()
    if not currentMap or currentMap ~= map then
        currentMap = map
        npcs = getNpcs()
    end
end

local function battleAction()
    
end

local function battleMessage(message)
    if message:find("(The Opposing Trainer is changing Pokemon.|The NPC "..npc.name.." saw us, interacting...)") then
        npcSwitched = true
    end
    if message:find("(You have won the battle.|You black out!)") then
        npcSwitched = false
        currentNpc = nil
    end
end

local function getNpcs()
    local ret = {}
    for _,v in ipairs(_G.getNpcData()) do 
        local name = v.name
        v.name = nil
        v.pokemon = {}
        ret[name] = v
    end
    return ret
end

local function foreachNpc(f)

end

_G.registerHook("onPathAction", pathAction)
_G.registerHook("onBattleAction", battleAction)
_G.registerHook("onBattleMessage", battleMessage)