local server = {}
local sock = require("modules.sock")




server.Geese = {}
server.Map = {}

local respawnDelay = {}

function server:Start(map)
    self.Server = sock.newServer("*", 21114)
   --[[ self.World = love.physics.newWorld(0, 1000, true)
    
    mapLoader:Init(self.World)
    mapLoader:Load("test.goose")]]
    
    

    love.filesystem.setIdentity("goose-platformer-multiplayer")
    self.Map = love.filesystem.read("test.goose")
    
   -- self.World:setCallbacks(beginContact, endContact)
    
    self.Server:on("connect", function (data, client)
        print("Player"..tostring(client:getIndex()).." has joined")
        
        self.Geese[tostring(client:getIndex())] = {
            x = 200,
            y = 0,
            direction = 1,
            id = client:getIndex()
        }

        client:send("index", client:getIndex())
    end)
    
    self.Server:on("updatePosition", function (data, client)
        local goose = self.Geese[tostring(client:getIndex())]
        
        goose.x = data.x 
        goose.y = data.y
        goose.direction = data.direction
    end)


    self.Server:on("getGame", function (data, client)
        client:send("game", {
            Geese = self.Geese,
            Map = self.Map
        })
    end)

    print("Server started!")
end

function server:Update(dt)
    if self.Server == nil then return end
    
    self.Server:sendToAll("updateGeese", self.Geese)
    self.Server:update()
end

return server