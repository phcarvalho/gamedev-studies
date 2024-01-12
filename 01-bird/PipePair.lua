PipePair = Class {}

local MIN_GAP_HEIGHT = 100
local MAX_GAP_HEIGHT = 120

function PipePair:init(y)
  self.x = VIRTUAL_WIDTH + 32
  self.y = y

  self.pipes = {
    ['upper'] = Pipe('top', self.y),
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random(MIN_GAP_HEIGHT, MAX_GAP_HEIGHT))
  }

  self.remove = false

  self.scored = false
end

function PipePair:update(dt)
  if self.x + PIPE_WIDTH > 0 then
    self.x = self.x - gameSpeed * dt
    self.pipes['lower'].x = self.x
    self.pipes['upper'].x = self.x
  else
    self.remove = true
  end
end

function PipePair:render()
  for _, pipe in pairs(self.pipes) do
    pipe:render()
  end
end
