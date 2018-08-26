local path = require("core/path")
local options = require("core/options")

--- Abstract base class for all Adamant Collection scripts.
--
-- The following functions must be defined in deriving class:
-- * getDestination() -> string
-- * pathAction()     -> void
-- * isHealed()       -> bool
-- All other functions will be taken from this class if not
-- overridden.
--
-- @param config Configuration table.
-- @return a class object
Script = require("core/class")(function(s, config)
    s.name = "ADMT."..config.name
    s.author = config.author
    s.description = config.description
    s.balls = config.balls or {"Pokeball", "Great Ball", "Ultra Ball"}

    s.mount = config.mount
    s.waterMount = config.waterMount

    s.options = {}
    s.textOptions = {}
    s.timeouts = {}
    -- s.textOptions = {
    --     mount = options.TextOption("Mount", "The land mount to use. Leave empty for default."),
    --     waterMount = options.TextOption("Water Mount", "The water mount to use. Leave empty for default.")
    -- }

    if config.destinationTextOption then
        s.textOptions.destination = options.TextOption("Destination", 
            "The location to travel to.")
    end
    if config.huntTypeTextOption then
        s.textOptions.huntType = options.TextOption("Hunt Type", 
            "The method of hunting.\n".. 
            "g\t\t= moveToGrass\n"..
            "w\t\t= moveToWater\n"..
            "ng\t\t= moveToNormalGround\n"..
            "ne\t\t= moveNearExit\n"..
            "x,y\t\t= moveToCell\n"..
            "x1,y1,x2,y2\t= moveToRectangle/moveToLine")
    end
end)

function Script:getDestination(currentMap) _G.fatal("getDestination undefined") end
function Script:pathAction() _G.fatal("pathAction undefined") end

--- Base wild battle scenario.
function Script:onWildBattle() 
    if self:shouldCatch() then
        self:catch()
    elseif self:shouldFight() then
        --if self:fight() or 
        self:fight()
    else
        self:run()
    end
end

--- Base trainer battle scenario.
function Script:onTrainerBattle()
    -- if self:shouldFight() then
    --     self:fight()
    -- else
    --     self:panic()
    -- end
    if self:fight() or self:panic() then
        return
    end
end

--- If this returns false, pathAction is called.
-- If at least 1 Pokemon is usable, then it returns true.
-- @return bool
function Script:shouldHeal()
    for i=1, _G.getTeamSize() do
        if _G.isPokemonUsable(i) then
            return false
        end
    end
    return true
end

--- Base heal scenario.
function Script:heal() 
    assert(path.useNearestPokecenter(), "can't use nearest pokecenter")
end

--- If this returns false, shouldFight is called.
-- @return bool
function Script:shouldCatch()
    return _G.isOpponentShiny() or _G.getOpponentForm() ~= 0
end

--- Base catch scenario.
function Script:catch()
    if _G.useItem(ball[1]) or _G.useItem(ball[2]) or _G.useItem(ball[3]) then
        return
    end
    self:warn("can't use ball")
end

--- If this returns false, run is called. Not applicable to trainer
--- battles since they only have two options: fight or panic.
-- @return bool
function Script:shouldFight()
    return false
end

--- Base fight scenario.
function Script:fight() 
    return _G.attack() or _G.sendUsablePokemon()
end

--- Base run scenario.
function Script:run() 
    if _G.run() then
        return
    end
    self:error("can't run")
end

--- Base panic scenario.
-- This function is for avoiding black-outs.
function Script:panic()
    self:info("Relogging to avoid a black-out.")
    relog()
end

-- Some non-essential helper functions...

function Script:hunt(method)
    local function err()
        self:error("hunt method unknown: "..method)
    end

    local typ = type(method)
    if typ == "string" then
        if method == "g" then
            self:assert(_G.moveToGrass(), "can't moveToGrass")
        elseif method == "w" then
            self:assert(_G.moveToWater(), "can't moveToWater")
        elseif method == "ng" then
            self:assert(_G.moveToNormalGround(), "can't moveToNormalGround")
        elseif method == "ne" then
            self:assert(_G.moveNearExit(), "can't moveNearExit")
        else
            err()
        end
    elseif typ == "table" then
        if #method == 2 then
            self:assert(_G.moveToCell(), "can't moveToCell")
        elseif #method == 4 then
            if method[1] == method[3] or method[2] == method[4] then
                self:assert(path.moveToLine(), "can't moveToLine")
            else
                self:assert(_G.moveToRectangle(), "can't moveToRectangle")
            end
        else
            err()
        end
    else
        err()
    end
end

function Script:buy()
    -- TODO
end

function Script:sell()
    -- TODO
end

function Script:createTimeout(h, m, s)
    local timeout = require("core/timeout")()
    timeout:set(h, m, s)
    self.timeouts[#self.timeouts+1] = timeout
end

function Script:done(message)
    _G.fatal(self.name..": [✔️] "..message)
end

function Script:info(message)
    _G.log(self.name..": [ℹ️] "..message)
end

function Script:warn(message)
    _G.log(self.name..": [⚠️] "..message)
end

--- A wrapper for assert to decorate the message nicely.
-- @param v       A value to assert.
-- @param message The message to log if the assertion was falsey.
function Script:assert(v, message)
    if not v then
        _G.fatal(self.name..": [❌] "..message)
    end
end

function Script:error(message)
    _G.fatal(self.name..": [❌] "..message)
end

return Script





-- local timeout = require("core/timeout")

-- function script.new(o, name)
--     o = o or {}
--     setmetatable(o, self)
--     self.__index = self
--     _G.name = "Adamant Collection: "..name
--     return o
-- end

-- function script:run()
--     _G.onPathAction = self.onPathAction
--     _G.onBattleAction = self.onBattleAction
-- end

-- function script:stop()
--     if self.timeout ~= nil then 
--         self.timeout.cancel()
--     end
-- end

-- function script:onPathAction()
--     if self.timeout ~= nil then 
--         self.timeout.update()
--     end
-- end

-- function script:onBattleAction()
    
-- end

-- function script:scheduleLogout(h, m, s)
--     self.timeout = timeout.new()
--     self.timeout.set(h, m, s)
-- end

-- function script:scheduleRelog(h, m, s)
--     self.timeout = timeout.new()
--     self.timeout.set(h, m, s)
-- end

-- return script