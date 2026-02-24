local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local webhookURL = "https://auth.platorelay.com/a?d=4mmTaMjo9Krkbs2CjAIVrYUdAs5drX313iemsEWMy3JUXzhPH9xchhqcS7AA6RvAGZGRuApa2oWBAC7BprRqIhU1BDj5P6ePrnvhPQp6IHuKF1OZqu6ymSrp1V5rh8IKoHNhzfYRlMRCdGmcIKBHvqDhVMx1S8uhJR6wvhxKJsMmytbkXqYmglIZBfx4GP8PRzVZp3vT2VG0IvNoIyd4XkgYR3ouIo2cUzlK1Mzs2uEnCkSnNrGLgnEH9vkYMrOICOcqx5s7412qOKJkjxMx3wgUSgYEnuQL7aJr6I7XToc7RCKiYxJpaMPhH3jNsMWoX4ajzyzwTGNTol6138q4FS9qcAqmhX6AEoQ14OIOPE2SEzwZVd3pWKErkAYXu2A7lW2v6WJdLH7LfM4fSA1ue4VLkPrODWcih5uTAfYjJgvwecmxCI7MC0dvwegHz9"

local function sendToDiscord(data)
    local jsonData = HttpService:JSONEncode(data)
    
    pcall(function()
        HttpService:PostAsync(
            webhookURL,
            jsonData,
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

local function getInventory(player)
    local items = {}
    
    for _, tool in pairs(player.Backpack:GetChildren()) do
        table.insert(items, tool.Name)
    end
    
    return table.concat(items, ", ")
end

local function updateStatus(player, status)
    local inventory = getInventory(player)
    
    local data = {
        content = "**Status Bot:** " .. status ..
                  "\n**Player:** " .. player.Name ..
                  "\n**Inventory:** " .. (inventory ~= "" and inventory or "Kosong")
    }
    
    sendToDiscord(data)
end

Players.PlayerAdded:Connect(function(player)
    updateStatus(player, "Online")
    
    while player.Parent do
        task.wait(1)
        updateStatus(player, "Online")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    updateStatus(player, "Offline / Disconnect")
end)
