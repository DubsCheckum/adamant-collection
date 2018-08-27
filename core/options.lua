local options = {}
options.switchCount = 1
options.textCount = 1

local class = require("core/class")

options.Option = class(function(o, index)
    o.index = index
end)


options.SwitchOption = class(Option, function(s, name, desc)
    Option.init(s, options.switchCount)
    assert(name, "name can't be nil")
    _G.setOptionName(s.index, name)
    assert(desc, "desc can't be nil")
    _G.setOptionDescription(s.index, desc)
    options.switchCount = options.switchCount + 1
end)

function options.SwitchOption:set(value)
    _G.setOption(self.index, value)
end

function options.SwitchOption:get()
    return _G.getOption(self.index)
end

function options.SwitchOption:remove()
    _G.removeOption(self.index)
end


options.TextOption = class(options.Option, function(t, name, desc)
    options.Option.init(t, options.textCount)
    assert(name, "name can't be nil")
    _G.setTextOptionName(t.index, name)
    assert(desc, "desc can't be nil")
    _G.setTextOptionDescription(t.index, desc)
    options.textCount = options.textCount + 1
end)

function options.TextOption:set(value)
    _G.setTextOption(self.index, value)
end

function options.TextOption:get()
    return _G.getTextOption(self.index)
end

--- Gets the text option value feeds to parseCoords, if the return value is nil, the parsed
--- coord table will be returned, else the string value.
-- @return string or table
function options.TextOption:getAndParse()
    local text = self:get()
    local parsed = options.parseCoords(text)
    return parsed or text
end

function options.TextOption:remove()
    _G.removeTextOption(self.index)
end

--- Find the nearest matching string using the Levenshtein distance.
-- You should check for exact match first, as this function is expensive.
-- TODO: rename this to something more appropriate.
-- TODO: use Damerau-Levenshtein algorithm instead.
-- @param str   The string to find the nearest to.
-- @param words The table of words to compare to the str.
-- @return      The string with the shortest Levenshtein distance to str.
function options.nearest(str, words)
    local function leven(str1, str2)
        if str1 == str2 then return 0 end
    
        local len1 = #str1
        local len2 = #str2
    
        if len1 == 0 then
            return len2
        elseif len2 == 0 then
            return len1
        end
    
        local matrix = {}
        for i = 0, len1 do
            matrix[i] = {[0] = i}
        end
        for j = 0, len2 do
            matrix[0][j] = j
        end
    
        for i = 1, len1 do
            for j = 1, len2 do
                local cost = str1:byte(i) == str2:byte(j) and 0 or 1
                matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
            end
        end
    
        return matrix[len1][len2]
    end

    local closest
    local shortest
    for i,v in ipairs(words) do
        local lev = leven(str, v)
        if not shortest then
            shortest = lev
        elseif lev < shortest then
            closest = v
            shortest = lev
        end
        if lev == 1 then
            return v
        end
    end
    return closest
end

--- Parse coords from a string to a table, i.e. "1,2,3,4" -> {1, 2, 3, 4}.
-- @return table or nil
function options.parseCoords(s)
    local coords = {}
    local c1, c2, c3 = s:find(",")
    local isRect = c1 and c2 and c3

    if not c1 then
        return nil
    end

    coords[1] = tonumber(s:sub(1,c1-1))
    coords[2] = tonumber(s:sub(c1+1))
    if isRect then
        coords[3] = tonumber(s:sub(c2+1, c3-1))
        coords[4] = tonumber(s:sub(c3+1))
    end

    return coords
end

return options