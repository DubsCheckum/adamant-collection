if _G.fatal then
    _G.fatal("get out of debug lol")
end

function registerHook(funcName, callback)
    if funcName == "onStart" then
        callback()
    end
end
function getServer() return "Gold" end
function getAccountName() return "Asdf" end
function log() end
function getTeamSize() return 6 end
function hasMove() return true end
function getPokemonHappiness() return 155 end
function setTextOptionName() end
function setTextOptionDescription() end
function getNpcData() return {} end