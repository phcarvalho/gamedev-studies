EnterHighScoreState = Class { __includes = BaseState }

local chars = {
  [1] = 65,
  [2] = 65,
  [3] = 65
}

local highlightedChar = 1

function EnterHighScoreState:enter(params)
  self.highScores = params.highScores
  self.score = params.score
  self.scoreIndex = params.scoreIndex
end

function EnterHighScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

    for i = 10, self.scoreIndex, -1 do
      self.highScores[i + 1] = {
        name = self.highScores[i].name,
        score = self.highScores[i].score
      }
    end

    self.highScores[self.scoreIndex].name = name
    self.highScores[self.scoreIndex].score = self.score

    local scoresStr = ''

    for i = 1, 10 do
      scoresStr = scoresStr .. self.highScores[i].name .. '\n'
      scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
    end

    love.filesystem.write('breakout.lst', scoresStr)

    gStateMachine:change('high-scores', {
      highScores = self.highScores
    })
  end

  if love.keyboard.wasPressed('left') and highlightedChar > 1 then
    highlightedChar = highlightedChar - 1
    gSounds['select']:play()
  elseif love.keyboard.wasPressed('right') and highlightedChar < 3 then
    highlightedChar = highlightedChar + 1
    gSounds['select']:play()
  end

  if love.keyboard.wasPressed('up') then
    chars[highlightedChar] = chars[highlightedChar] + 1
    if chars[highlightedChar] > 90 then
      chars[highlightedChar] = 65
    end
  elseif love.keyboard.wasPressed('down') then
    chars[highlightedChar] = chars[highlightedChar] - 1
    if chars[highlightedChar] < 65 then
      chars[highlightedChar] = 90
    end
  end
end

function EnterHighScoreState:render()
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Your score: ' .. tostring(self.score), 0, 30, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['large'])

  if highlightedChar == 1 then
    love.graphics.setColor(103 / 255, 1, 1, 1)
  end

  local position = {
    [1] = 'left',
    [2] = 'center',
    [3] = 'right'
  }

  for i = 1, 3 do
    if i == highlightedChar then
      love.graphics.setColor(103 / 255, 1, 1, 1)
    end
    love.graphics.printf(string.char(chars[i]), VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT / 2, 60,
      position[i])
    love.graphics.setColor(1, 1, 1, 1)
  end

  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end
