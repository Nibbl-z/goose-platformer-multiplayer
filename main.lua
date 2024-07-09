local server = require("modules.server")
local client = require("modules.client")

function love.load()
    
end

function love.keypressed(key, scancode, rep)
    if key == "q" then
        server:Start()
    end

    if key == "e" then
        client:Init()
        client:Join("localhost", 21114)
    end

    client:KeyPressed(key, scancode, rep)
end

function love.update(dt)
    client:Update(dt)
    server:Update(dt)
end

function love.draw()
    client:Draw()
end