local screenWidth, screenHeight = 800, 600 -- Canvas dimensions
local borderThickness = 2 -- Thickness of the green border

-- Muscle car style player 1 properties
local player_1 = {
    x = 600,
    y = 300,
    radius = 18, -- Radius of player
    triangleHeight = 15, -- Height of the directional triangle
    rotation = -math.pi / 2, -- Initial rotation (facing up)
    rotationSpeed = math.rad(180), -- Rotation speed in radians per second
    moveSpeed = 600, -- Maximum movement speed
    acceleration = 100, -- Acceleration rate
    deceleration = 80, -- Deceleration rate
    velocity = 0, -- Initial velocity
    color = {0, 255, 0}, -- Player color (green)
    originalColor = {0, 255, 0}, -- Original color for resetting after collision
    hitTimer = 0, -- Timer for collision color effect
    health = 100, -- Player health
    baseDamage = 10, -- Base damage for collision
    score = 0, -- Player score
}

-- European sports car style player 2 properties
local player_2 = {
    x = 200,
    y = 300,
    radius = 18,
    triangleHeight = 15,
    rotation = -math.pi / 2,
    rotationSpeed = math.rad(270),
    moveSpeed = 300,
    acceleration = 100,
    deceleration = 80,
    velocity = 0,
    color = {255, 255, 255}, -- White color
    originalColor = {255, 255, 255},
    hitTimer = 0,
    health = 100,
    baseDamage = 10,
    score = 0,
}


local collisionDuration = 1 -- Duration for player to stay red after collision
local repulsionForce = 2000 -- Force applied to separate players on collision

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0) -- Set background color to black
end

function love.draw()
    -- Draw a green border around the canvas
    love.graphics.setColor(0, 255, 0) -- Set color to green
    love.graphics.setLineWidth(borderThickness) -- Set border thickness
    love.graphics.rectangle("line", borderThickness / 2, borderThickness / 2, screenWidth - borderThickness, screenHeight - borderThickness)

    -- Draw both players
    love.graphics.setLineWidth(1) -- Reset line width for players
    drawPlayer(player_1)
    drawPlayer(player_2)
end

function love.update(dt)
    -- Update both players' movement and boundary restrictions
    updatePlayer(player_1, "w", "s", "a", "d", dt)
    updatePlayer(player_2, "up", "down", "left", "right", dt)
    
    -- Check for collisions between players in both directions
    checkCollision(player_1, player_2, dt)
    checkCollision(player_2, player_1, dt)

    -- drawPlayer score
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Player 1: " .. player_1.score, 10, 10)
    love.graphics.print("Player 2: " .. player_2.score, 10, 30)

end

-- Detects if "R" is pressed and resets players if so
function love.keypressed(key)
    if key == "r" then
        resetPlayers()
    end
end


-- Resets players to initial positions, colors, and velocity
function resetPlayers()
    player_1.x, player_1.y = 600, 300
    player_1.velocity = 0
    player_1.color = player_1.originalColor
    player_1.hitTimer = 0
    player_1.health = 100

    player_2.x, player_2.y = 200, 300
    player_2.velocity = 0
    player_2.color = player_2.originalColor
    player_2.hitTimer = 0
    player_2.health = 100
end


-- Updates player position, rotation, speed, and boundary restrictions
function updatePlayer(player, upKey, downKey, leftKey, rightKey, dt)
    local movingForward = love.keyboard.isDown(upKey)
    local movingBackward = love.keyboard.isDown(downKey)
    local turningLeft = love.keyboard.isDown(leftKey)
    local turningRight = love.keyboard.isDown(rightKey)

    -- Handle rotation based on player input
    if turningLeft then
        player.rotation = player.rotation - player.rotationSpeed * dt
    end
    if turningRight then
        player.rotation = player.rotation + player.rotationSpeed * dt
    end

    -- Handle forward/backward movement with acceleration and deceleration
    if movingForward then
        player.velocity = math.min(player.velocity + player.acceleration * dt, player.moveSpeed)
    elseif movingBackward then
        player.velocity = math.max(player.velocity - player.acceleration * dt, -player.moveSpeed / 2)
    else
        if player.velocity > 0 then
            player.velocity = math.max(player.velocity - player.deceleration * dt, 0)
        elseif player.velocity < 0 then
            player.velocity = math.min(player.velocity + player.deceleration * dt, 0)
        end
    end

    -- Update player position
    player.x = player.x + math.cos(player.rotation) * player.velocity * dt
    player.y = player.y + math.sin(player.rotation) * player.velocity * dt

    -- Boundary detection to keep players within the canvas
    if player.x - player.radius < 0 then
        player.x = player.radius
    elseif player.x + player.radius > screenWidth then
        player.x = screenWidth - player.radius
    end

    if player.y - player.radius < 0 then
        player.y = player.radius
    elseif player.y + player.radius > screenHeight then
        player.y = screenHeight - player.radius
    end

    -- Restore player color after collision timer expires
    if player.hitTimer > 0 then
        player.hitTimer = player.hitTimer - dt
        if player.hitTimer <= 0 then
            player.color = player.originalColor
        end
    end

    
end

-- Draws player with circle and triangle direction indicator
function drawPlayer(player)
    love.graphics.setColor(player.color)
    love.graphics.circle("line", player.x, player.y, player.radius)

    -- Calculate vertices for the player's triangle direction indicator
    local topX = player.x + math.cos(player.rotation) * (player.radius + player.triangleHeight)
    local topY = player.y + math.sin(player.rotation) * (player.radius + player.triangleHeight)
    local baseLeftX = player.x + math.cos(player.rotation + math.rad(120)) * player.radius
    local baseLeftY = player.y + math.sin(player.rotation + math.rad(120)) * player.radius
    local baseRightX = player.x + math.cos(player.rotation - math.rad(120)) * player.radius
    local baseRightY = player.y + math.sin(player.rotation - math.rad(120)) * player.radius

    love.graphics.polygon("line", topX, topY, baseLeftX, baseLeftY, baseRightX, baseRightY)
    --drawHealth
    love.graphics.setColor(2550, 255, 255)
    love.graphics.print(math.ceil(player.health), player.x - 10, player.y - 10)
    
end

-- Checks if playerA's triangle tip collides with playerB's circle, triggers color change and repulsion if so
function checkCollision(playerA, playerB, dt)
    -- Calculate position of playerA's triangle tip
    local topX = playerA.x + math.cos(playerA.rotation) * (playerA.radius + playerA.triangleHeight)
    local topY = playerA.y + math.sin(playerA.rotation) * (playerA.radius + playerA.triangleHeight)

    -- Calculate distance from playerA's triangle tip to playerB's center
    local dxTop = playerB.x - topX
    local dyTop = playerB.y - topY
    local distanceToTop = math.sqrt(dxTop * dxTop + dyTop * dyTop)

    -- Check for collision at triangle tip and apply color change and repulsion
    if distanceToTop < playerB.radius then
        playerB.color = {255, 0, 0}
        playerB.hitTimer = collisionDuration

        local separationX = (dxTop / distanceToTop) * repulsionForce * dt
        local separationY = (dyTop / distanceToTop) * repulsionForce * dt

        playerA.x = playerA.x - separationX
        playerA.y = playerA.y - separationY
        playerB.x = playerB.x + separationX
        playerB.y = playerB.y + separationY

        local damage = math.abs(playerA.baseDamage * (dxTop / distanceToTop))

    
        playerB.health = playerB.health - damage

        if playerB.health < 0 then
            playerA.score = playerA.score + 1
            resetPlayers()
        end

    else
        -- Check for circle overlap to prevent overlapping (no color change or repulsion)
        local dxCircle = playerB.x - playerA.x
        local dyCircle = playerB.y - playerA.y
        local distanceBetweenCenters = math.sqrt(dxCircle * dxCircle + dyCircle * dyCircle)

        if distanceBetweenCenters < playerA.radius + playerB.radius then
            local overlap = (playerA.radius + playerB.radius) - distanceBetweenCenters
            local separationX = (dxCircle / distanceBetweenCenters) * overlap / 2
            local separationY = (dyCircle / distanceBetweenCenters) * overlap / 2

            playerA.x = playerA.x - separationX
            playerA.y = playerA.y - separationY
            playerB.x = playerB.x + separationX
            playerB.y = playerB.y + separationY
        end
    end
end