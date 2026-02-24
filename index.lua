local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Ganti dengan Webhook BotGhost-mu
local webhookURL = "https://api.botghost.com/webhook/1475964119181168751/z9gyi7vvk3cer1ghf93xh"

-- Simpan message ID untuk update pesan
local messageID

-- Fungsi untuk kirim atau update webhook
local function sendOrUpdateWebhook(content)
    local data = HttpService:JSONEncode({ content = content })

    local success, response = pcall(function()
        if messageID then
            -- PATCH ke pesan yang sudah ada
            return HttpService:RequestAsync({
                Url = webhookURL.."/messages/"..messageID,
                Method = "PATCH",
                Headers = { ["Content-Type"] = "application/json" },
                Body = data
            })
        else
            -- POST pertama kali
            return HttpService:PostAsync(webhookURL, data, Enum.HttpContentType.ApplicationJson, false)
        end
    end)

    if success then
        if not messageID then
            local decode = HttpService:JSONDecode(response or "{}")
            messageID = decode.id
        end
    else
        warn("Gagal kirim/update webhook: "..tostring(response))
    end
end

-- Fungsi update status online/offline semua player
local function updatePlayerStatus()
    local text = "**Status Player Saat Ini:**\n"
    for _, player in pairs(Players:GetPlayers()) do
        text = text .. "- " .. player.Name .. " : Online\n"
    end
    if #Players:GetPlayers() == 0 then
        text = text .. "Tidak ada player online."
    end
    sendOrUpdateWebhook(text)
end

-- Event player masuk
Players.PlayerAdded:Connect(updatePlayerStatus)
-- Event player keluar
Players.PlayerRemoving:Connect(updatePlayerStatus)

-- Update otomatis tiap 10 detik
while true do
    task.wait(10)
    updatePlayerStatus()
end
