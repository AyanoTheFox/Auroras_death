game = {}

function game:enter(_argc, _argv)
    player:setAnimation("idle_down", 1 / 4, true, true)
    player:centerScreen()
end

function game:draw()
    cam:attach()
    player:draw()
    cam:detach()
    --%Hud%--
    love.graphics.setColor(1, 1, 1, .75)
    Joystick:draw(2, 2)
    buttonPause:draw(gameButtons.texture, gameButtons.quads, nil, nil, 0, 1.5, 1.5)
    buttonRun:draw(gameButtons.texture, gameButtons.quads, nil, nil, 0, 2, 2)
    buttonLantern:draw(gameButtons.texture, gameButtons.quads, nil, nil, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, 1)
end

function game:update(elapsed)
    camx, camy = cam:position()
    local _playerx, _playery = player:getPos()
    player:update(elapsed)
    Joystick:update({
        isPressed = 5,
        callback = function()
            player:setAnimation("walk_up", 1 / 4, true, true)
            player:setHowDraw(_playerx, _playery - player:getSpeed() * elapsed, 0, 1, 1, 0, 0)
        end
    },
    {
        isPressed = 2,
        callback = function()
            player:setAnimation("walk_right", 1 / 4, true, true)
            player:setHowDraw(_playerx + player:getSpeed() * elapsed, _playery, 0, 1, 1, 0, 0)
        end
    },
    {
        isPressed = 3,
        callback = function()
            player:setAnimation("walk_down", 1 / 4, true, true)
            player:setHowDraw(_playerx, _playery + player:getSpeed() * elapsed, 0, 1, 1, 0, 0)
        end
    },
    {
        isPressed = 4,
        callback = function()
            player:setAnimation("walk_right", 1 / 4, true, true)
            player:setHowDraw(_playerx - player:getSpeed() * elapsed, _playery, 0, -1, 1, 16, 0)
        end
    }, 
    {
        isPressed = 6,
        callback = function()
            
        end
    })
    player:setSpeed(50) -- it will reset the speed
    --%buttons%--
    buttonPause:update(4, 3)
    buttonRun:update(1, 2, function() player:setSpeed(75) end)
    buttonLantern:update(5, 6)
end

function game:touchreleased(id, x, y, dx, dy, pressed)
    local _lastPressed = Joystick:getLastPressed()
    Joystick:touchreleased(1, function()
        if _lastPressed == "up" then
            player:setAnimation("idle_up", 1 / 4, true, true)
            player:setHowDraw(_playerx, _playery, 0, 1, 1, 0, 0)
        elseif _lastPressed == "right" then
            player:setAnimation("idle_right", 1 / 4, true, true)
            player:setHowDraw(_playerx, _playery, 0, 1, 1, 0, 0)
        elseif _lastPressed == "down" then
            player:setAnimation("idle_down", 1 / 4, true, true)
            player:setHowDraw(_playerx, _playery, 0, 1, 1, 0, 0)
        elseif _lastPressed == "left" then
            player:setAnimation("idle_right", 1 / 4, true, true)
            player:setHowDraw(_playerx, _playery, 0, -1, 1, 16, 0)
        end
    end)
end

return game