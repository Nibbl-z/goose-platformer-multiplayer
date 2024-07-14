local server = require("modules.server")
local client = require("modules.client")

local screen = require("yan.instance.ui.screen")
local imagebutton = require("yan.instance.ui.imagebutton")
local textbutton = require("yan.instance.ui.textbutton")
local textinput = require("yan.instance.ui.textinput")

function love.load()
    menu = screen:New(nil) 
    menu.Enabled = true
    
    hostButton = imagebutton:New(nil, menu, "/img/host_btn.png")
    
    hostButton:SetPosition(1, -10, 0, 80)
    hostButton:SetSize(0.5, -20, 0.5, 0)
    hostButton:SetAnchorPoint(1,0)
    
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
    
    joinButton:SetPosition(0, 10, 0, 80)
    joinButton:SetSize(0.5, -20, 0.5, 0)
    joinButton:SetAnchorPoint(0,0)
    
    joinButton.MouseEnter = function ()
        joinButton:SetColor(0.7,0.7,0.7,1)
    end
    joinButton.MouseLeave = function ()
        joinButton:SetColor(1,1,1,1)
    end
    joinButton.MouseDown = function ()
        --[[]]

        joinOptionsScreen.Enabled = true
    end

    joinOptionsScreen = screen:New(nil)

    ipInput = textinput:New(nil, joinOptionsScreen, "Enter server IP", 32)
    ipInput:SetPosition(0,10,0.5,90)
    ipInput:SetSize(1,-20,0.1,0)
    ipInput:SetColor(0.8, 0.8, 0.8, 1)
    ipInput:SetTextColor(0,0,0,1)
    ipInput:SetAnchorPoint(0,0)
    ipInput:SetPlaceholderTextColor(0.5,0.5,0.5,1)

    ipInput.MouseDown = function ()
        ipInput:SetColor(0.6, 0.6, 0.6,1)
    end
    
    ipInput.MouseEnter = function ()
        ipInput:SetColor(0.7, 0.7, 0.7,1)
    end
    
    ipInput.MouseLeave = function ()
        ipInput:SetColor(0.8,0.8,0.8,1)
    end

    usernameInput = textinput:New(nil, joinOptionsScreen, "Enter username", 32)
    usernameInput:SetPosition(0,10,0.6,100)
    usernameInput:SetSize(1,-20,0.1,0)
    usernameInput:SetColor(0.8, 0.8, 0.8, 1)
    usernameInput:SetTextColor(0,0,0,1)
    usernameInput:SetAnchorPoint(0,0)
    usernameInput:SetPlaceholderTextColor(0.5,0.5,0.5,1)
    
    usernameInput.MouseDown = function ()
        usernameInput:SetColor(0.6, 0.6, 0.6,1)
    end
    
    usernameInput.MouseEnter = function ()
        usernameInput:SetColor(0.7, 0.7, 0.7,1)
    end
    
    usernameInput.MouseLeave = function ()
        usernameInput:SetColor(0.8,0.8,0.8,1)
    end
    
    confirmJoin = textbutton:New(nil, joinOptionsScreen, "Join Server", 32, "center", "center")
    confirmJoin:SetPosition(0,10,0.7,110)
    confirmJoin:SetSize(1,-20,0.1,0)
    confirmJoin:SetButtonColor(0.8, 0.8, 0.8, 1)
    confirmJoin:SetColor(0,0,0,1)
    confirmJoin:SetAnchorPoint(0,0)
    
    confirmJoin.MouseDown = function ()
        confirmJoin:SetButtonColor(0.6, 0.6, 0.6, 1)

        client:Init()
        client:Join(ipInput.Text, 21114)

        menu.Enabled = false
        joinOptionsScreen.Enabled = false
    end
    
    confirmJoin.MouseEnter = function ()
        confirmJoin:SetButtonColor(0.7, 0.7, 0.7,1)
    end
    
    confirmJoin.MouseLeave = function ()
        confirmJoin:SetButtonColor(0.8,0.8,0.8,1)
    end
end

function love.keypressed(key, scancode, rep)
    client:KeyPressed(key, scancode, rep)
    ipInput:KeyPressed(key, scancode, rep)
    usernameInput:KeyPressed(key, scancode, rep)
end

function love.update(dt)
    client:Update(dt)
    server:Update(dt)

    menu:Update()
    joinOptionsScreen:Update()

    
end

function love.textinput(t)
    ipInput:TextInput(t)
    usernameInput:TextInput(t)
end

function love.draw()
    menu:Draw()
    joinOptionsScreen:Draw()
    love.graphics.setBackgroundColor(1,1,1,1)
    client:Draw()
    
end