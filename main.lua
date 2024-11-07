-- maoh setting
local Maoh = {
    x = 400,
    y = 300,
    radius = 30,
    triangleCount = 8,
    triangleHeight = 10,
    triangleGap = 10,
    MaohRotationSpeed = 10,
    MaohMoveSpeed = 50
}

-- yusha settings
local Yusha = {
    
}

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()
    drawMaohMesh(Maoh.x, Maoh.y, Maoh.radius, 
                 Maoh.triangleCount, Maoh.triangleHeight, Maoh.triangleGap)
end

function love.update(dt)
    -- maoh control
end

function drawMaohMesh(x, y, radius, triangleCount, triangleHeight, triangleGap)
    local angleStep = (2 * math.pi) / triangleCount

    love.graphics.circle("fill", x, y, radius)

    for i = 1, triangleCount do
        local angle = (i - 1) * angleStep

        local baseAngle1 = angle + triangleGap / (2 * radius)
        local baseAngle2 = angle + angleStep - triangleGap / (2 * radius)
        local tipAngle = angle + angleStep / 2

        local baseX1 = x + math.cos(baseAngle1) * radius
        local baseY1 = y + math.sin(baseAngle1) * radius
        local baseX2 = x + math.cos(baseAngle2) * radius
        local baseY2 = y + math.sin(baseAngle2) * radius

        local tipX = x + math.cos(tipAngle) * (radius + triangleHeight)
        local tipY = y + math.sin(tipAngle) * (radius + triangleHeight)

        love.graphics.polygon("fill", baseX1, baseY1, baseX2, baseY2, tipX, tipY)
    end
end