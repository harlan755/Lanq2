-- Delta Executor Roblox Script untuk Discord Webhook

local webhookUrl = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz" -- Ganti dengan URL Discord Webhook Anda

local playerName = game.Players.LocalPlayer.Name

local function sendWebhook(status)
    local data = {
        ["embeds"] = {{
            ["title"] = "Roblox Status Notifikasi",
            ["description"] = "**" .. playerName .. "** sekarang " .. status .. "!",
            ["color"] = 16776960 -- Warna kuning untuk notifikasi
        }}
    }
    if status == "online" then
        data.embeds[1].color = 65280 -- Warna hijau untuk online
    elseif status == "offline" or status == "terputus" then
        data.embeds[1].color = 16711680 -- Warna merah untuk offline/terputus
    end

    local http = game:GetService("HttpService")
    local encodedData = http:JSONEncode(data)

    local success, response = pcall(function()
        http:PostAsync(webhookUrl, encodedData, "application/json")
    end)

    if not success then
        warn("Gagal mengirim webhook: " .. response)
    end
end

-- Saat pemain bergabung (online)
sendWebhook("online")

-- Saat pemain meninggalkan game (offline)
game.Players.LocalPlayer.AncestryChanged:Connect(function()
    if not game.Players:FindFirstChild(playerName) then
        sendWebhook("offline")
    end
end)

-- Saat koneksi terputus (disconnect)
game:GetService("Players").LocalPlayer.PlayerRemoving:Connect(function()
    sendWebhook("terputus")
end)

print("Script Discord Webhook berjalan.")
