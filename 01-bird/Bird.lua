Bird = Class {}

local GRAVITY = 20

function Bird:init()
  self.image = love.graphics.newImage('bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.x = (VIRTUAL_WIDTH - self.width) / 2
  self.y = (VIRTUAL_HEIGHT - self.height) / 2

  self.dy = 0
end

function Bird:collides(pipe)
  if (self.x + self.width) >= (pipe.x + 4) and self.x <= (pipe.x + PIPE_WIDTH - 4) then
    if (self.y + self.height) >= (pipe.y + 4) and self.y <= (pipe.y + PIPE_HEIGHT - 4) then
      return true
    end
  end

  return false
end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt

  if love.keyboard.wasPressed('space') or love.mouse.isClicked then
    self.dy = -4
    sounds['jump']:play()
  end

  self.y = self.y + self.dy
end
