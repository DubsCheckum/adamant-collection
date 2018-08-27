--require("core/debug")
local json = require("core/StatShine/json")

--[[
    npc = {
        name,
        id,
        x, y,
        type,
        isBattler,
        los,
        pokemon = {
            name,
            id,
            type,
            health,
            form,
            level,
            ev,
            moves = [
                {
                    name,
                    damage,
                }
            ],
        },
    }
]]

-- some game state vars
local npcs -- npcs in the current map
local npcSwitched -- has npc switched pokemon?
local currentNpcPkmActive
local currentNpc -- npc that you're currently battling
local currentMap

function pathAction()
    local map = _G.getMapName()
    if currentMap == nil or currentMap ~= map then
        currentMap = map
        npcs = loadNpcsFromFile(getFileName(currentMap))
    end
end

function battleAction()
    if _G.isWildBattle() then return end
    if npcSwitched then
        getTrainerPokemonData()
    end
end

function battleMessage(message)
    if currentNpc == nil then
        if message:find("The Opposing Trainer is changing Pokemon.") then
            npcSwitched = true    
            currentNpcPkmActive = currentNpcPkmActive + 1
        end
        local npcName = message:match("The NPC (.+) saw us, interacting...")
        if npcName then
            currentNpc = tfirst(function(npc) return npc.name == npcName end)
            currentNpcPkmActive = 1
        end
    end
    if message:find("You have won the battle.") or message:find("You black out!") then
        npcSwitched = false
        currentNpc = nil
    end
    local moveName = message:match()
    if moveName then
        local moves = currentNpc.pokemon[currentNpcPkmActive].moves
        moves[#moves+1] = moveName
    end
end

function getTrainerPokemonData()
    local pkm = {
        name = _G.getOpponentName(),
        id = _G.getOpponentId(),
        type = _G.getOpponentType(),
        health = _G.getOpponentHealth(),
        form = _G.getOpponentForm(),
        level = _G.getOpponentLevel(),
        ev = _G.getOpponentEffortValue(),
    }
    currentNpc.pokemon[#currentNpc.pokemon+1] = pkm
end

function tfirst(t, predicate)
    for _,v in ipairs(t) do 
        if predicate(v) then
            return v
        end
    end
    return nil
end

function loadNpcsFromFile(file)
    log("loading npcs from file: "..file)
    local ret = ""
    for _,v in ipairs(_G.readLinesFromFile(file)) do 
        ret = ret..v
    end
    if ret == "" then -- did we find some an un-indexed map?
        local data = _G.getNpcData() -- ask proshine for the data
        -- if #data ~= 0 then
        --     saveNpcsToFile(getFileName(currentMap), data)
        -- end
        return data
    end
    return json.decode(ret)
end

function saveNpcsToFile(file, theNpcs)
    log("saving npcs to file: "..file)
    _G.logToFile(file, json.encode(theNpcs), true)
end

function getFileName(currMap)
    local mapName = currMap:gsub("[%-%.% ]+", "")
    return "StatShine/Npcs/"..mapName..".json"
end

--- Convert _G.getNpcData's object array format to a dict with npc name as the key.
--- The rest of the info remains the same.
-- local function getNpcs()
--     local ret = {}
--     for _,v in ipairs(_G.getNpcData()) do 
--         local name = v.name
--         v.name = nil -- we won't be needing this anymore, it'll be the key
--         if v.isBattler then
--             v.pokemon = {}
--         end
--         ret[name] = v
--     end
--     return ret
-- end



-- local function merge(t1, t2)
--     for key, value in pairs(t2) do
--         if not t1[key] then
--             log("found npc that wasn't here before: "..key.."="..json.encode(value))
--             t1[key] = value
--         elseif type(value) == "table" then
--             merge(t1[key], value)
--         end
--     end
-- end

pathAction()

_G.registerHook("onPathAction", pathAction)
_G.registerHook("onBattleAction", battleAction)
_G.registerHook("onBattleMessage", battleMessage)