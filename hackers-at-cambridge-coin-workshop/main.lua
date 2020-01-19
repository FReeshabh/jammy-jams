require "collision"

function love.load()
    math.randomseed(os.time())
    player = {}
    player.x = 50
    player.y = 300
    player.w = 85
    player.h = 100

    coins = {}
    score = 0
    
    sounds = {}
    sounds.coin = love.audio.newSource("/assets/coin.ogg", "static")
    sounds.theme = love.audio.newSource("/assets/music.ogg", "static")

    fonts = {}
    fonts.large = love.graphics.newFont("/assets/gamer.ttf", 36)

    images = {}
    images.background = love.graphics.newImage("/assets/ground.png")
    images.coin = love.graphics.newImage("/assets/coin.png")
    images.player_down = love.graphics.newImage("/assets/player_down.png")
    images.player_up = love.graphics.newImage("/assets/player_up.png")
    images.player_right = love.graphics.newImage("/assets/player_right.png")
    images.player_left = love.graphics.newImage("/assets/player_left.png")


end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + 5
        player.direction = "right"
    elseif love.keyboard.isDown("left") then
        player.x = player.x - 5
        player.direction = "left"
    elseif love.keyboard.isDown("up") then 
        player.y = player.y - 4
        player.direction = "up"
    elseif love.keyboard.isDown("down") then
        player.y = player.y + 4
        player.direction = "down"
    end

    for i=#coins,1,-1 do
        local coin = coins[i]
        if AABB(player.x, player.y, player.w, player.h, coin.x, coin.y, coin.w, coin.h) then
            table.remove(coins, i)
            score = score + 1
            sounds.coin:play()
        end
    end

    if math.random() < 0.01 then
        local coin = {}
        coin.w = 56
        coin.h = 56
        coin.x = math.random(0, 800 - coin.w)
        coin.y = math.random(0, 600 - coin.h)
        table.insert(coins, coin)
    end


    end

function love.draw()
    love.audio.play(sounds.theme)
    for x=0, love.graphics.getWidth(), images.background:getWidth() do
        for y=0, love.graphics.getHeight(), images.background:getHeight() do
            love.graphics.draw(images.background, x, y)
        end

    end
    
    local img = images.player_down
    if player.direction == "right" then
        img = images.player_right
    elseif player.direction == "left" then
        img = images.player_left
    elseif player.direction == "down" then
        img = images.player_down
    elseif player.direction == "up" then
        img = images.player_up

    end

    -- love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    love.graphics.draw(img, player.x, player.y)

    for i=#coins,1,-1 do
        local coin = coins[i]
        love.graphics.draw(images.coin, coin.x, coin.y)
    end

    love.graphics.setFont(fonts.large)
    love.graphics.print("SCORE: " .. score, 10, 10)


end 
