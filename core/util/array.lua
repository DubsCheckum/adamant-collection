local arr = {}

function arr.contains(a, value)
    for _,v in pairs(a) do
        if v == value then
            return true
        end
    end
    return false
end

return arr