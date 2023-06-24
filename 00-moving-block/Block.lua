Block = Class {}

local BLOCK_DEFAULT_SPEED = 200

function Block:init(size)
  self.size = size
  self.x = (WINDOW_WIDTH - size) / 2
  self.y = (WINDOW_HEIGHT - size) / 2
end

function Block:render()
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

function Block:update(dt)
  local speed = BLOCK_DEFAULT_SPEED

  if love.keyboard.isDown('lshift') then
    speed = speed * 2
  end

  if not (love.keyboard.isDown('left') and love.keyboard.isDown('right'))
      and (love.keyboard.isDown('left') or love.keyboard.isDown('right')) then
    local direction = love.keyboard.isDown('left') and -1 or 1

    self.x = self.x + (speed * dt * direction)
  end

  if not (love.keyboard.isDown('up') and love.keyboard.isDown('down'))
      and (love.keyboard.isDown('up') or love.keyboard.isDown('down')) then
    local direction = love.keyboard.isDown('up') and -1 or 1

    self.y = self.y + (speed * dt * direction)
  end

  if self.x < 0 then
    self.x = 0
  elseif (self.x + self.size) > WINDOW_WIDTH then
    self.x = WINDOW_WIDTH - self.size
  end

  if self.y < 0 then
    self.y = 0
  elseif (self.y + self.size) > WINDOW_HEIGHT then
    self.y = WINDOW_HEIGHT - self.size
  end
end
