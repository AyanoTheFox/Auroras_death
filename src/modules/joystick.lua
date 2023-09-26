--&private&--
joystick = {}
joystick.__index = joystick

local function btnIsPressed(_tx, _ty, _btn)
    if _tx >= _btn.x and _ty >= _btn.y and _tx <= _btn.x + _btn.w and _ty <= _btn.y + _btn.h then
        return true
    end
    return false
end

--&public&--
function joystick.new(_x, _y, _w, _h) -- constructor
    local _joystick = setmetatable({}, joystick)
    _joystick.x = _x or 0
    _joystick.y = _y or 0
    _joystick.w = _w or 64
    _joystick.h = _h or 64
    _joystick.buttons = {}
    _joystick.buttons.btn1 = {}
    _joystick.buttons.btn1.x = _x + _w / 3
    _joystick.buttons.btn1.y = _y
    _joystick.buttons.btn1.w = _w / 3
    _joystick.buttons.btn1.h = _h / 3
    _joystick.buttons.btn1.isPressed = false
    _joystick.buttons.btn2 = {}
    _joystick.buttons.btn2.x = _x + _w - _w / 3
    _joystick.buttons.btn2.y = _y + _h / 3
    _joystick.buttons.btn2.w = _w / 3
    _joystick.buttons.btn2.h = _w / 3
    _joystick.buttons.btn2.isPressed = false
    _joystick.buttons.btn3 = {}
    _joystick.buttons.btn3.x = _x + _w / 3
    _joystick.buttons.btn3.y = _y + _h - _h / 3
    _joystick.buttons.btn3.w = _w / 3
    _joystick.buttons.btn3.h = _h / 3
    _joystick.buttons.btn3.isPressed = false
    _joystick.buttons.btn4 = {}
    _joystick.buttons.btn4.x = _x
    _joystick.buttons.btn4.y = _y + _h / 3
    _joystick.buttons.btn4.w = _w / 3
    _joystick.buttons.btn4.h = _h / 3
    _joystick.buttons.btn4.isPressed = false
    _joystick.buttons.btn5 = {}
    _joystick.buttons.btn5.x = _x + _w / 3
    _joystick.buttons.btn5.y = _y + _h / 3
    _joystick.buttons.btn5.w = _w / 3
    _joystick.buttons.btn5.h = _h / 3
    _joystick.buttons.btn5.isPressed = false
    _joystick.frame = {}
    _joystick.frame.current = 1
    _joystick.meta = {}
    _joystick.meta.img = nil
    _joystick.meta.quads = {}
    _joystick.meta.lastPressed = nil
    return _joystick
end

function joystick:loadImage(_data)
    self.meta.img = love.graphics.newImage(_data)
end

function joystick:loadSparrow(_data)
    self.meta.img = love.graphics.newImage(_data .. ".png")
    local _sparrow = json.decode(love.filesystem.read(_data .. ".json"))
    for _ = 1, #_sparrow.frames, 1 do
        table.insert(self.meta.quads,
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

function joystick:getLastPressed()
    if self.buttons.btn1.isPressed then
        return "up"
    elseif self.buttons.btn2.isPressed then
        return "right"
    elseif self.buttons.btn3.isPressed then
        return "down"
    elseif self.buttons.btn4.isPressed then
        return "left"
    elseif self.buttons.btn5.isPressed then
        return "center"
    end
    return "none"
end

--%external api%--
function joystick:draw(_sx, _sy)
    if self.meta.img ~= nil then
        if #self.meta.quads > 0 then
            love.graphics.draw(self.meta.img, self.meta.quads[self.frame.current], self.x, self.y, 0, _sx, _sy)
        else
            love.graphics.draw(self.meta.imh, self.x, self.y, 0, _sx, _sy)
        end
    end
end

function joystick:update(_btn1, _btn2, _btn3, _btn4, _btn5)
    for _, touch in ipairs(love.touch.getTouches()) do
        local _tx, _ty = love.touch.getPosition(touch)
        self.buttons.btn1.isPressed = btnIsPressed(_tx, _ty, self.buttons.btn1)
        self.buttons.btn2.isPressed = btnIsPressed(_tx, _ty, self.buttons.btn2)
        self.buttons.btn3.isPressed = btnIsPressed(_tx, _ty, self.buttons.btn3)
        self.buttons.btn4.isPressed = btnIsPressed(_tx, _ty, self.buttons.btn4)
        self.buttons.btn5.isPressed = btnIsPressed(_tx, _ty, self.buttons.btn5)
        if self.buttons.btn1.isPressed then
            self.frame.current = _btn1.isPressed
            if _btn1.callback ~= nil then
                _btn1.callback()
            end
        elseif self.buttons.btn2.isPressed then
            self.frame.current = _btn2.isPressed
            if _btn2.callback ~= nil then
                _btn2.callback()
            end
        elseif self.buttons.btn3.isPressed then
            self.frame.current = _btn3.isPressed
            if _btn3.callback ~= nil then
                _btn3.callback()
            end
        elseif self.buttons.btn4.isPressed then
            self.frame.current = _btn4.isPressed
            if _btn4.callback ~= nil then
                _btn4.callback()
            end
        elseif self.buttons.btn5.isPressed then
            self.frame.current = _btn5.isPressed
            if _btn5.callback ~= nil then
                _btn5.callback()
            end
        end
    end
end

function joystick:touchreleased(_frame, _callback)
    self.buttons.btn1.isPressed = false
    self.buttons.btn2.isPressed = false
    self.buttons.btn3.isPressed = false
    self.buttons.btn4.isPressed = false
    self.buttons.btn5.isPressed = false
    self.frame.current = _frame or self.frame.current or 1
    if _callback ~= nil then _callback() end
end

return joystick