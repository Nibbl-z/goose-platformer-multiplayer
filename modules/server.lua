local server = {}
local sock = require("modules.sock")

local physicsInstance = require("yan.instance.physics_instance")

server.Geese = {}
server.Map = {}

function server:Start(map)
    self.Server = sock.newServer("*", 21114)
    self.World = love.physics.newWorld(0, 1000, true)
    
    local ground = physicsInstance:New(
        nil,
        self.World,
        "static",
        "rectangle",
        {X = 30000, Y = 50},
        0,
        1
    )
    
    ground.body:setY(400)

    self.Server:on("connect", function (data, client)
        print("Player"..tostring(client:getIndex()).." has joined")
    
        self.Geese[tostring(client:getIndex())] = physicsInstance:New(
            nil,
            self.World,
            "dynamic",
            "rectangle",
            {X = 50, Y = 50},
            0,
            1
        )

        local goose = self.Geese[tostring(client:getIndex())]
        
        goose.direction = 1
        goose.onGround = false
        goose.speed = 5000
        goose.maxSpeed = 400
        goose.jumpHeight = 1500
    end)
    
    self.Server:on("move", function (data, client)
        local goose = self.Geese[tostring(client:getIndex())]
        
        if #goose.body:getContacts() >= 1 then
            goose.onGround = true
        end
    
        local impulseX = 0
        local impulseY = 0
            
        impulseX = goose.speed * data.mult[1] * data.dt
        
        if data.key == "a" then
            goose.direction = 1
        elseif data.key == "d" then
            goose.direction = -1
        end
        
        if not goose.disableMovement then 
            goose:ApplyLinearImpulse(impulseX, impulseY, goose.maxSpeed, math.huge)
        end
    end)

    self.Server:on("getGame", function (data, client)
        local geeseSimplified = {}

        for k, goose in pairs(self.Geese) do
            goose:Update()
            
            geeseSimplified[k] = {
                x = goose.body:getX(),
                y = goose.body:getY(),
                direction = goose.direction,
            }
        end
        
        client:send("game", {
            Geese = geeseSimplified
        })
    end)

    print("Server started!")
end

function server:Update(dt)
    if self.Server == nil then return end

    local geeseSimplified = {}

    for k, goose in pairs(self.Geese) do
        goose:Update()
        
        geeseSimplified[k] = {
            x = goose.body:getX(),
            y = goose.body:getY(),
            direction = goose.direction,
        }

        print(k, goose.body:getY())
    end
    
    self.Server:sendToAll("updateGeese", geeseSimplified)
    self.Server:update()
    self.World:update(dt)
end

return server