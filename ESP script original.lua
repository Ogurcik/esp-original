local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Функция для создания ESP для игрока
local function createESP(player)
    if player == localPlayer then return end

    local function onCharacterAdded(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end

        -- Удаление старых ESP элементов, если они есть
        for _, child in pairs(head:GetChildren()) do
            if child:IsA("BillboardGui") and child.Name ~= "ESP" then
                child:Destroy()
            end
        end

        -- Удаление оригинального никнейма
        for _, child in pairs(head:GetChildren()) do
            if child:IsA("BillboardGui") and child.Name ~= "ESP" then
                child:Destroy()
            end
        end

        -- Создание надписей с именем и здоровьем
        local billboard = Instance.new("BillboardGui", head)
        billboard.Name = "ESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 150, 0, 40)  -- Размер биллборда
        billboard.StudsOffset = Vector3.new(0, 3, 0)

        local frame = Instance.new("Frame", billboard)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1

        -- Функция для создания текстовых меток
        local function createTextLabel(text, textSize, position)
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, 0, 0.5, 0)
            label.Position = position
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Цвет текста
            label.TextStrokeTransparency = 0.5
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  -- Черная обводка
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = textSize
            label.TextScaled = true
            label.TextWrapped = true
            return label
        end

        local nameLabel = createTextLabel(player.Name, 12, UDim2.new(0, 0, 0, 0))  -- Немного уменьшили размер
        local healthLabel = createTextLabel("HP: 100", 14, UDim2.new(0, 0, 0.5, 0))  -- Немного уменьшили размер

        -- Функция для создания обводки вокруг персонажа
        local function createHighlight(character)
            local highlight = Instance.new("Highlight", character)
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(75, 0, 130)  -- Темно-фиолетовый цвет
            highlight.FillTransparency = 0.3
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  -- Белая обводка
            highlight.OutlineTransparency = 0.2
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end

        -- Создание обводки при добавлении персонажа
        createHighlight(character)

        -- Обновление текста здоровья и обводки
        local function updateESP()
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local health = humanoid.Health
                healthLabel.Text = "HP: " .. math.floor(health)

                -- Обновление цвета и прозрачности Highlight
                local highlight = character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight.FillColor = Color3.fromRGB(75, 0, 130)  -- Темно-фиолетовый цвет
                end
            end
        end

        -- Обновляем текст и цвет с частотой 10 раз в секунду
        local updateConnection = RunService.RenderStepped:Connect(function(step)
            if step >= 0.1 then
                updateESP()
            end
        end)

        -- Убедитесь, что соединение отключено при удалении персонажа
        player.CharacterRemoving:Connect(function()
            if updateConnection then
                updateConnection:Disconnect()
            end
        end)

        updateESP()
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(createESP)
