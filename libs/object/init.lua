--&private&--
local BASE = (...) .. "."
local json = require(BASE .. "json")
object = {}
object.__index = object -- instance

--&public&--
function object.new(_x, _y, _w, _h) -- constructor
    local _obj = setmetatable({}, object)
    _obj.x = _x or 0
    _obj.y = _y or 0
    _obj.angle = 0
    _obj.sx = 1
    _obj.sy = 1
    _obj.ox = 0
    _obj.oy = 0
    _obj.w = _w or 0
    _obj.h = _h or 0
    _obj.speed = 50
    _obj.anim = {}
    _obj.anim.speed = 1
    _obj.anim.timer = 0
    _obj.anim.current = "idle"
    _obj.anim.frame = {}
    _obj.anim.frame.rate = 1 / 60
    _obj.anim.frame.current = 1
    _obj.meta = {}
    _obj.meta.img = nil
    _obj.meta.anim = {}
    _obj.meta.anim.play = false
    _obj.meta.anim.loop = false
    _obj.meta.anim.quads = {}
    _obj.meta.anim.anims = {}
    return _obj
end

--%functions%--
function object:loadImg(_path) self.meta.img = love.graphics.newImage(_path) end

function object:loadSparrow(_path)
    self.meta.img = love.graphics.newImage(_path .. ".png")
    local _sparrow = json.decode(love.filesystem.read(_path .. ".json"))
    for _ = 1, #_sparrow.frames, 1 do
        table.insert(self.meta.anim.quads,
            love.graphics.newQuad(
                _sparrow.frames[_].frame.x,
                _sparrow.frames[_].frame.y,
                _sparrow.frames[_].frame.w,
                _sparrow.frames[_].frame.h,
                self.meta.img
            )
        )
    end
end

function object:registerAnimation(_name, _indexes) self.meta.anim.anims[_name] = _indexes end

function object:setAnimation(_animName, _framerate, _loop, _play)
    self.anim.current = _animName or self.anim.current or "idle"
    self.anim.frame.rate = _framerate or self.anim.frame.rate or 1 / 60
    self.meta.anim.loop = _loop or self.anim.loop or false
    self.meta.anim.play = _play or self.meta.anim.play or false
end

function object:getPos() return self.x, self.y end

function object:setSpeed(_speed) self.speed = _speed or self.speed or 100 end

function object:getSpeed() return self.speed end

function object:setHowDraw(_x, _y, _angle, _sx, _sy, _ox, _oy)
    self.x = _x or self.x or 0
    self.y = _y or self.y or 0
    self.angle = _angle or self.angle or 0
    self.sx = _sx or self.sx or 1
    self.sy = _sy or self.sy or 1
    self.ox = _ox or self.ox or 0
    self.oy = _oy or self.oy or 0
end

function object:setDimensions(_w, _h)
    self.w = _w or self.w or 0
    self.h = _h or self.h or 0
end

function object:flip(_axis, _flip)
    if _axis == "x" then
        self.sx = -_flip or -self.sx or -1
    elseif _axis == "y" then
        self.sy = -_flip or -self.sy or -1
    elseif _axis == "xy" or _axis == "yx" then
        self.sx = -_flip or -self.sx or -1
        self.sy = -_flip or -self.sy or -1
    else
        error("bad argument #1 to 'flip' (invalid axis)")
    end
end

--%external api%--
function object:centerScreen()
    self.x = love.graphics.getWidth() / 2 - self.w / 2
    self.y = love.graphics.getHeight() / 2 - self.h / 2
end

function object:draw()
    if self.meta.img ~= nil then
        if #self.meta.anim.quads > 0 then
            if self.anim.frame.current > #self.meta.anim.anims[self.anim.current] then
                self.anim.frame.current = 1
            end
            love.graphics.draw(self.meta.img, self.meta.anim.quads[self.meta.anim.anims[self.anim.current][self.anim.frame.current]], _x or self.x, _y or self.y, _angle or self.angle or 0, _sx or self.sx or 1, _sy or self.sy or 0, _ox or self.ox or 0)
        else
            love.graphics.draw(self.meta.img, self.x, self.y, self.angle or 0, self.sx or 1, self.sy or 0,  self.ox or 0)
        end
    end
end

function object:update(_elapsed)
    if #self.meta.anim.quads > 0 then
        if self.meta.anim.play then
            self.anim.timer = self.anim.timer + _elapsed
            if self.anim.timer >= self.anim.frame.rate then
                self.anim.timer = 0
                if self.anim.frame.current < #self.meta.anim.anims[self.anim.current] then
                    self.anim.frame.current = self.anim.frame.current + 1
                elseif self.meta.anim.loop then
                    self.anim.frame.current = 1
                else
                    self.meta.anim.play = false
                end
            end
        end
    end
end

return object