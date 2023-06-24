Block = Class {}

local BLOCK_MAX_SPEED = 10
local BLOCK_ACCELERATION = 8
local BLOCK_FRICTION = 50

function Block:init(size)
  self.size = size
  self.x = (WINDOW_WIDTH - size) / 2
  self.y = (WINDOW_HEIGHT - size) / 2

  self.vx = 0
  self.vy = 0
end

function Block:render()
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

function Block:update(dt)
  if love.keyboard.isDown('up') then
    self.vy = math.max(-BLOCK_MAX_SPEED, self.vy - BLOCK_ACCELERATION * dt)
  elseif love.keyboard.isDown('down') then
    self.vy = math.min(BLOCK_MAX_SPEED, self.vy + BLOCK_ACCELERATION * dt)
  elseif self.vy < 0 then
    self.vy = math.max(0, self.vy + BLOCK_FRICTION * dt)
  elseif self.vy > 0 then
    self.vy = math.min(0, self.vy - BLOCK_FRICTION * dt)
  end

  if love.keyboard.isDown('right') then
    self.vx = math.min(BLOCK_MAX_SPEED, self.vx + BLOCK_ACCELERATION * dt)
  elseif love.keyboard.isDown('left') then
    self.vx = math.max(-BLOCK_MAX_SPEED, self.vx - BLOCK_ACCELERATION * dt)
  elseif self.vx > 0 then
    self.vx = math.max(0, self.vx - BLOCK_FRICTION * dt)
  elseif self.vx < 0 then
    self.vx = math.min(0, self.vx + BLOCK_FRICTION * dt)
  end

  self.x = self.x + self.vx
  self.y = self.y + self.vy
end
