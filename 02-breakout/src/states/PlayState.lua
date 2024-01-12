PlayState = Class { __includes = BaseState }

function PlayState:enter(params)
  self.health = params.health
  self.score = params.score
  self.bricks = params.bricks
  self.paddle = params.paddle
  self.ball = params.ball
  self.level = params.level
  self.highScores = params.highScores

  self.paused = false

  self.ball.dx = math.random(-200, 200)
  self.ball.dy = math.random(-50, -60)
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('space') then
    self.paused = not self.paused
    gSounds['pause']:play()
  end

  if self.paused then
    return
  end

  self.paddle:update(dt)
  self.ball:update(dt)

  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - 8
    self.ball.dy = -self.ball.dy


    if self.paddle.dx < 0 and self.ball.x < self.paddle.x + (self.paddle.width / 2) then
      self.ball.dx = -50 - (8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
    elseif self.paddle.dx > 0 and self.ball.x > self.paddle.x + (self.paddle.width / 2) then
      self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
    end

    gSounds['paddle-hit']:play()
  end

  for k, brick in pairs(self.bricks) do
    if brick.inPlay and self.ball:collides(brick) then
      self.score = self.score + (brick.tier * 200 + brick.color * 25)

      brick:hit()

      if self:checkVictory() then
        gSounds['victory']:play()

        gStateMachine:change('victory', {
          level = self.level,
          paddle = self.paddle,
          health = self.health,
          score = self.score,
          ball = self.ball,
          highScores = self.highScores
        })
      end

      if self.ball.dx > 0 and self.ball.x + 2 < brick.x then
        self.ball.dx = -self.ball.dx
        self.ball.x = brick.x - self.ball.width
      elseif self.ball.dx < 0 and self.ball.x + 6 > brick.x + brick.width then
        self.ball.dx = -self.ball.dx
        self.ball.x = brick.x + brick.width
      else
        self.ball.dy = -self.ball.dy
        self.ball.y = self.ball.y < brick.y and brick.y - self.ball.height or brick.y + brick.height
      end

      self.ball.dy = self.ball.dy * 1.02

      break
    end
  end

  if self.ball.y >= VIRTUAL_HEIGHT then
    self.health = self.health - 1
    gSounds['hurt']:play()

    if self.health == 0 then
      gStateMachine:change('game-over', {
        highScores = self.highScores,
        score = self.score
      })
    else
      gStateMachine:change('serve', {
        paddle = self.paddle,
        bricks = self.bricks,
        health = self.health,
        score = self.score,
        highScores = self.highScores,
      })
    end
  end

  for _, brick in pairs(self.bricks) do
    brick:update(dt)
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function PlayState:render()
  for _, brick in pairs(self.bricks) do
    brick:render()
  end

  for _, brick in pairs(self.bricks) do
    brick:renderParticles()
  end

  self.paddle:render()
  self.ball:render()

  renderScore(self.score)
  renderHealth(self.health)

  if self.paused then
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
  end
end

function PlayState:checkVictory()
  for _, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end

  return true
end
