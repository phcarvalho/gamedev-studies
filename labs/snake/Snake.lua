Snake = Class {}

local DIRECTION = {
  ['up'] = { x = 0, y = -1 },
  ['down'] = { x = 0, y = 1 },
  ['left'] = { x = -1, y = 0 },
  ['right'] = { x = 1, y = 0 },
}

function Snake:init(size)
  self.size = size
  self.direction = 'right'

  self.interval = 1.0
  self.timer = 0.0

  self.body = { { x = 4, y = 4 } }

  self.eating = false
  self.started = false

  self.food = { x = 7, y = 7 }
end

function Snake:update(dt)
  if not self.started then
    if love.keyboard.isDown('space') then
      self.started = true
      self.dx = 1
    else
      return
    end
  end

  if love.keyboard.isDown('up') and self.direction ~= 'down' then
    self.direction = 'up'
  elseif love.keyboard.isDown('down') and self.direction ~= 'up' then
    self.direction = 'down'
  elseif love.keyboard.isDown('left') and self.direction ~= 'right' then
    self.direction = 'left'
  elseif love.keyboard.isDown('right') and self.direction ~= 'left' then
    self.direction = 'right'
  end

  if self.timer <= self.interval then
    self.timer = self.timer + dt

    return
  end

  self.timer = self.timer + dt - self.interval

  local head = self.body[#self.body]

  local posX = head.x + DIRECTION[self.direction].x
  local posY = head.y + DIRECTION[self.direction].y

  if posX < 0 then
    posX = W_SIZE / self.size - 1
  elseif posX * self.size >= W_SIZE then
    posX = 0
  end

  if posY < 0 then
    posY = W_SIZE / self.size - 1
  elseif posY * self.size >= W_SIZE then
    posY = 0
  end

  local head = { x = posX, y = posY }

  self:eat(head, self.food)

  local newBody = {}

  for k, v in pairs(self.body) do
    if k ~= 1 then
      table.insert(newBody, v)
    elseif self.eating then
      table.insert(newBody, v)
      self.eating = false
    end
  end

  table.insert(newBody, head)
  self.body = newBody

  self:collision()
end

function Snake:eat(head, food)
  if head.x == food.x and head.y == food.y then
    self.eating = true
    self.interval = self.interval * 0.95
  end
end

function Snake:collision()
  local head = self.body[#self.body]

  for k, v in pairs(self.body) do
    if head.x == v.x
        and head.y == v.y
        and k < #self.body
    then
      self.started = false
    end
  end
end

function Snake:draw()
  love.graphics.setColor(0, 1, 0, 1)

  love.graphics.rectangle('fill',
    self.food.x * self.size + 1,
    self.food.y * self.size + 1,
    self.size - 2,
    self.size - 2
  )

  love.graphics.setColor(0.8, 0.8, 0.8, 1)

  for k, v in pairs(self.body) do
    if k == #self.body then
      love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.rectangle('fill',
      v.x * self.size + 1,
      v.y * self.size + 1,
      self.size - 2,
      self.size - 2
    )
  end

  love.graphics.setColor(1, 1, 1, 1)
end
