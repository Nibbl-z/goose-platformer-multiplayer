local server = require("modules.server")
local client = require("modules.client")

function love.load()
    
end

function love.keypressed(key)
    if key == "q" then
        server:Start()
    end

    if key == "e" then
        client:Init()
        client:Join("localhost", 21114)
    end
end

function love.update(dt)
    client:Update(dt)
    server:Update(dt)
end

function love.draw()
    client:Draw()
end