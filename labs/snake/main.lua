Class = require './class'
require './Snake'

W_SIZE = 480;

SIZE = W_SIZE / 10;

function love.load()
  snake = Snake(SIZE)

  love.window.setMode(W_SIZE, W_SIZE, {
    vsync = true,
    fullscreen = false,
    resizable = false,
  })
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.update(dt)
  snake:update(dt)
end

function love.draw()
  snake:draw()
end
