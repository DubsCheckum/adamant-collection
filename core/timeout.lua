local Timeout = require("core/class")(function(t)
    t.start = nil
    t.waitTime = nil
    t.isActive = false
end)

function Timeout:set(h, m, s)
    local time = h*60*60 + m*60 + s
    assert(time >= 0, "invalid timeout")
    self.start = os.time()
    self.waitTime = os.time() + time
    self.isActive = true
end

function Timeout:cancel()
    self.isActive = false
end

function Timeout:update()
    if self.isActive and os.difftime(os.time(), self.start) > waitTime then
        self.isActive = false
    end
    return self.isActive
end

return Timeout