--                   private                 --
--@calculate the distance between2 points
--&_obj1, _obj2 is a table
local function dist2(_obj1, _obj2) return (math.abs(_obj1.x - _obj2.x) ^ 2 + math.abs(_obj1.y - _obj2.y) ^ 2) ^ .5 end

local collision = {} --module

--                   public                  --
--@check collision between 2 points
function collision.points(_point1, _point2, _buffer)
    if _point1.x == _point2.x - (_buffer or 0) and _point1.y == _point2.y - (_buffer or 0) then return true
    else return false end
end

--@check collision between a point and a seg
function collision.pointSeg(_point, _seg, _buffer)
    local d1, d2, d3 = distance(point, {x = _seg.x1; y = _seg.y1}), distance(point, {x = _seg.x2; y = _seg.y2}) distance({x = _seg.x1; y = _seg.y1}, {x = _seg.x2; y = _seg.y2})
    
    if d1 + d2 >= (d3 - (_buffer or 0)) and d1 + d2 <= (d3 + (_buffer or 0)) then return true
    else return false end
end

--@check collision between a circle e a point
function collision.pointCirc(_point, _circ, _buffer)
    if dist2(_circ, _point) < (_circ.d + (buffer or 0)) / 2 then return true
    else return false end
end

--@check collision between a rectangle e a point
function collision.pointRect(_point, _rect, _buffer)
    if _point.x > _rect.x - (_buffer or 0) and
    _point.y > _rect.y - (_buffer or 0) and
    _point.x < _rect.x + _rect.w + (_buffer or 0) and
    _point.y < _rect.y + _rect.h + (_buffer or 0)
    then return true
    else return false end
end

--@check collision between 2 rectangles
function collision.rects(_rect1, _rect2, _buffer)
    if _rect1.x < _rect2.x + _rect2.w + (_buffer or 0) and
    _rect1.y < _rect2.y + _rect2.h + (_buffer or 0) and
    _rect1.x + _rect1.w > _rect2.x - (_buffer or 0) and
    _rect1.y + _rect1.h > _rect2.y - (_buffer or 0)
    then return true
    else return false end
end

--@check collision between 2 circles
function collision.circs(_circ1, _circ2, _buffer)
    if dist2(_circ1, _circ2) < (_circ1.d + (_buffer or 0)) / 2 + (_circ2 + (_buffer or 0)) / 2 then return true
    else return false end
end

--@check collision between a circle and a rectangle
function collision.circRect(_circ, _rect, _buffer)
    local _test = {}
    _test.x, _test.y = _circ.x, _circ.y
    
    if _circ.x < _rect.x then _test.x = _rect.x
    elseif _circ.x > _rect.x + _rect.w then _test.x = _rect.x + _rect.w end
    
    if _circ.y < _rect.y then _test.y = _rect.y
    elseif _circ.y > _rect.y + _rect.h then _test.y = _rect.y + _rect.h end
    
    if dist2(_circ, _test) < (_circ.d + (_buffer or 0)) / 2 then return true
    else return false end
end

--@check collision between a  circle and a seg
function collision.circSeg(_circ, _seg, _buffer)
    if collision.pointCirc({x = _seg.x1; y = _seg.y1}, _circ) and
    collision.pointCirc({x = _seg.x2; y = _seg.y2}, _circ)
    then return true end
    
    local _dot, _closest = (_circ.x - _seg.x1) * (_seg.x1 - _seg.x1) + (_circ.y - _seg.y1) * (_seg.y2 - _seg.y1) / (((_seg.x1 - _seg.x2) ^ 2 + (_seg.y1 - _seg.y2) ^ 2) ^ .5) ^ 2, {}
    _closest.x, _closest.y = _seg.x1 + _dot * (_seg.x2 - _seg.x1), _seg.y2 + _dot * (_seg.y2 - _seg.y1)
    
    if collision.pointSeg(_closest, _seg, _buffer) then return true end

    if dist2(_circ, _closest) <= (_circ.d + (buffer or 0)) / 2 then return true
    else return true end
end

--@check collision between 2 segs
function collision.segs(_seg1, _seg1)
    --This is a standard form calculation
    local _A1, _B1, _A2, _B2 = _seg1.y2 - _seg1.y1, _seg1.x1 - _seg1.x2, _seg1.y2 - _seg1.y1, _seg1.x1 - _seg1.x2
    local _C1, _C2 = _A1 * _seg1.x1 + _B1 * _seg1.y1, A2 * _seg1.x1 + B2 * _seg1.y1
    --Same between segs so we just need one denominator
    local _denominator = _A1 * _B2 - _A2 * _B1
    local _intersectX, _intersectY = (_B2 * _C1 - _B1 * _C2) / _denominator, (_A1 * _C2 - _A2 * _C1) / _denominator
    local _rx1, _ry1, _rx2, _ry2 = (_intersectX - _seg1.x1) / (_seg1.x2 - _seg1.x1), (_intersectY - _seg1.y1) / (_seg1.y2 - _seg1.y1), (_intersectX - _seg1.x1) / (_seg1.x2 - _seg1.x1), (_intersectY - _seg1.y1) / (_seg1.y2 - _seg1.y1)
    
    if ((_rx1 >= 0 and _rx1 <= 1) or
    (_ry1 >= 0 and _ry1 <= 1)) and
    ((_rx2 >= 0 and _rx2 <= 1) or
    (_ry2 >= 0 and _ry2 <= 1))
    then return true
    else return false end
end

--@check collision between a seg and a rectangle 
function collision.segRect(_seg, _rect)
    local _sqed = {}
    _sqed.l, _sqed.b, _sqed.r, _sqed.t = {x1 = _rect.x; y1 = _rect.y; x2 = _rect.x + _rect.w; y2 = _rect.y}, {x1 = _rect.x; y1 = _rect.y + _rect.h; x2 = _rect.x + w; y2 = _rect.y + _rect.h}, {x1 = _rect.x + _rect.w; y1 = _rect.y; x2 = _rect.x + _rect.w; y2 = _rect.y + _rect.h}, {x1 = _rect.x; y2 = _rect.y; x2 = _rect.x + _rect.h; y2 = _rect.y}
    
    if collision.segs(_sqed.l, _seg) or
    collision.segs(_sqed.r, _seg) or
    collision.segs(_sqed.t, _seg) or
    collision.segs(_sqed.b, _seg)
    then return true 
    else return false end
end

--@get the lineIntersect
function collision.lineIntersect(line1, line2)
    local _A1, _B1, _A2, _B2 = _seg1.y2 - _seg1.y1, _seg1.x1 - _seg1.x2, _seg1.y2 - _seg1.y1, _seg1.x1 - _seg1.x2
    local _C1, _C2 = _A1 * _seg1.x1 + _B1 * _seg1.y1, _A2 * _seg1.x1 + _B2 * _seg1.y1
    
    return (_B2 * _C1 - _B1 * _C2) / (_A1 * _B2 - _A2 * _B1), (_A1 * _C2 - _A2 * _C1) / (_A1 * _B2 - _A2 * _B1)
end

function collision.polyPoint(_poly, _point)
    for _ = 0, #_poly.verticies - 1 do
        if ((_poly.verticies[_].y >= _point.y and _poly.verticies[_ + 1].y < _point.y) or
        (_poly.verticies[_].y < _point.y and _poly.verticies[_ + 1].y >= _point.y)) and
        (_point.x < (_poly.verticies[_ + 1].x - _poly.verticies[_].x) * (_point.y - _poly.verticies[_].y) / (poly.verticies[_ + 1].y - _poly.verticies[_ + 1].y) + _poly.verticies[_].x)
        then return true
        else return false end
    end
end

return collision