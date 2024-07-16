local pause = {}

local screen = require("yan.instance.ui.screen")
local imagebutton = require("yan.instance.ui.imagebutton")
local image = require("yan.instance.ui.image")

pause.paused = false

function pause:Init(client)
    pauseMenu = screen:New(nil)
    pauseMenu.Enabled = true
    pausedText = image:New(nil, pauseMenu, "/img/paused.png")
    pausedText:SetPosition(0,10,0,10)
    pausedText:SetSize(0,200,0,50)

    resumeButton = imagebutton:New(nil, pauseMenu, "/img/resume.png")
    resumeButton:SetPosition(0,10,0,60)
    resumeButton:SetSize(0,300,0,150)

    resumeButton.MouseEnter = function ()
        resumeButton:SetColor(0.7,0.7,0.7,1)
    end
    
    resumeButton.MouseLeave = function ()
        resumeButton:SetColor(1,1,1,1)
    end

    resumeButton.MouseDown = function ()
        self.paused = false
    end
    
    retryButton = imagebutton:New(nil, pauseMenu, "/img/restart.png")
    retryButton:SetPosition(0,10,0,220)
    retryButton:SetSize(0,300,0,150)
    
    retryButton.MouseEnter = function ()
        retryButton:SetColor(0.7,0.7,0.7,1)
    end
    
    retryButton.MouseLeave = function ()
        retryButton:SetColor(1,1,1,1)
    end
    
    retryButton.MouseDown = function ()
        client:Restart()
        self.paused = false
    end

    menuButton = imagebutton:New(nil, pauseMenu, "/img/menu.png")
    menuButton:SetPosition(0,10,0,380)
    menuButton:SetSize(0,300,0,150)
    
    menuButton.MouseEnter = function ()
        menuButton:SetColor(0.7,0.7,0.7,1)
    end
    
    menuButton.MouseLeave = function ()
        menuButton:SetColor(1,1,1,1)
    end
    
    menuButton.MouseDown = function ()
        client:Leave()
        self.paused = false
    end
end

function pause:Update()
    pauseMenu:Update()
end

function pause:Draw()
    if pause.paused == false then return end
    
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0,0,10000,10000)
    love.graphics.setColor(1,1,1,1)
    
    pauseMenu:Draw()
end

return pause