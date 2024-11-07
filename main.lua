local player_1 = {
    x = 600,
    y = 300,
    radius = 18,
    triangleHeight = 15,
    rotationSpeed = 10,
    moveSpeed = 50,
    color = {0, 255, 0}
}

local player_2 = {
    x = 200,
    y = 300,
    radius = 18,
    triangleHeight = 15,
    rotationSpeed = 10,
    moveSpeed = 50,
    color = {255, 255, 255}
}

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()
    -- draw player 1
    drawPlayer(player_1.x, player_1.y, player_1.radius, player_1.triangleHeight, player_1.color)
    -- draw player 2
    drawPlayer(player_2.x, player_2.y, player_2.radius, player_2.triangleHeight, player_2.color)
end

function love.update(dt)
    -- maoh control
        -- Player 1 controls (WASD)
        if love.keyboard.isDown("w") then
            player_1.y = player_1.y - player_1.moveSpeed * dt
        end
        if love.keyboard.isDown("s") then
            player_1.y = player_1.y + player_1.moveSpeed * dt
        end
        if love.keyboard.isDown("a") then
            player_1.x = player_1.x - player_1.moveSpeed * dt
        end
        if love.keyboard.isDown("d") then
            player_1.x = player_1.x + player_1.moveSpeed * dt
        end
    
        -- Player 2 controls (Arrow keys)
        if love.keyboard.isDown("up") then
            player_2.y = player_2.y - player_2.moveSpeed * dt
        end
        if love.keyboard.isDown("down") then
            player_2.y = player_2.y + player_2.moveSpeed * dt
        end
        if love.keyboard.isDown("left") then
            player_2.x = player_2.x - player_2.moveSpeed * dt
        end
        if love.keyboard.isDown("right") then
            player_2.x = player_2.x + player_2.moveSpeed * dt
        end
end

function drawPlayer(x, y, radius, triangleHeight, color)
    -- set player color 
    love.graphics.setColor(color)
    
    love.graphics.circle("line", x, y, radius)

    -- Calculate triangle points
    local topX = x
    local topY = y - radius - triangleHeight
    local baseLeftX = x - radius + 5
    local baseLeftY = y - 10
    local baseRightX = x + radius - 5
    local baseRightY = y - 10

    -- Draw the triangular part of the droplet
    love.graphics.polygon("line", topX, topY, baseLeftX, baseLeftY, baseRightX, baseRightY)
end