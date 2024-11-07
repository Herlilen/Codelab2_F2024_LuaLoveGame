-- Muscle car style
local player_1 = {
    x = 600,
    y = 300,
    radius = 18,
    triangleHeight = 15,
    rotation = -math.pi / 2, -- Default facing up
    rotationSpeed = math.rad(180), -- Rotation speed per second (in radians)
    moveSpeed = 600, -- Speed
    acceleration = 100, -- Acceleration
    deceleration = 80, -- Deceleration
    velocity = 0, -- Initial velocity
    color = {0, 255, 0}
}

-- European sports car style
local player_2 = {
    x = 200,
    y = 300,
    radius = 18,
    triangleHeight = 15,
    rotation = -math.pi / 2, -- Default facing up
    rotationSpeed = math.rad(270),
    moveSpeed = 300,
    acceleration = 100,
    deceleration = 80,
    velocity = 0,
    color = {255, 255, 255}
}

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()
    drawPlayer(player_1)
    drawPlayer(player_2)
end

function love.update(dt)
    -- Update player 1's inertia and direction control (WASD)
    updatePlayer(player_1, "w", "s", "a", "d", dt)

    -- Update player 2's inertia and direction control (Arrow keys)
    updatePlayer(player_2, "up", "down", "left", "right", dt)
end

function updatePlayer(player, upKey, downKey, leftKey, rightKey, dt)
    local movingForward = love.keyboard.isDown(upKey)
    local movingBackward = love.keyboard.isDown(downKey)
    local turningLeft = love.keyboard.isDown(leftKey)
    local turningRight = love.keyboard.isDown(rightKey)

    -- Direction control: Adjust rotation based on input
    if turningLeft then
        player.rotation = player.rotation - player.rotationSpeed * dt
    end
    if turningRight then
        player.rotation = player.rotation + player.rotationSpeed * dt
    end

    -- Forward and backward movement control: Accelerate or decelerate
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

    -- Update player's position
    player.x = player.x + math.cos(player.rotation) * player.velocity * dt
    player.y = player.y + math.sin(player.rotation) * player.velocity * dt
end

function drawPlayer(player)
    -- Set player color
    love.graphics.setColor(player.color)
    
    -- Draw circle
    love.graphics.circle("line", player.x, player.y, player.radius)

    -- Calculate triangle vertices to point upwards by default, rotating with the rotation
    local topX = player.x + math.cos(player.rotation) * (player.radius + player.triangleHeight)
    local topY = player.y + math.sin(player.rotation) * (player.radius + player.triangleHeight)
    local baseLeftX = player.x + math.cos(player.rotation + math.rad(120)) * player.radius
    local baseLeftY = player.y + math.sin(player.rotation + math.rad(120)) * player.radius
    local baseRightX = player.x + math.cos(player.rotation - math.rad(120)) * player.radius
    local baseRightY = player.y + math.sin(player.rotation - math.rad(120)) * player.radius

    -- Draw triangle direction indicator
    love.graphics.polygon("line", topX, topY, baseLeftX, baseLeftY, baseRightX, baseRightY)
end