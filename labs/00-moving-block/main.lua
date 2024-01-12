Class = require 'class'
require 'Block'

WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
  })

  love.keyboard.keysPressed = {}

  block = Block(50)
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.update(dt)
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  block:update(dt)

  love.keyboard.keysPressed = {}
end

function love.draw()
  block:render()
end
