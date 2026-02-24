local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Discord Webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"

-- Ambil bola status
local statusBall = Workspace:WaitForChild("StatusBall")

-- Fungsi kirim ke Discord
local function sendDiscordMessage(username, status, activity)
    local data = {
        ["username"] = "BOT STATUSv2",
        ["embeds"] = {{
            ["title"] = username .. " status update",
            ["description"] = "**Status:** "..status.."\n**Activity:** "..(activity or "Tidak ada"),
            ["color"] = status == "Offline" and 15158332 or 3066993,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    local jsonData = HttpService:JSONEncode(data)
    
    local success, err = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if not success then
        warn("Gagal mengirim webhook:", err)
    end
end

-- Fungsi ubah warna bola
local function setBallColor(color)
    statusBall.BrickColor = BrickColor.new(color)
end

-- Fungsi kedip bola
local function blinkBall(color1, color2, interval)
    spawn(function()
        while true do
            statusBall.BrickColor = BrickColor.new(color1)
            wait(interval)
            statusBall.BrickColor = BrickColor.new(color2)
            wait(interval)
        end
    end)
end

-- Track jumlah pemain online
local function updateBallStatus()
    if #Players:GetPlayers() > 0 then
        -- Hijau berkedip
        blinkBall("Lime green", "Really black", 0.5)
    else
        -- Merah berkedip
        blinkBall("Bright red", "Really black", 0.5)
    end
end

-- Event ketika pemain join
Players.PlayerAdded:Connect(function(player)
    sendDiscordMessage(player.Name, "Online", "Masuk ke game")
    updateBallStatus()
    
    -- Track aktivitas, contoh chat
    player.Chatted:Connect(function(msg)
        sendDiscordMessage(player.Name, "Sedang melakukan aktivitas", msg)
    end)
end)

-- Event ketika pemain leave
Players.PlayerRemoving:Connect(function(player)
    sendDiscordMessage(player.Name, "Offline", "Keluar dari game / Disconnect")
    
    -- Update status bola jika semua offline
    wait(0.1) -- tunggu sedikit untuk mengupdate list pemain
    updateBallStatus()
end)

-- Set status awal
updateBallStatus()
