local chat = {}

local screen = require("yan.instance.ui.screen")
local textinput = require("yan.instance.ui.textinput")
local label = require("yan.instance.ui.label")
local list = require("yan.instance.ui.list")

chat.open = false
chat.typing = false

function chat:Init(client)
    chatScreen = screen:New(nil)
    chatInput = textinput:New(nil, chatScreen, "Type your message!", 32)
    chatInput:SetAnchorPoint(0,1)
    chatInput:SetPosition(0,0,1,0)
    chatInput:SetSize(1,0,0.1,0)
    
    chatInput:SetColor(0.8, 0.8, 0.8, 1)
    chatInput:SetTextColor(0, 0, 0, 1)
    chatInput:SetPlaceholderTextColor(0.5,0.5,0.5,1)

    chatInput.MouseDown = function ()
        chatInput:SetColor(0.6, 0.6, 0.6, 1)
    end
    
    chatInput.MouseEnter = function ()
        chatInput:SetColor(0.7, 0.7, 0.7, 1)
    end
    
    chatInput.MouseLeave = function ()
        chatInput:SetColor(0.8,0.8,0.8,1)
    end

    chatInput.OnEnter = function ()
        client.Client:send("chatMessage", chatInput.Text)
        chatInput.Text = ""
    end
end

function chat:Update()
    chatScreen.Enabled = self.open
    self.typing = chatInput.IsTyping
    chatScreen:Update()
end

function chat:KeyPressed(key, scancode, rep)
    if chat.open == false then return end
    chatInput:KeyPressed(key, scancode, rep)
end

function chat:TextInput(t)
    if chat.open == false then return end
    chatInput:TextInput(t)
end

function chat:Draw()
    chatScreen:Draw()
end

return chat