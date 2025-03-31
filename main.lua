local data = {}
local obstacles = {}

function love.load()
  -- Sprite data
  data.sprite = love.graphics.newImage("assets/weapon.png")
  data.width = data.sprite:getWidth()
  data.height = data.sprite:getHeight()
  data.x = love.graphics.getWidth() / 2
  data.y = love.graphics.getHeight() / 2
  data.scaleX = 1
  data.scaleY = 1

  -- Movement properties
  data.maxSpeed = 500
  data.minSpeed = 50
  data.easeDistance = 200

  -- Rotation properties - increased speed and added smoothing
  data.rotation = math.rad(0)
  data.targetRotation = data.rotation
  data.rotationSpeed = 300    -- Increased from 100
  data.rotationSmoothing = 10 -- Higher = more responsive

  -- Weapon properties
  data.damage = 25
  data.attackCooldown = 0.5 -- seconds
  data.lastAttackTime = 0
  data.hitboxRadius = math.min(data.width, data.height) / 3

  -- Create random obstacles
  for i = 1, 10 do
    local obstacle = {
      x = love.math.random(50, love.graphics.getWidth() - 50),
      y = love.math.random(50, love.graphics.getHeight() - 50),
      radius = love.math.random(20, 50),
      health = 100,
      maxHealth = 100,
      color = { love.math.random(), love.math.random(), love.math.random() },
      hit = false,
      hitTimer = 0
    }
    table.insert(obstacles, obstacle)
  end
end

function love.update(dt)
  -- Get mouse position
  mousePosX, mousePosY = love.mouse.getPosition()

  -- Smooth rotation handling
  if love.mouse.isDown(1) then
    data.targetRotation = data.targetRotation + data.rotationSpeed * dt
  elseif love.mouse.isDown(2) then
    data.targetRotation = data.targetRotation - data.rotationSpeed * dt
  end

  -- Apply smooth rotation
  local rotDiff = data.targetRotation - data.rotation
  data.rotation = data.rotation + rotDiff * math.min(dt * data.rotationSmoothing, 1)

  -- Calculate distance to mouse
  local dx = mousePosX - data.x
  local dy = mousePosY - data.y
  local distance = math.sqrt(dx * dx + dy * dy)

  -- Move sprite toward mouse
  if distance > 1 then
    -- Normalize direction vector
    local dirX = dx / distance
    local dirY = dy / distance

    -- Calculate speed based on distance
    local speed
    if distance > data.easeDistance then
      speed = data.maxSpeed
    else
      local t = distance / data.easeDistance
      speed = data.minSpeed + (data.maxSpeed - data.minSpeed) * t
    end

    -- Calculate potential new position
    local newX = data.x + dirX * speed * dt
    local newY = data.y + dirY * speed * dt

    -- Check for collisions
    local collided = false
    for _, obstacle in ipairs(obstacles) do
      if obstacle.health > 0 then
        local obstacleDistance = math.sqrt((newX - obstacle.x) ^ 2 + (newY - obstacle.y) ^ 2)
        if obstacleDistance < data.hitboxRadius + obstacle.radius then
          collided = true

          -- Attack obstacle if cooldown has passed
          local currentTime = love.timer.getTime()
          if currentTime - data.lastAttackTime > data.attackCooldown then
            obstacle.health = math.max(0, obstacle.health - data.damage)
            data.lastAttackTime = currentTime
            obstacle.hit = true
            obstacle.hitTimer = 0.2

            -- If obstacle is destroyed
            if obstacle.health <= 0 then
              obstacle.color = { 0.5, 0.5, 0.5 } -- Change color to gray when destroyed
            end
          end
          break
        end
      end
    end

    -- Only update position if no collision
    if not collided then
      data.x = newX
      data.y = newY
    end
  end

  -- Update hit flash timers
  for _, obstacle in ipairs(obstacles) do
    if obstacle.hitTimer > 0 then
      obstacle.hitTimer = obstacle.hitTimer - dt
      if obstacle.hitTimer <= 0 then
        obstacle.hit = false
      end
    end
  end
end

function love.draw()
  -- Draw obstacles
  for _, obstacle in ipairs(obstacles) do
    -- Draw health bar
    if obstacle.health > 0 then
      -- Background
      love.graphics.setColor(0.3, 0.3, 0.3)
      love.graphics.rectangle("fill", obstacle.x - 30, obstacle.y - obstacle.radius - 15, 60, 8)

      -- Health bar
      local healthPercent = obstacle.health / obstacle.maxHealth
      local healthColor = {
        2 * (1 - healthPercent), -- Red increases as health decreases
        2 * healthPercent,       -- Green decreases as health decreases
        0                        -- No blue
      }
      love.graphics.setColor(healthColor)
      love.graphics.rectangle("fill", obstacle.x - 30, obstacle.y - obstacle.radius - 15, 60 * healthPercent, 8)
    end

    -- Draw obstacle
    if obstacle.hit then
      love.graphics.setColor(1, 1, 1) -- Flash white when hit
    else
      love.graphics.setColor(obstacle.color)
    end
    love.graphics.circle("fill", obstacle.x, obstacle.y, obstacle.radius)
  end

  -- Draw weapon sprite
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    data.sprite,
    data.x,
    data.y,
    data.rotation,
    data.scaleX,
    data.scaleY,
    data.width / 2,
    data.height / 2
  )

  -- Debug: draw hitbox
  -- love.graphics.setColor(1, 0, 0, 0.3)
  -- love.graphics.circle("line", data.x, data.y, data.hitboxRadius)
end

-- Add additional controls
function love.keypressed(key)
  if key == "r" then
    -- Reset obstacles
    for _, obstacle in ipairs(obstacles) do
      obstacle.health = obstacle.maxHealth
      obstacle.color = { love.math.random(), love.math.random(), love.math.random() }
    end
  end
end
