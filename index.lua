-- Ini adalah contoh konsep script Delta Roblox.
-- Anda perlu mengisi bagian-bagian spesifik dari BotGhost Anda.

local HttpService = game:GetService("HttpService")

-- Ganti ini dengan Webhook URL yang Anda dapatkan dari BotGhost
-- Webhook ini harus dikonfigurasi di BotGhost untuk mengedit pesan tertentu.
local DISCORD_WEBHOOK_URL = "cf8416acd12a00caeaf1b764b5f11ce56f00406f1c01fc18624a67c212d95870"

-- ID pesan Discord yang ingin Anda update.
-- Anda perlu mendapatkan ID pesan ini setelah bot Discord Anda pertama kali mengirim pesan placeholder.
local MESSAGE_ID_TO_UPDATE = "BOT SEDANG BERJALAN"

-- Fungsi untuk mengirim status ke Discord
local function sendDiscordStatus(isOnline)
    local statusMessage
    local color

    if isOnline then
        statusMessage = "✅ Server Delta: ONLINE!"
        color = 65280 -- Hijau
    else
        statusMessage = "❌ Server Delta: OFFLINE!"
        color = 16711680 -- Merah
    end

    local payload = {
        -- Beberapa webhook Discord mendukung editing pesan langsung dengan ID pesan
        -- Anda perlu memeriksa apakah BotGhost/webhook Anda mendukung ini.
        -- Jika tidak, Anda mungkin perlu BotGhost untuk mengirim payload ini sebagai content dari pesan baru
        -- dan menghapus pesan lama (jika BotGhost memiliki fungsi itu).
        -- Namun, tujuan Anda adalah mengupdate 1 pesan, jadi kita coba dulu dengan editing.
        ["content"] = "", -- Mungkin perlu dikosongkan jika menggunakan embeds
        ["embeds"] = {{
            ["title"] = "Status Server Delta",
            ["description"] = statusMessage,
            ["color"] = color,
            ["timestamp"] = DateTime.now():ToIsoDate(),
            ["footer"] = {
                ["text"] = "Update terakhir"
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(payload)

    pcall(function()
        -- Perhatikan bahwa metode HTTP untuk EDIT pesan adalah PATCH.
        -- Namun, webhook Discord standar biasanya hanya menerima POST.
        -- Jika BotGhost Anda menyediakan endpoint khusus untuk edit pesan, itu mungkin mendukung PATCH/PUT.
        -- Jika tidak, Anda mungkin perlu membuat BotGhost Anda menginterpretasikan payload POST ini
        -- sebagai instruksi untuk mengedit pesan dengan ID tertentu.
        HttpService:RequestAsync(
            {
                Url = DISCORD_WEBHOOK_URL .. "/messages/" .. MESSAGE_ID_TO_UPDATE, -- Contoh URL untuk PATCH/PUT
                Method = "PATCH", -- Coba PATCH, jika tidak berhasil, kembali ke POST dan biarkan BotGhost yang handle
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            }
        )
        print("Status dikirim ke Discord:", statusMessage)
    end)
end

-- Mendeteksi jumlah pemain
local players = game:GetService("Players")
local lastStatusOnline = false -- Menyimpan status terakhir yang dilaporkan

local function checkServerStatus()
    local currentPlayers = #players:GetPlayers()
    local isCurrentlyOnline = (currentPlayers > 0)

    if isCurrentlyOnline ~= lastStatusOnline then
        sendDiscordStatus(isCurrentlyOnline)
        lastStatusOnline = isCurrentlyOnline
    end
end

-- Loop untuk mengecek status setiap beberapa detik
while true do
    checkServerStatus()
    task.wait(30) -- Cek setiap 30 detik
end

-- Anda juga bisa menambahkan PlayerAdded/PlayerRemoving event untuk update yang lebih instan
players.PlayerAdded:Connect(function()
    sendDiscordStatus(true)
    lastStatusOnline = true
end)

players.PlayerRemoving:Connect(function()
    -- Beri waktu sebentar jika pemain terakhir baru saja keluar,
    -- untuk memastikan tidak ada pemain lain yang masuk dalam hitungan milidetik.
    task.wait(2)
    if #players:GetPlayers() == 0 then
        sendDiscordStatus(false)
        lastStatusOnline = false
    end
end)

-- Panggil sekali saat script dimulai untuk mengirim status awal
checkServerStatus()

