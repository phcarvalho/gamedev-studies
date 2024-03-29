LevelMaker = Class {}

-- global patterns
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- per-row patterns
SOLID = 1
ALTERNATE = 2
SKIP = 3
NONE = 4

function LevelMaker.createMap(level)
  local bricks = {}

  local numRows = math.random(1, 5)
  local numCols = math.random(7, 13)
  numCols = numCols % 2 == 0 and (numCols + 1) or numCols

  local highestTier = math.min(3, math.floor(level / 5))
  local highestColor = math.min(5, level % 5 + 3)

  for y = 1, numRows do
    local skipPattern = math.random(2) == 1
    local alternatePattern = math.random(2) == 1

    local alternateColor1 = math.random(highestColor)
    local alternateColor2 = math.random(highestColor)
    local alternateTier1 = math.random(0, highestTier)
    local alternateTier2 = math.random(0, highestTier)

    local skipFlag = math.random(2) == 1
    local alternateFlag = math.random(2) == 1

    local solidColor = math.random(highestColor)
    local solidTier = math.random(0, highestTier)

    for x = 1, numCols do
      skipFlag = not skipFlag

      if skipPattern and skipFlag then
        goto continue
      end

      b = Brick(
        (x - 1) * 32 + 8 + (13 - numCols) * 16,
        y * 16
      )

      if alternatePattern then
        b.color = alternateFlag and alternateColor1 or alternateColor2
        b.tier = alternateFlag and alternateTier1 or alternateTier2

        alternateFlag = not alternateFlag
      else
        b.color = solidColor
        b.tier = solidTier
      end

      table.insert(bricks, b)

      ::continue::
    end
  end

  if #bricks == 0 then
    return self.createMap(level)
  end

  return bricks
end
