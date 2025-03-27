local data = {}

function love.load()
  data.sprite = love.graphics.newImage("assets/weapon.png")

  data.width = data.sprite:getWidth()
  data.height = data.sprite:getHeight()
  data.x = love.graphics.getWidth() / 2 - data.width / 2
  data.y = love.graphics.getHeight() / 2 - data.height / 2
  data.rotation = math.rad(0)
  data.rotationSpeed = 100
end

function love.update(dt)
  if love.mouse.isDown(1) then
    data.rotation = data.rotation + data.rotationSpeed * dt
  elseif love.mouse.isDown(2) then
    data.rotation = data.rotation - data.rotationSpeed * dt
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(
    data.sprite,
    data.x + data.width / 2,
    data.y + data.height / 2,
    data.rotation,
    data.width / 2,
    data.height / 2
  )
end

