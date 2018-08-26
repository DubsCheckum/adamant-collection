local tbl = {}

function tbl.hasKey(t, key)
    return t[key] ~= nil
end

function tbl.hasValue(t, value)
    for _,v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

return tbl