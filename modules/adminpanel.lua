local adminpanel = {}

local screen = require("yan.instance.ui.screen")
local textbutton = require("yan.instance.ui.textbutton")
local image = require("yan.instance.ui.image")

adminpanel.open = false

function adminpanel:Init(client)
    panel = screen:New(nil)
    panel.Enabled = true
    
    title = image:New(nil, panel, "/img/administrative_tools.png")
    title:SetPosition(0,5,0,5)
    title:SetSize(0,500,0,50)

    flyToggle = textbutton:New(nil, panel, "Toggle Flight", 32, "center", "center")
    flyToggle:SetPosition(0,5,0,60)
    flyToggle:SetSize(0.5,0,0.1,0)

    flyToggle.MouseEnter = function ()
        flyToggle:SetButtonColor(0.2,0.2,0.2,1)
    end
    
    flyToggle.MouseLeave = function ()
        flyToggle:SetButtonColor(0,0,0,1)
    end

    flyToggle.MouseDown = function ()
        client.flying = not client.flying
    end

    airJumpToggle = textbutton:New(nil, panel, "Toggle Air Jumping", 32, "center", "center")
    airJumpToggle:SetPosition(0,5,0.1,65)
    airJumpToggle:SetSize(0.5,0,0.1,0)

    airJumpToggle.MouseEnter = function ()
        airJumpToggle:SetButtonColor(0.2,0.2,0.2,1)
    end
    
    airJumpToggle.MouseLeave = function ()
        airJumpToggle:SetButtonColor(0,0,0,1)
    end

    airJumpToggle.MouseDown = function ()
        client.airJumping = not client.airJumping
    end
end

function adminpanel:Update()
    panel:Update()
end

function adminpanel:Draw()
    if self.open == false then return end

    love.graphics.setColor(0,1,0,0.5)
    love.graphics.rectangle("fill", 0,0,10000,10000)
    love.graphics.setColor(1,1,1,1)
    
    panel:Draw()
end

return adminpanel