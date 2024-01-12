push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

INITIAL_GAME_SPEED = 60

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0


local BACKGROUND_LOOPING_POINT = 413

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  math.randomseed(os.time())

  love.window.setTitle('Fifty Bird')

  smallFont = love.graphics.newFont('font.ttf', 8)
  mediumFont = love.graphics.newFont('flappy.ttf', 14)
  flappyFont = love.graphics.newFont('flappy.ttf', 28)
  hugeFont = love.graphics.newFont('flappy.ttf', 56)

  love.graphics.setFont(flappyFont)

  sounds = {
    ['jump'] = love.audio.newSource('jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
    ['score'] = love.audio.newSource('score.wav', 'static'),
    ['music'] = love.audio.newSource('marios_way.mp3', 'static')
  }

  love.audio.setVolume(0.1)

  sounds['music']:setLooping(true)
  sounds['music']:play()

  gameSpeed = INITIAL_GAME_SPEED
  gamePaused = false

  push:setupScreen(
    VIRTUAL_WIDTH,
    VIRTUAL_HEIGHT,
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      vsync = true,
      fullscreen = false,
      resizable = true
    }
  )

  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,
    ['countdown'] = function() return CountdownState() end
  }
  gStateMachine:change('title')

  love.keyboard.keysPressed = {}
  love.mouse.isClicked = false
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true

  if key == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed()
  love.mouse.isClicked = true
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

function love.update(dt)
  if not gamePaused then
    backgroundScroll = (backgroundScroll + (gameSpeed / 2) * dt)
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + gameSpeed * dt)
        % VIRTUAL_WIDTH
  end

  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
  love.mouse.isClicked = false
end

function love.draw()
  push:start()

  love.graphics.draw(background, -backgroundScroll, 0)
  gStateMachine:render()
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  displayFPS()

  push:finish()
end

function displayFPS()
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 10)
end
