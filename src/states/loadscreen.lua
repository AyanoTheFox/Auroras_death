loadscreen = {}

function loadscreen:enter()
    --%instances%--
    cam = camera.new(nil, nil, 2.5, 0)
    camx, camy = cam:position()
    --%player%--
    player = object.new(0, 0, 16, 16)
    --%hud%--
    Joystick = joystick.new(love.graphics.getWidth() / 2 - 398, love.graphics.getHeight() / 2 + 8, 192, 192)
    buttonPause = button.new(love.graphics.getWidth() / 2 + 336, love.graphics.getHeight() / 2 - 184, 48, 48, 4)
    buttonLantern = button.new(love.graphics.getWidth() / 2 + 320, love.graphics.getHeight() / 2 + 128, 64, 64, 5)
    buttonRun = button.new(love.graphics.getWidth() / 2 + 320, love.graphics.getHeight() / 2 + 16, 64, 64, 1)
    --%variables%--
    oftLogo = love.graphics.newImage("assets/images/oftlogo.png")
    nxLogo = love.graphics.newImage("assets/images/nxlogo.png")
    --nxLogo = love.graphics.newImage()
    alph = 1
    --%table%--
    gameButtons = {}
    gameButtons.texture, gameButtons.quads = atlasparser.getQuads("assets/preloaded/sheets/gamebuttons")
    --%animations%--
    player:loadSparrow("assets/preloaded/sheets/aurora")
    player:registerAnimation("walk_up", {5, 6, 7, 8})
    player:registerAnimation("walk_right", {9, 10, 11, 12})
    player:registerAnimation("walk_down", {1, 2, 3, 4})
    player:registerAnimation("idle_down", {13, 14})
    player:registerAnimation("idle_right", {15, 16})
    player:registerAnimation("idle_up", {17, 18})
    --%hud%--
    Joystick:loadSparrow("assets/preloaded/sheets/joystick")
    --%timer%--
    lsTimer = timer.new()
    lsTimer:after(2.5, function()
        oftLogo:release()
        --nxLogo:release()
        gamestate.switch(states.game)
    end)
    lsTimer:tween(2.5, _G, {alph = 0}, "in-linear")
end

function loadscreen:draw()
    love.graphics.setColor(1, 1, 1, alph)
    love.graphics.draw(oftLogo, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 1, 1, 0, oftLogo:getHeight() / 2)
    love.graphics.draw(nxLogo, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, .1422222222, .1422222222, nxLogo:getWidth(), nxLogo:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)
end

function loadscreen:update(elapsed)
    lsTimer:update(elapsed)
end

return loadscreen