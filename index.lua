-- DELTA EXECUTOR SCRIPT
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local webhook = "https://discord.com/api/webhooks/1475954913015234671/ORf3ZgZTW-phbx9okcBtRspQV-V_FqhlQGHzaYVd_lf-6Os0-ZGes-88An65Bm2kJcVD"

-- FUNCTION KIRIM KE DISCORD
local function sendDiscord(message)
    local data = {
        ["content"] = message
    }

    local json = HttpService:JSONEncode(data)

    if syn and syn.request then
        syn.request({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
    elseif request then
        request({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
    end
end

-- NOTIF SAAT KAMU MASUK GAME
sendDiscord("🟢 "..LocalPlayer.Name.." EXECUTED SCRIPT")

-- DETEKSI PLAYER JOIN
Players.PlayerAdded:Connect(function(player)
    sendDiscord("🟢 "..player.Name.." JOIN SERVER")
end)

-- DETEKSI PLAYER LEAVE
Players.PlayerRemoving:Connect(function(player)
    sendDiscord("🔴 "..player.Name.." LEFT SERVER")
end)

-- STATUS DI ATAS KEPALA (ONLINE)
local function addStatus(character)
    local head = character:WaitForChild("Head")

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.Text = "🟢 ONLINE"
    text.TextColor3 = Color3.fromRGB(0,255,0)
    text.Parent = billboard
end

if LocalPlayer.Character then
    addStatus(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(addStatus)
