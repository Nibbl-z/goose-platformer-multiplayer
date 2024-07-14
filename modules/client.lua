local client = {}
local sock = require("modules.sock")
local mapLoader = require("modules.mapLoader")

local geese = nil
local geesePhysics = {}
local mapData = nil
local mapPhysics = {}
local index = nil

local cameraX = 0
local cameraY = 0
local username = ""
local cX, cY = 0, 0

local sprites = {
    Player = "player.png",
    Lava = "lava.png",
    Finish = "finish.png",
    Checkpoint = "checkpoint.png"
}

local physicsInstance = require("yan.instance.physics_instance")

local pingInterval = love.timer.getTime()

function client:Init()
    for name, sprite in pairs(sprites) do
        sprites[name] = love.graphics.newImage("/img/"..sprite)
    end

    usernameFont = love.graphics.newFont(14)
    love.graphics.setFont(usernameFont)
end

function client:Join(ip, port, name)
    self.Client = sock.newClient(ip, port)
    
    local status, err = pcall(function() 
        self.Client:connect()
    end)
    
    print(status, err)

    if status then
        username = name

        pingInterval = love.timer.getTime() + 1

        self.Client:on("index", function (data)
            index = data
        end)
        self.Client:on("game", function (data)
            geese = data.Geese
            mapData = mapLoader:GooseToTable(data.Map)
            
            mapLoader:Load(mapData)
        end)

        self.Client:on("updateGeese", function (data)
            geese = data

            for _, g in pairs(geese) do
                if g.id ~= index then 
                    if geesePhysics[g.id] == nil then
                        geesePhysics[g.id] = physicsInstance:New(
                            nil,
                            world,
                            "dynamic",
                            "rectangle",
                            {X = 50, Y = 50},
                            0,
                            1
                        )
                    end
                    
                    geesePhysics[g.id].body:setX(g.x)
                    geesePhysics[g.id].body:setY(g.y)
                end
            end
        end)
        
        self.Client:on("disconnect", function (data)
            geesePhysics[tonumber(data)] = nil
        end)
        
        

        world = love.physics.newWorld(0, 1000, true)
        mapLoader:Init(world)
        goose = physicsInstance:New(
            nil,
            world,
            "dynamic",
            "rectangle",
            {X = 50, Y = 50},
            0,
            1
        )

        goose.body:setX(200)
        goose.direction = 1
        goose.onGround = false
        goose.speed = 5000
        goose.maxSpeed = 400
        goose.jumpHeight = 1500
    end
    
    print(status, err)
end

local movementDirections = {a = {-1,0}, d = {1,0}}

local function lerp(a, b, t)
    return t < 0.5 and a + (b - a) * t or b + (a - b) * (1 - t)
end

function client:Update(dt)
    if self.Client == nil then return end
    
    if geese == nil then
        self.Client:send("getGame")
        
        self.Client:send("setUsername", username)
    end

    for key, mult in pairs(movementDirections) do
        if love.keyboard.isDown(key) then
            local impulseX = 0
            local impulseY = 0
                
            impulseX = goose.speed * mult[1] * dt
            
            if key == "a" then
                goose.direction = 1
            elseif key == "d" then
                goose.direction = -1
            end
            
            if not goose.disableMovement then 
                goose:ApplyLinearImpulse(impulseX, impulseY, goose.maxSpeed, math.huge)
            end
        end
    end

    cX = lerp(cX, goose.body:getX(), 0.1)
    cY = lerp(cY, goose.body:getY(), 0.1)
    
    cameraX = cX - 400
    cameraY = cY - 200

    self.Client:send("updatePosition", {
        x = goose.body:getX(),
        y = goose.body:getY(),
        direction = goose.direction
    })
    
    if love.timer.getTime() > pingInterval then
        self.Client:send("ping")
        pingInterval = love.timer.getTime() + 1
    end
    
    world:update(dt)
    self.Client:update()
end

function client:KeyPressed(key, scancode, rep)
    if self.Client == nil then return end
    if key == "space" then
        if #goose.body:getContacts() >= 1 then
            goose:ApplyLinearImpulse(0, -goose.jumpHeight, goose.maxSpeed, math.huge)
        end
    end
end

function client:Draw()
    if self.Client == nil then return end
    if geese == nil then return end
    if mapData == nil then return end
    love.graphics.setBackgroundColor(1,1,1,1)
    love.graphics.setColor(1,1,1,1)
    
    for k, g in pairs(geese) do
        if g.id ~= index then
            love.graphics.draw(sprites.Player, g.x - cameraX, g.y - cameraY, 0, g.direction, 1, 25, 25)
            love.graphics.setColor(0,0,0,0.5)
            print(g.username)
            love.graphics.printf(g.username, g.x - cameraX - 100, g.y - cameraY - 50, 200, "center")
            love.graphics.setColor(1,1,1,1)
        end
    end
    
    --[[for k, g in pairs(geesePhysics) do
        love.graphics.setColor(0,0,1,1)
        print(g.body:getX(), g.body:getY())
        love.graphics.rectangle("line", g.body:getX() - cameraX - 25, g.body:getY() - cameraY - 25, 50, 50)
    end]]
    
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.draw(sprites.Player, goose.body:getX() - cameraX, goose.body:getY() - cameraY, 0, goose.direction, 1, 25, 25)

    for _, p in ipairs(mapData) do
        if p.T == 1 then
            love.graphics.setColor(p.R, p.G, p.B, 1)
            love.graphics.rectangle("fill", p.X - cameraX, p.Y - cameraY, p.W, p.H, 10, 10)
        elseif p.T == 2 then
            love.graphics.setColor(1,1,1, 1)
            love.graphics.draw(sprites.Lava, p.X - cameraX, p.Y - cameraY, 0, p.W/ 100, p.H / 100)
        elseif p.T == 3 then
            love.graphics.setColor(1,1,1, 1)
            love.graphics.draw(sprites.Checkpoint, p.X - cameraX, p.Y - cameraY, 0, 1, 1, 12.5, 25)
        elseif p.T == 4 then
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(sprites.Finish, p.X - cameraX, p.Y - cameraY)
        end
    end
end

return client