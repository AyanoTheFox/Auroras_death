function love.load(_argc, _argv)
    --%libs%--
    --#graphicals libs#--
    gamestate = require "libs/gamestate"
    moonshine = require "libs/moonshine"
    camera = require "libs/camera"
    --#dataBank libs#--
    json = require "libs/json"
    lip = require "libs/lip"
    --#others#--
    timer = require "libs/timer"
    collision = require "libs/collision"
    object = require "libs/object"
    require "libs/lep"
    --%addons%--
    atlasparser = require "libs/addons/atlasparser"
    joystick = require "src/modules/joystick"
    button = require "src/modules/button"
    --%tables%--
    --#gamestate states#--
    states = {}
    states.game = require "src/states/game"
    states.loadScreen = require "src/states/loadscreen"
    --%vars%--
    font = love.graphics.setNewFont(12) --defaultFont
    --%cmds%--
    love.graphics.setDefaultFilter("nearest", "nearest") --defaultfilter
    gamestate.registerEvents({"update"; "textinput"; "textedited"; "keypressed"; "touchpressed"; "touchmoved"; "touchreleased"})
    gamestate.switch(states.loadScreen)
end

function love.draw() gamestate.current():draw() end

function love.textedited(_t, _s, _l) suit.textedited(_t, _s, _l) end

function love.keypressed(_k) suit.keypressed(_k) end

function love.textinput(_t) suit.keypressed(_t) end