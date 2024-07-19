local wardrobe = {}

local screen = require("yan.instance.ui.screen")
local imagebutton = require("yan.instance.ui.imagebutton")
local image = require("yan.instance.ui.image")

wardrobe.Cosmetics = {
    "amongus_cosplay.png",
    "purple goose cosplay.png",
    "shocked.png",
    "sneakers.png",
    "creature.png",
    "dinosaur_spikes.png",
    "ghost.png",
    "legs.png",
    "little goose.png",
    "wheels.png",
    "angry.png",
    "hat.png",
    "necklace.png"
}

local cosmeticButtons = {}
local previewCosmetics = {}

wardrobe.Open = false

function wardrobe:Init(client)
    wardrobeScreen = screen:New(nil) 
    wardrobeScreen.Enabled = true
    
    title = image:New(nil, wardrobeScreen, "/img/wardrobe.png")
    title:SetPosition(0,10,0,10)
    title:SetSize(0,500,0,50)
    
    local previewGoose = image:New(nil, wardrobeScreen, "/img/player.png")
    previewGoose:SetPosition(1, -50, 0.5, 0)
    previewGoose:SetSize(0,200,0,200)
    previewGoose:SetAnchorPoint(1, 0.5)
    
    local row = 0
    local ri = 1

    for index, cosmetic in ipairs(self.Cosmetics) do
        client.cosmetics[cosmetic] = false

        local goose = image:New(nil, wardrobeScreen, "/img/player.png")
        goose:SetPosition(0,10 + (row * 60), 0, 70 + (ri * 60))
        goose:SetSize(0,50,0,50)
        
        local button = imagebutton:New(nil, wardrobeScreen, "/img/"..cosmetic)
        button:SetPosition(0,10 + (row * 60),0, 70 + (ri * 60))
        button:SetSize(0,50,0,50)
        button.ZIndex = 2

        local previewCosmetic = image:New(nil, wardrobeScreen, "/img/"..cosmetic)
        previewCosmetic:SetPosition(1, -50, 0.5, 0)
        previewCosmetic:SetSize(0,200,0,200)
        previewCosmetic:SetAnchorPoint(1, 0.5)
        previewCosmetic.ZIndex = 2 + index
        previewCosmetic:SetColor(1,1,1,0)
        previewCosmetics[cosmetic] = previewCosmetic

        button.MouseEnter = function ()
            if client.cosmetics[cosmetic] == true then
                button:SetColor(0.3, 0.3, 0.3 ,1)
                goose:SetColor(0.3, 0.3, 0.3 , 1)
            else
                button:SetColor(0.7,0.7,0.7,1)
                goose:SetColor(0.7, 0.7, 0.7, 1)
            end
        end
        
        button.MouseLeave = function ()
            if client.cosmetics[cosmetic] == true then
                button:SetColor(0.5, 0.5, 0.5, 1)
                goose:SetColor(0.5, 0.5, 0.5, 1)
            else
                button:SetColor(1,1,1,1)
                goose:SetColor(1,1,1,1)
            end
        end

        button.MouseDown = function ()
            client:ToggleCosmetic(cosmetic, not client.cosmetics[cosmetic])

            if client.cosmetics[cosmetic] == true then
                button:SetColor(0.5, 0.5, 0.5, 1)
                goose:SetColor(0.5, 0.5, 0.5, 1)

                previewCosmetics[cosmetic]:SetColor(1,1,1,1)
            else
                button:SetColor(1,1,1,1)
                goose:SetColor(1,1,1,1)

                previewCosmetics[cosmetic]:SetColor(1,1,1,0)
            end
        end
        
        table.insert(cosmeticButtons, button)
        
        ri = ri + 1
        if ri > 5 then
            ri = 1
            row = row + 1
        end
    end
    
    
end

function wardrobe:Update()
    if self.Open == false then return end
    wardrobeScreen:Update()
end

function wardrobe:Draw()
    if self.Open == false then return end

    love.graphics.setColor(1,1,0,0.5)
    love.graphics.rectangle("fill", 0,0,10000,10000)
    love.graphics.setColor(1,1,1,1)

    wardrobeScreen:Draw()
end

return wardrobe