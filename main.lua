
Timer = require 'lib/knife.timer'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
GRID_TILE_SIZE = 112
GRID_BACKGORUND_WIDTH = WINDOW_WIDTH/2 - 40
GRID_BACKGORUND_HEIGHT = WINDOW_HEIGHT - (WINDOW_HEIGHT/4) + 60
PADDING = 30

grid ={}

-- fundo
for y = 1, 4 do
    table.insert(grid,{})
    for x = 1,4 do
        table.insert(grid[y],{
            x = PADDING + WINDOW_WIDTH / 4 + (x - 1) * GRID_TILE_SIZE + (x-1) * PADDING,
            y = PADDING + WINDOW_HEIGHT / 8 + (y - 1) * GRID_TILE_SIZE + (y-1) * PADDING,
            occupied = false, tile = nil
        })
    end
end

-- movendo
tiles = {}
table.insert(tiles,
    {tileX = 1 ,tileY = 1,x = grid[1][1].x, y= grid[1][1].y,num = 2}
)
grid[1][1].occupied = true
table.insert(tiles,
    {tileX = 2 ,tileY = 1,x = grid[1][2].x, y= grid[1][2].y,num = 2}
)
grid[1][2].occupied = true


function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    love.window.setTitle('2048')
    font = love.graphics.newFont(64)
    love.graphics.setFont(font)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    -- movimento da peças
    if key == 'up' then
       moveUp()
    elseif key == 'down' then
        moveDown()
    elseif key == 'right' then
        moveRight()
    elseif key == 'left' then
       moveLeft()
    end
    
end

function love.update(dt)
    Timer.update(dt)
end

function getFarhestOpenX(startX,startY, finish)
    for x = startX + 1, finish do
        if grid[startY][x].occupied then
            return x
        end
    end
    return finish
end

function moveUp()
    for k, tile in pairs(tiles) do
        tile.tileY = 1
        Timer.tween(0.1,{
            [tile] = {x = grid[tile.tileY][tile.tileX].x ,
            y = grid[tile.tileY][tile.tileX].y}
        })
    end
end

function moveDown()
    for k, tile in pairs(tiles) do
        tile.tileY = 4
        Timer.tween(0.1,{
            [tile] = {x = grid[tile.tileY][tile.tileX].x ,
            y = grid[tile.tileY][tile.tileX].y}
        })
      
    end
end

function moveLeft()
    for k, tile in pairs(tiles) do
        tile.tileX = 1
        Timer.tween(0.1,{
            [tile] = {x = grid[tile.tileY][tile.tileX].x ,
            y = grid[tile.tileY][tile.tileX].y}
        })
    end
end

function moveRight()
    for k, tile in pairs(tiles) do
        tile.tileX = getFarhestOpenX(tile.tileX,tile.tileY,4)
        grid[tile.tileY][tile.tileX].occupied = true
        grid[tile.tileY][tile.tileX].tile = tile
        Timer.tween(0.1,{
            [tile] = {x = grid[tile.tileY][tile.tileX].x ,
            y = grid[tile.tileY][tile.tileX].y}
        })
    end
end

function love.draw()
    love.graphics.clear(250/255,250/255,238/255,1)
    love.graphics.setColor(186/255,173/255,160/255,1)
    love.graphics.rectangle('fill',
    WINDOW_WIDTH/4,
    WINDOW_HEIGHT/8,
    GRID_BACKGORUND_WIDTH,GRID_BACKGORUND_HEIGHT,10,10,3)
    --retangulos do fundo
    for y = 1, 4 do
        for x = 1,4 do
            love.graphics.setColor(205/255,192/255,181/255,1)
            love.graphics.rectangle('fill',grid[y][x].x, grid[y][x].y,
                GRID_TILE_SIZE,GRID_TILE_SIZE,5,5,3)
        end
    end
    -- retangulos com os numeros
    for k, tile in pairs(tiles) do
        love.graphics.setColor(238/255,228/255,218/255,1)
        love.graphics.rectangle('fill',tile.x,tile.y,GRID_TILE_SIZE,GRID_TILE_SIZE, 10,10,3)
        love.graphics.setColor(119/255,110/255,101/255,1)
        love.graphics.printf(tile.num,tile.x,
        tile.y + GRID_TILE_SIZE / 2 - font:getHeight()/2, GRID_TILE_SIZE,'center')
    end
end