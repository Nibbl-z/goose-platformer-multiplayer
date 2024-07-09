local client = {}
local sock = require("modules.sock")

local geese = nil
local map = nil
local index = nil

local cameraX = 0
local cameraY = 0

local cX, cY = 0, 0

local sprites = {
    Player = "player.png",
    Lava = "lava.png",
    Finish = "finish.png",
    Checkpoint = "checkpoint.png"
}

function client:Init()
    for name, sprite in pairs(sprites) do
        sprites[name] = love.graphics.newImage("/img/"..sprite)
    end
end

function client:Join(ip, port)
    self.Client = sock.newClient(ip, port)
    
    local status, err = pcall(function() 
        self.Client:connect()
    end)
    
    print(status, err)

    if status then
        self.Client:on("index", function (data)
            index = data
        end)
        self.Client:on("game", function (data)
            geese = data.Geese
            map = data.Map
        end)

        self.Client:on("updateGeese", function (data)
            geese = data
        end)
        
        self.Client:send("connect")
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
    end

    for key, mult in pairs(movementDirections) do
        if love.keyboard.isDown(key) then
            self.Client:send("move", {
                mult = mult,
                key = key,
                dt = dt
            })
        end
    end
    
    if geese ~= nil then
        local myGoose = geese[tostring(index)]

        cX = lerp(cX, myGoose.x, 0.1)
        cY = lerp(cY, myGoose.y, 0.1)
        
        cameraX = cX - 400
        cameraY = cY - 200
    end
    
    
    self.Client:update()
end

function client:KeyPressed(key, scancode, rep)
    if self.Client == nil then return end
    if key == "space" then
        self.Client:send("jump")
    end
end

function client:Draw()
    if self.Client == nil then return end
    if geese == nil then return end
    if map == nil then return end
    love.graphics.setBackgroundColor(1,1,1,1)
    love.graphics.setColor(1,1,1,1)
    for k, goose in pairs(geese) do
        love.graphics.draw(sprites.Player, goose.x - cameraX, goose.y - cameraY, 0, goose.direction, 1, 25, 25)
    end

    for _, p in ipairs(map) do
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