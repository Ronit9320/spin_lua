function love.load()
  x = 400
  y = 300
  speed = 200
end

function love.update(dt)
  if love.mouse.isDown(1, 0) then
    print("mouse button pressed")
  end
end


function love.draw()
  love.graphics.setColor(1.0, 0, 0)
  love.graphics.rectangle("fill", x, y, 50, 50)
end
