local server = require("modules.server")
local client = require("modules.client")

local screen = require("yan.instance.ui.screen")
local imagebutton = require("yan.instance.ui.imagebutton")
local textbutton = require("yan.instance.ui.textbutton")
local textinput = require("yan.instance.ui.textinput")
local guiBase = require("yan.instance.ui.guibase")
local label = require("yan.instance.ui.label")

local levelList = {}
local currentLevel = 1

function RefreshLevels()
    love.filesystem.setIdentity("goose-platformer-multiplayer")
            
    levelList = {}
    
    for _, v in ipairs(love.filesystem.getDirectoryItems("")) do
        if v:match("^.+(%..+)$") == ".goose" then
            table.insert(levelList, v)
        end
    end
end

function BackToMenu()
    menu.Enabled = true
end

function love.load()
    RefreshLevels()

    menu = screen:New(nil) 
    menu.Enabled = true
    
    hostButton = imagebutton:New(nil, menu, "/img/host_btn.png")
    
    hostButton:SetPosition(1, -10, 0, 80)
    hostButton:SetSize(0.5, -20, 0.5, 0)
    hostButton:SetAnchorPoint(1,0)
    
    hostButton.MouseEnter = function ()
        if hostOptionsScreen.Enabled == false then
            hostButton:SetColor(0.7,0.7,0.7,1)
        end
    end
    hostButton.MouseLeave = function ()
        if hostOptionsScreen.Enabled == false then
            hostButton:SetColor(1,1,1,1)
        end
    end
    hostButton.MouseDown = function()
        hostButton:SetColor(0.5,0.5,0.5,1)

        hostOptionsScreen.Enabled = true
        joinOptionsScreen.Enabled = false
        --[[server:Start()
        
        client:Init()
        client:Join("localhost", 21114)]

        menu.Enabled = false]]
    end

    joinButton = imagebutton:New(nil, menu, "/img/join_btn.png")
    
    joinButton:SetPosition(0, 10, 0, 80)
    joinButton:SetSize(0.5, -20, 0.5, 0)
    joinButton:SetAnchorPoint(0,0)
    
    joinButton.MouseEnter = function ()
        if joinOptionsScreen.Enabled == false then
            joinButton:SetColor(0.7,0.7,0.7,1)
        end
        
    end
    joinButton.MouseLeave = function ()
        if joinOptionsScreen.Enabled == false then
            joinButton:SetColor(1,1,1,1)
        end
    end
    joinButton.MouseDown = function ()
        joinButton:SetColor(0.5,0.5,0.5,1)
        joinOptionsScreen.Enabled = true
        hostOptionsScreen.Enabled = false
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

        client:Init(BackToMenu)
        client:Join(ipInput.Text, 21114, usernameInput.Text)

        menu.Enabled = false
        joinOptionsScreen.Enabled = false
    end
    
    confirmJoin.MouseEnter = function ()
        confirmJoin:SetButtonColor(0.7, 0.7, 0.7,1)
    end
    
    confirmJoin.MouseLeave = function ()
        confirmJoin:SetButtonColor(0.8,0.8,0.8,1)
    end

    hostOptionsScreen = screen:New(nil)

    levelSelectionContainer = guiBase:New(nil, hostOptionsScreen)
    levelSelectionContainer:SetPosition(0.5,0,0.5,90)
    levelSelectionContainer:SetSize(0.8,-20,0.1,0)
    levelSelectionContainer:SetColor(0.8, 0.8, 0.8, 1)
    levelSelectionContainer:SetAnchorPoint(0.5,0)
    
    leftBtn = textbutton:New(nil, hostOptionsScreen, "<", 32, "center", "center")
    
    leftBtn:SetPosition(0,10,0.5,90)
    leftBtn:SetSize(0.1,-10,0.1,0)
    leftBtn:SetButtonColor(0.8,0.8,0.8,1)
    leftBtn:SetColor(0,0,0,1)
    
    leftBtn.MouseDown = function ()
        leftBtn:SetButtonColor(0.6, 0.6, 0.6, 1)

        currentLevel = currentLevel - 1

        if currentLevel <= 0 then
            currentLevel = #levelList
        end

        if #levelList > 1 then
            levelNameLabel.Text = levelList[currentLevel]
        else
            levelNameLabel.Text = "No Levels Found!"
        end
    end
    
    leftBtn.MouseUp = function ()
        leftBtn:SetButtonColor(0.8, 0.8, 0.8, 1)
    end
    
    leftBtn.MouseEnter = function ()
        leftBtn:SetButtonColor(0.7, 0.7, 0.7,1)
    end
    
    leftBtn.MouseLeave = function ()
        leftBtn:SetButtonColor(0.8,0.8,0.8,1)
    end

    rightBtn = textbutton:New(nil, hostOptionsScreen, ">", 32, "center", "center")
    
    rightBtn:SetPosition(1,-10,0.5,90)
    rightBtn:SetSize(0.1,-10,0.1,0)
    rightBtn:SetAnchorPoint(1,0)
    rightBtn:SetButtonColor(0.8,0.8,0.8,1)
    rightBtn:SetColor(0,0,0,1)
    
    rightBtn.MouseDown = function ()
        rightBtn:SetButtonColor(0.6, 0.6, 0.6, 1)

        currentLevel = currentLevel + 1

        if currentLevel > #levelList then
            currentLevel = 1
        end

        if #levelList > 1 then
            levelNameLabel.Text = levelList[currentLevel]
        else
            levelNameLabel.Text = "No Levels Found!"
        end
    end
    
    rightBtn.MouseUp = function ()
        rightBtn:SetButtonColor(0.8, 0.8, 0.8, 1)
    end
    
    rightBtn.MouseEnter = function ()
        rightBtn:SetButtonColor(0.7, 0.7, 0.7,1)
    end
    
    rightBtn.MouseLeave = function ()
        rightBtn:SetButtonColor(0.8,0.8,0.8,1)
    end

    levelNameLabel = label:New(nil, hostOptionsScreen, "", 32, "center")
    levelNameLabel:SetPosition(0.5,0,0.5,90)
    levelNameLabel:SetSize(0.8,-20,0.1,0)
    levelNameLabel:SetColor(0,0,0,1)
    levelNameLabel:SetAnchorPoint(0.5,0)
    levelNameLabel.ZIndex = 2
    
    if #levelList > 1 then
        levelNameLabel.Text = levelList[currentLevel]
    else
        levelNameLabel.Text = "No Levels Found!"
    end

    hostusernameInput = textinput:New(nil, hostOptionsScreen, "Enter username", 32)
    hostusernameInput:SetPosition(0,10,0.6,100)
    hostusernameInput:SetSize(1,-20,0.1,0)
    hostusernameInput:SetColor(0.8, 0.8, 0.8, 1)
    hostusernameInput:SetTextColor(0,0,0,1)
    hostusernameInput:SetAnchorPoint(0,0)
    hostusernameInput:SetPlaceholderTextColor(0.5,0.5,0.5,1)
    
    hostusernameInput.MouseDown = function ()
        hostusernameInput:SetColor(0.6, 0.6, 0.6,1)
    end
    
    hostusernameInput.MouseEnter = function ()
        hostusernameInput:SetColor(0.7, 0.7, 0.7,1)
    end
    
    hostusernameInput.MouseLeave = function ()
        hostusernameInput:SetColor(0.8,0.8,0.8,1)
    end
    
    confirmHost = textbutton:New(nil, hostOptionsScreen, "Start Server", 32, "center", "center")
    confirmHost:SetPosition(0,10,0.7,110)
    confirmHost:SetSize(1,-20,0.1,0)
    confirmHost:SetButtonColor(0.8, 0.8, 0.8, 1)
    confirmHost:SetColor(0,0,0,1)
    confirmHost:SetAnchorPoint(0,0)
    
    confirmHost.MouseDown = function ()
        confirmHost:SetButtonColor(0.6, 0.6, 0.6, 1)
        
        server:Start(levelList[currentLevel])
        
        client:Init(BackToMenu)
        client:Join("localhost", 21114, hostusernameInput.Text)
        
        menu.Enabled = false
        hostOptionsScreen.Enabled = false
    end
    
    confirmHost.MouseEnter = function ()
        confirmHost:SetButtonColor(0.7, 0.7, 0.7,1)
    end
    
    confirmHost.MouseLeave = function ()
        confirmHost:SetButtonColor(0.8,0.8,0.8,1)
    end
end

function love.keypressed(key, scancode, rep)
    client:KeyPressed(key, scancode, rep)
    ipInput:KeyPressed(key, scancode, rep)
    usernameInput:KeyPressed(key, scancode, rep)
    hostusernameInput:KeyPressed(key, scancode, rep)
end

function love.update(dt)
    client:Update(dt)
    server:Update(dt)

    menu:Update()
    joinOptionsScreen:Update()
    hostOptionsScreen:Update()
end

function love.textinput(t)
    ipInput:TextInput(t)
    usernameInput:TextInput(t)
    hostusernameInput:TextInput(t)
end

function love.draw()
    menu:Draw()
    joinOptionsScreen:Draw()
    hostOptionsScreen:Draw()
    love.graphics.setBackgroundColor(1,1,1,1)
    client:Draw()
    
end