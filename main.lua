local server = require("modules.server")
local client = require("modules.client")

local screen = require("yan.instance.ui.screen")
local imagebutton = require("yan.instance.ui.imagebutton")
local textinput = require("yan.instance.ui.textinput")

function love.load()
    menu = screen:New(nil) 
    menu.Enabled = true
    
    hostButton = imagebutton:New(nil, menu, "/img/host_btn.png")
    
    hostButton:SetPosition(1, -10, 1, -10)
    hostButton:SetSize(0.5, -20, 0.5, 0)
    hostButton:SetAnchorPoint(1,1)
    
    hostButton.MouseEnter = function ()
        hostButton:SetColor(0.7,0.7,0.7,1)
    end
    hostButton.MouseLeave = function ()
        hostButton:SetColor(1,1,1,1)
    end
    hostButton.MouseDown = function()
        server:Start()
        
        client:Init()
        client:Join("localhost", 21114)

        menu.Enabled = false
    end

    joinButton = imagebutton:New(nil, menu, "/img/join_btn.png")
    
    joinButton:SetPosition(0, 10, 1, -10)
    joinButton:SetSize(0.5, -20, 0.5, 0)
    joinButton:SetAnchorPoint(0,1)
    
    joinButton.MouseEnter = function ()
        joinButton:SetColor(0.7,0.7,0.7,1)
    end
    joinButton.MouseLeave = function ()
        joinButton:SetColor(1,1,1,1)
    end
    joinButton.MouseDown = function ()
        client:Init()
        client:Join("localhost", 21114)

        menu.Enabled = false
    end
end

function love.keypressed(key, scancode, rep)
    client:KeyPressed(key, scancode, rep)
end

function love.update(dt)
    client:Update(dt)
    server:Update(dt)

    menu:Update()
end

function love.draw()
    menu:Draw()
    love.graphics.setBackgroundColor(1,1,1,1)
    client:Draw()
    
end