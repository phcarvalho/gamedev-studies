PlayState = Class { __includes = BaseState }

PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
  self.bird = Bird()
  self.pipePairs = {}
  self.timer = 0
  self.nextSpawn = 2

  self.score = 0

  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('p') then
    gamePaused = not gamePaused
  end

  if gamePaused then
    return
  end

  self.timer = self.timer + dt

  if self.timer > self.nextSpawn then
    local y = math.max(-PIPE_HEIGHT + 10,
      math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
    self.lastY = y

    table.insert(self.pipePairs, PipePair(y))

    gameSpeed = gameSpeed + 5

    self.timer = 0
    self.nextSpawn = (3 + math.random() * 2) / (gameSpeed / 60)
  end

  for k, pair in pairs(self.pipePairs) do
    if not pair.scored then
      if pair.x + PIPE_WIDTH < self.bird.x then
        self.score = self.score + 1
        pair.scored = true
        sounds['score']:play()
      end
    end
    pair:update(dt)
  end

  for k, pair in pairs(self.pipePairs) do
    if pair.remove then
      table.remove(self.pipePairs, k)
    end
  end

  self.bird:update(dt)

  for k, pair in pairs(self.pipePairs) do
    for l, pipe in pairs(pair.pipes) do
      if self.bird:collides(pipe) then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
          score = self.score
        })
      end
    end
  end

  if self.bird.y > VIRTUAL_HEIGHT - 15 then
    sounds['explosion']:play()
    sounds['hurt']:play()

    gStateMachine:change('score', {
      score = self.score
    })
  end
end

function PlayState:render()
  for k, pair in pairs(self.pipePairs) do
    pair:render()
  end

  love.graphics.setFont(flappyFont)
  love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

  if gamePaused then
    love.graphics.printf('Game Paused', 0, (VIRTUAL_HEIGHT - 28) / 2, VIRTUAL_WIDTH, "center")
  end

  self.bird:render()
end

function PlayState:exit()
  gamePaused = false
end
