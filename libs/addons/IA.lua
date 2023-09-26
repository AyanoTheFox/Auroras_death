local Ia = {}

--               private                 --
--^return the distance between 2 points
--&_obj1 is a table
--&_obj2 is a table
local function dist2(_obj1, _obj2) return math.sqrt(math.abs(_obj2.x - _obj1.x) ^ 2 + math.abs(_obj2.y - _obj1.y) ^ 2) end

--                 public                 --
function Ia:new(_x, _y, _w, _h, _speed, _vision)
    local _ia = setmetatable({}, self)
    _ia.x, _ia.y, _ia.w, _ia.h = _x or 0, _y or 0, _w, _h
    _ia.speed = _speed or 100
    _ia.d = _vision or 128
    getmetatable(_ia).__index = self
    return _ia
end

function Ia:see(_objective)
    if collision.circRect(self, _objective) then return true
    else return false end
end

function Ia:runOf(_objective, _elapsed)
    if not collision.rects(self, _objective) then
        if math.floor(self.x) > _objective.x - _errorMargin then self.x = self.x + self.speed * (_elapsed or 1)
        elseif math.floor(self.x) < _objective.x + _errorMargin then self.x = self.x - self.speed * (_elapsed or 1) end
        
        if math.floor(self.y) > _objective.y - _errorMargin then self.y = self.y + self.speed * (_elapsed or 1)
        elseif math.floor(self.y) < _objective.y + _errorMargin then self.y = self.y - self.speed * (_elapsed or 1) end
        
        return false
    else return true end
end

function Ia:get(_objective, _elapsed)
    if not collision.rects(self, _objective) then
        if math.floor(self.x) > _objective.x then self.x = self.x - self.speed * (_elapsed or 1)
        elseif math.floor(self.x) < _objective.x then self.x = self.x + self.speed * (_elapsed or 1) end
        
        if math.floor(self.y) > _objective.y then self.y = self.y - self.speed * (_elapsed or 1)
        elseif math.floor(self.y) < _objective.y then self.y = self.y + self.speed * (_elapsed or 1) end
        
        return false
    else return true end
end

return Ia