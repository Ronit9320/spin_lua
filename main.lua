local data = {}

function love.load()
  data.sprite = love.graphics.newImage("assets/weapon.png")
  data.width = data.sprite:getWidth()
  data.height = data.sprite:getHeight()
  data.rotation = math.rad(0)
  data.scaleX = 1
  data.scaleY = 1
  data.rotationSpeed = 100
end

function love.update(dt)
  if love.mouse.isDown(1) then
    data.rotation = data.rotation + data.rotationSpeed * dt
  elseif love.mouse.isDown(2) then
    data.rotation = data.rotation - data.rotationSpeed * dt
  end

  mousePosX, mousePosY = love.mouse.getPosition()
  -- print(mousePosX, mousePosY)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(
    data.sprite,
    mousePosX,
    mousePosY,
    data.rotation,
    data.scaleX,
    data.scaleY,
    data.width / 2,
    data.height / 2
  )
end

