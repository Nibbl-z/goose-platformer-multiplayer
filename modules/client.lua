local client = {}
local sock = require("modules.sock")

local geese = nil

local sprites = {
    Player = "player.png"
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
        self.Client:on("game", function (data)
            geese = data.Geese
        end)

        self.Client:on("updateGeese", function (data)
            geese = data
        end)

        self.Client:send("connect")
    end
    
    print(status, err)
end

local movementDirections = {a = {-1,0}, d = {1,0}}

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

    for k, goose in pairs(geese) do
        love.graphics.draw(sprites.Player, goose.x, goose.y, 0, goose.direction, 1, 25, 25)
    end
end

return client