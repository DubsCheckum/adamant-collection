local battle = {}

function battle.huntGrass()
    return moveToGrass()
end

function battle.huntGround()
    return moveToNormalGround()
end

function battle.huntWater()
    return moveToWater()
end

function battle.huntRect(x1, y1, x2, y2)
    if type(x1) == "table" then
        return moveToRectangle(x1)
    end
    return moveToRectangle(x1, y1, x2, y2)
end

function battle.huntLine(x1, y1, x2, y2)
end

return battle