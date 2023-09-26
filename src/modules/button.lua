--&private&‐--
button = {}
button.__index = button

local function btnIsPressed(_tx, _ty, _btn)
    if _tx >= _btn.x and _ty >= _btn.y and _tx <= _btn.x + _btn.w and _ty <= _btn.y + _btn.h then
        return true
    end
    return false
end
--&public&--
function button.new(_x, _y, _w, _h, _firstQuad)
    return setmetatable({
        x = _x or 0,
        y = _y or 0,
        w = _w or 16,
        h = _h or 16,
        currentQuad = _firstQuad or 1
    }, button)
end

function button:draw(_img, _quads, _x, _y, _angle, _sx, _sy, _ox, _oy)
    if #_quads > 0 then
        love.graphics.draw(_img, _quads[self.currentQuad], _x or self.x, _y or self.y, _angle, _sx, _sy, _ox, _oy)
    else
        love.graphics.draw(_img, _x or self.x, _y  or self.y, _angle, _sx, _sy, _ox, _oy)
    end
end

function button:update(_normal, _pressed, _callBack)
    for _, touch in ipairs(love.touch.getTouches()) do
        local _tx, _ty = love.touch.getPosition(touch)
        self.currentQuad = _normal
        if btnIsPressed(_tx, _ty, self) then
            self.currentQuad = _pressed
            if _callBack ~= nil then
                _callBack()
            end
        end
    end
end

return button