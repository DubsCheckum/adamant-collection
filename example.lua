
local Example = require("core/class")(require("core/script"))

local config = {
    name = "Example",
    author = "DubsCheckum",
    description = "An example description.",
}

-- The 2 required functions.
function Example:getDestination() 
end

function Example:pathAction()
end

require("core/core")(Example(config))