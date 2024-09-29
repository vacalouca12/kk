local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Adicionando controle deslizante de velocidade
local SpeedSlider = Tabs.Main:AddSlider("SpeedSlider", {
    Title = "Velocidade",
    Description = "Ajuste a velocidade do jogador.",
    Default = 16,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        print("Velocidade ajustada para:", Value)
    end
})

SpeedSlider:OnChanged(function(Value)
    print("Velocidade alterada:", Value)
end)

-- Adicionando controle deslizante de FOV
local FOVSlider = Tabs.Main:AddSlider("FOVSlider", {
    Title = "Campo de Visão (FOV)",
    Description = "Ajuste o FOV da câmera.",
    Default = 70,
    Min = 1,
    Max = 120,
    Rounding = 1,
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
        print("FOV ajustado para:", Value)
    end
})

FOVSlider:OnChanged(function(Value)
    print("FOV alterado:", Value)
end)


-- Função para copiar a skin, cabelo e animações de outro jogador
Tabs.Main:AddInput("CopySkinInput", {
    Title = "Copiar Skin de Jogador",
    Placeholder = "Nome do jogador",
    Callback = function(Value)
        local player = game.Players:FindFirstChild(Value)
        if player and player.Character then
            local localCharacter = game.Players.LocalPlayer.Character
            
            -- Limpar partes do personagem local
            for _, item in pairs(localCharacter:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") then
                    item:Destroy()
                end
            end
            
            -- Copiar acessórios e roupas
            for _, item in pairs(player.Character:GetChildren()) do
                if item:IsA("Accessory") then
                    local clonedAccessory = item:Clone()
                    clonedAccessory.Parent = localCharacter
                elseif item:IsA("Shirt") then
                    local shirt = item:Clone()
                    shirt.Parent = localCharacter
                elseif item:IsA("Pants") then
                    local pants = item:Clone()
                    pants.Parent = localCharacter
                elseif item:IsA("BodyColors") then
                    local bodyColors = item:Clone()
                    bodyColors.Parent = localCharacter
                end
            end
            
            -- Copiar cabelo (caso o jogador tenha)
            local hair = player.Character:FindFirstChildWhichIsA("Accessory")
            if hair then
                local clonedHair = hair:Clone()
                clonedHair.Parent = localCharacter
            end
            
            -- Copiar animações (caso o jogador tenha)
            if player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local newHumanoid = localCharacter:FindFirstChild("Humanoid")
                if newHumanoid then
                    -- Limpar animações atuais
                    for _, anim in pairs(newHumanoid:GetPlayingAnimationTracks()) do
                        anim:Stop()
                    end

                    -- Copiar animações
                    for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
                        local newAnim = Instance.new("Animation")
                        newAnim.AnimationId = anim.Animation.AnimationId
                        newHumanoid:LoadAnimation(newAnim):Play()
                    end
                end
            end
            
            print("Skin e animações copiadas de:", Value)
        else
            print("Jogador não encontrado.")
        end
    end
})


-- Função para ativar "Plus" no MeepCity sem kick
Tabs.Main:AddButton({
    Title = "Ativar Plus no MeepCity",
    Callback = function()
        if game.PlaceId == 370731277 then -- MeepCity PlaceId
            -- Implementar lógica de ativação de Plus
            print("Plus ativado no MeepCity!")
            -- Você pode adicionar aqui a lógica para dar as funcionalidades do Plus no MeepCity
        else
            print("Este comando só funciona no MeepCity.")
        end
    end
})

-- Função para dançar
Tabs.Main:AddButton({
    Title = "Dançar",
    Callback = function()
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:LoadAnimation(game:GetService("ReplicatedStorage").Animations.DanceAnimation):Play()
            print("Dançando!")
        end
    end
})

-- Função de Noclip
local noclipEnabled = false
Tabs.Main:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Default = false,
    Description = "Ativar/Desativar Noclip."
})

-- Função de FullBright Leve (para mais FPS)
local function fullBrightLite()
    pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 0.5 -- Reduz o brilho para otimizar FPS
        lighting.FogEnd = 1e5 -- Reduz o alcance da névoa para aliviar o processamento
        lighting.GlobalShadows = false -- Desativa sombras globais
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128) -- Ajuste para aliviar o processamento gráfico

        for i, v in pairs(lighting:GetDescendants()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false -- Desativa todos os efeitos visuais que consomem FPS
            end
        end

        lighting.Changed:Connect(function()
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.Brightness = 0.5
            lighting.FogEnd = 1e5
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end)
    end)
end

-- Adicionando a aba FullBright na interface existente
local FullBrightTab = Window:AddTab({ Title = "FullBright", Icon = "" })

-- Adicionando botão para ativar FullBright FPS
FullBrightTab:AddButton({
    Title = "Ativar FullBright Lite (Mais FPS)",
    Callback = function()
        fullBrightLite()
        print("FullBright Lite ativado.")
    end
})

-- Função de FullBright
local function fullBright()
    pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 1
        lighting.FogEnd = 1e10
        for i, v in pairs(lighting:GetDescendants()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
        lighting.Changed:Connect(function()
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.Brightness = 1
            lighting.FogEnd = 1e10
        end)
        spawn(function()
            local character = game:GetService("Players").LocalPlayer.Character
            while wait() do
                repeat wait() until character ~= nil
                if not character.HumanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                    local headlight = Instance.new("PointLight", character.HumanoidRootPart)
                    headlight.Brightness = 1
                    headlight.Range = 60
                end
            end
        end)
    end)
end

-- Adicionando a aba FullBright na interface existente
local FullBrightTab = Window:AddTab({ Title = "FullBright", Icon = "" })

-- Adicionando botão para ativar/desativar FullBright
FullBrightTab:AddButton({
    Title = "Ativar FullBright",
    Callback = function()
        fullBright()
        print("FullBright ativado.")
    end
})

-- Variável para controlar a velocidade do Spin Lite
local spinSpeed = 50
local spinEnabled = false

-- Função para ativar/desativar o Spin Lite
local function toggleSpinLite()
    local plr = game:GetService("Players").LocalPlayer
    repeat task.wait() until plr.Character
    local humRoot = plr.Character:WaitForChild("HumanoidRootPart")
    
    if spinEnabled then
        -- Criar o Spinbot
        plr.Character:WaitForChild("Humanoid").AutoRotate = false
        local velocity = Instance.new("AngularVelocity")
        velocity.Attachment0 = humRoot:WaitForChild("RootAttachment")
        velocity.MaxTorque = math.huge
        velocity.AngularVelocity = Vector3.new(0, spinSpeed, 0)
        velocity.Parent = humRoot
        velocity.Name = "Spinbot"
    else
        -- Desativar Spinbot
        if humRoot:FindFirstChild("Spinbot") then
            humRoot:FindFirstChild("Spinbot"):Destroy()
        end
        plr.Character:WaitForChild("Humanoid").AutoRotate = true
    end
end

-- Adicionar aba de Spin Lite
local SpinLiteTab = Window:AddTab({ Title = "Spin Lite", Icon = "spin_lite" })

-- Adicionar botão de alternância (toggle) para ativar/desativar Spin Lite
SpinLiteTab:AddToggle("SpinLiteToggle", {
    Title = "Ativar Spin Lite",
    Default = false,
    Description = "Ative para começar a girar o personagem com o Spin Lite.",
    Callback = function(Value)
        spinEnabled = Value
        toggleSpinLite()
    end
})

-- Adicionar slider para ajustar a velocidade do Spin Lite
SpinLiteTab:AddSlider("SpinLiteSpeedSlider", {
    Title = "Velocidade do Spin Lite",
    Description = "Ajuste a velocidade do giro.",
    Default = 50,
    Min = 1,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        spinSpeed = Value
        if spinEnabled then
            -- Atualizar a velocidade enquanto o Spin Lite está ativado
            local plr = game:GetService("Players").LocalPlayer
            local humRoot = plr.Character:WaitForChild("HumanoidRootPart")
            if humRoot:FindFirstChild("Spinbot") then
                humRoot:FindFirstChild("Spinbot").AngularVelocity = Vector3.new(0, spinSpeed, 0)
            end
        end
        print("Velocidade do Spin Lite ajustada para:", Value)
    end
})



-- Função para teleportar o jogador até a arma do xerife
local function teleportToGun()
    local player = game.Players.LocalPlayer
    for _, item in pairs(workspace:GetChildren()) do
        if item.Name == "GunDrop" and item:IsA("Tool") then
            -- Teletransporta o jogador para a posição da arma
            player.Character.HumanoidRootPart.CFrame = item.Handle.CFrame
            break
        end
    end
end

-- Função para detectar quando o xerife morrer
local function detectSheriffDeath()
    local gunFound = false
    while not gunFound do
        wait(1) -- Espera 1 segundo antes de verificar novamente
        for _, item in pairs(workspace:GetChildren()) do
            if item.Name == "GunDrop" and item:IsA("Tool") then
                gunFound = true
                teleportToGun()
                break
            end
        end
    end
end




-- Variável para controlar a ESP
local espLineEnabled = false
local espLines = {}

-- Função para determinar a cor do papel do jogador
local function getRoleColor(player)
    if player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
        return Color3.fromRGB(0, 0, 255) -- Azul para xerife
    elseif player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
        return Color3.fromRGB(255, 0, 0) -- Vermelho para murder
    else
        return Color3.fromRGB(0, 255, 0) -- Verde para inocentes
    end
end

-- Função para criar uma linha ESP entre o jogador e os outros jogadores
local function createESPLine(player)
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera

    -- Cria uma linha
    local line = Drawing.new("Line")
    line.Thickness = 2

    -- Cria um texto para mostrar o nome do jogador
    local text = Drawing.new("Text")
    text.Size = 18
    text.Center = true
    text.Outline = true

    -- Função para atualizar a posição da linha e do texto
    local function updateLine()
        if not espLineEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            line.Visible = false
            text.Visible = false
            return
        end

        local humanoidRootPart = player.Character.HumanoidRootPart

        -- Atualiza a cor com base no papel
        local roleColor = getRoleColor(player)

        -- Desenha a linha da câmera até o jogador
        local screenPosition, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
        if onScreen then
            local cameraPosition = camera:WorldToViewportPoint(localPlayer.Character.HumanoidRootPart.Position)

            line.From = Vector2.new(cameraPosition.X, cameraPosition.Y)
            line.To = Vector2.new(screenPosition.X, screenPosition.Y)
            line.Color = roleColor
            line.Visible = true

            -- Atualiza o texto para mostrar o nome do jogador
            text.Position = Vector2.new(screenPosition.X, screenPosition.Y - 20) -- posição acima da linha
            text.Color = roleColor
            text.Text = player.Name
            text.Visible = true
        else
            line.Visible = false
            text.Visible = false
        end
    end

    -- Atualizar a linha e texto a cada frame
    game:GetService("RunService").RenderStepped:Connect(updateLine)
    table.insert(espLines, { line = line, text = text, player = player })
end

-- Função para remover a ESP Line de um jogador
local function removeESPLine(player)
    for i, esp in ipairs(espLines) do
        if esp.player == player then
            esp.line.Visible = false
            esp.line:Remove()
            esp.text.Visible = false
            esp.text:Remove()
            table.remove(espLines, i)
            break
        end
    end
end

-- Função para ativar/desativar ESP Line
local function toggleESPLine()
    if espLineEnabled then
        -- Criar ESP Lines para todos os jogadores
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                createESPLine(player)
            end
        end
    else
        -- Remover todas as ESP Lines
        for _, esp in pairs(espLines) do
            esp.line.Visible = false
            esp.line:Remove()
            esp.text.Visible = false
            esp.text:Remove()
        end
        espLines = {}
    end
end

-- Atualizar ESP Line quando novos jogadores entrarem ou morrerem
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart") -- Aguarda a parte raiz humanoide
        if espLineEnabled then
            createESPLine(player)
        end
    end)
end)

-- Remover ESP Line quando o jogador morrer
game.Players.PlayerRemoving:Connect(function(player)
    removeESPLine(player)
end)

-- Monitorar a morte dos personagens
for _, player in pairs(game.Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart") -- Aguarda a parte raiz humanoide
        if espLineEnabled then
            createESPLine(player)
        end
    end)
end

-- Atualizar a cor da ESP quando o jogador pega uma arma
local function updateESPForPlayer(player)
    for _, esp in pairs(espLines) do
        if esp.player == player then
            esp.line.Color = getRoleColor(player)
            esp.text.Color = getRoleColor(player)
            break
        end
    end
end

-- Monitorar a adição e remoção de armas no inventário
game.Players.PlayerAdded:Connect(function(player)
    player.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            updateESPForPlayer(player)
        end
    end)

    player.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            updateESPForPlayer(player)
        end
    end)
end)

-- Adicionando a aba de ESP Line
local espLineTab = Window:AddTab({ Title = "ESP Line MM2", Icon = "line" })

-- Adicionar botão de alternância (toggle) para ativar/desativar ESP Line
espLineTab:AddToggle("ESPLineToggle", {
    Title = "Ativar ESP Line",
    Default = false,
    Description = "Ative para mostrar ESP Lines nos jogadores.",
    Callback = function(Value)
        espLineEnabled = Value
        toggleESPLine() -- Ativar/desativar a ESP Line
    end
})



-- Variáveis para a velocidade original e a velocidade aumentada
local originalWalkSpeed = 16 -- Velocidade padrão
local boostedWalkSpeed = 50 -- Velocidade aumentada
local speedBoostEnabled = false -- Controle de estado

-- Variável para o FOV
local fovEnabled = false -- Controle de estado do FOV
local camera = game.Workspace.CurrentCamera -- Obtendo a câmera
local originalFieldOfView = camera.FieldOfView -- FOV original

-- Variável para o Noclip
local noclipEnabled = false -- Controle de estado do Noclip

-- Variável para o Pulo Infinito
local infiniteJumpEnabled = false -- Controle de estado do pulo infinito

-- Função para ativar/desativar a aceleração de movimento
local function toggleSpeedBoost()
    local player = game.Players.LocalPlayer
    repeat task.wait() until player.Character -- Espera até o personagem estar carregado
    local humanoid = player.Character:WaitForChild("Humanoid")

    if speedBoostEnabled then
        humanoid.WalkSpeed = boostedWalkSpeed -- Ativar a aceleração
    else
        humanoid.WalkSpeed = originalWalkSpeed -- Desativar a aceleração
    end
end

-- Função para ativar/desativar o FOV
local function toggleFOV()
    if fovEnabled then
        camera.FieldOfView = 125 -- Define o FOV máximo para 125
    else
        camera.FieldOfView = originalFieldOfView -- Restaura o FOV original
    end
end

-- Função para ativar/desativar o Noclip
local function toggleNoclip()
    local player = game.Players.LocalPlayer
    local character = player.Character

    if character then
        -- Alterna a propriedade CanCollide para todas as partes
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled -- Altera a propriedade CanCollide
            end
        end
    end
end

-- Função para manter o Noclip ativo enquanto a opção estiver ativada
local function noclipLoop()
    while noclipEnabled do
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            -- Atualiza a propriedade CanCollide continuamente
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false -- Mantém o Noclip
                end
            end
        end
        task.wait(0.1) -- Espera um pouco antes de repetir
    end
end

-- Função para ativar o pulo infinito
local function toggleInfiniteJump()
    local player = game.Players.LocalPlayer
    local humanoid = player.Character:WaitForChild("Humanoid")

    if infiniteJumpEnabled then
        -- Conectar o evento de pulo
        player.Character.Humanoid.Jumping:Connect(function()
            if infiniteJumpEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Monitorar respawns para manter a velocidade e pulo
local function monitorPlayer()
    local player = game.Players.LocalPlayer
    player.CharacterAdded:Connect(function(character)
        repeat task.wait() until character:WaitForChild("Humanoid") -- Espera até o humanoide estar disponível
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Mantém a velocidade após o respawn
        humanoid.WalkSpeed = speedBoostEnabled and boostedWalkSpeed or originalWalkSpeed
        
        -- Conectar novamente ao evento de morte para garantir que a velocidade seja mantida
        humanoid.Died:Connect(function()
            humanoid.WalkSpeed = originalWalkSpeed -- Reseta a velocidade ao morrer
        end)

        -- Ativar pulo infinito após respawn
        toggleInfiniteJump()
    end)
end

-- Adicionar aba de Aceleração e FOV
local SpeedTab = Window:AddTab({ Title = "Aceleração e FOV", Icon = "speed" })

-- Adicionar botão de alternância para ativar/desativar a aceleração
SpeedTab:AddToggle("SpeedBoostToggle", {
    Title = "Ativar Aceleração",
    Default = false,
    Description = "Ative para aumentar a velocidade do personagem.",
    Callback = function(Value)
        speedBoostEnabled = Value
        toggleSpeedBoost() -- Chama a função sempre que o valor muda
    end
})

-- Adicionar slider para ajustar a velocidade aumentada
SpeedTab:AddSlider("BoostedSpeedSlider", {
    Title = "Velocidade Aumentada",
    Description = "Ajuste a velocidade quando a aceleração está ativada.",
    Default = boostedWalkSpeed,
    Min = 16, -- Velocidade mínima (velocidade padrão)
    Max = 100, -- Velocidade máxima (ajuste conforme necessário)
    Rounding = 1,
    Callback = function(Value)
        boostedWalkSpeed = Value
        if speedBoostEnabled then
            -- Atualiza a velocidade enquanto a aceleração está ativada
            local player = game.Players.LocalPlayer
            repeat task.wait() until player.Character -- Espera até o personagem estar carregado
            local humanoid = player.Character:WaitForChild("Humanoid")
            humanoid.WalkSpeed = boostedWalkSpeed -- Aplica a nova velocidade
        end
    end
})

-- Adicionar botão de alternância para ativar/desativar o FOV
SpeedTab:AddToggle("FOVToggle", {
    Title = "Ativar FOV 125",
    Default = false,
    Description = "Ative para aumentar o FOV para 125.",
    Callback = function(Value)
        fovEnabled = Value
        toggleFOV() -- Chama a função para ativar/desativar o FOV
    end
})

-- Adicionar slider para ajustar o FOV
SpeedTab:AddSlider("FOVSlider", {
    Title = "Ajustar FOV",
    Description = "Ajuste o FOV do jogador.",
    Default = originalFieldOfView,
    Min = 70, -- Valor mínimo típico para FOV
    Max = 125, -- Valor máximo para FOV
    Rounding = 1,
    Callback = function(Value)
        camera.FieldOfView = Value -- Atualiza o FOV sempre que o slider é ajustado
    end
})

-- Adicionar botão de alternância para ativar/desativar o Noclip
SpeedTab:AddToggle("NoclipToggle", {
    Title = "Ativar Noclip",
    Default = false,
    Description = "Ative para atravessar paredes.",
    Callback = function(Value)
        noclipEnabled = Value
        toggleNoclip() -- Chama a função para ativar/desativar o noclip
        if noclipEnabled then
            noclipLoop() -- Inicia o loop para manter o noclip ativo
        end
    end
})

-- Adicionar botão de alternância para ativar/desativar o Pulo Infinito
SpeedTab:AddToggle("InfiniteJumpToggle", {
    Title = "Ativar Pulo Infinito",
    Default = false,
    Description = "Ative para pular infinitamente.",
    Callback = function(Value)
        infiniteJumpEnabled = Value
        toggleInfiniteJump() -- Chama a função para ativar/desativar o pulo infinito
    end
})

-- Chama a função de monitoramento ao iniciar o script
monitorPlayer()




-- Função para ativar God Mode
local function activateGodMode()
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

    -- Verifica se o humanoide existe antes de aplicar o God Mode
    if humanoid then
        -- Mantém a saúde no valor máximo constantemente
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            humanoid.Health = humanoid.MaxHealth
        end)
        print("God Mode ativado.")
    else
        print("Erro: Humanoid não encontrado.")
    end
end

-- Função para desativar o God Mode (opcional)
local function deactivateGodMode()
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Disconnect()
        print("God Mode desativado.")
    end
end

-- Adicionando uma nova aba chamada "God Mod Prison Life"
local godModTab = Window:AddTab({ Title = "God Mod Prison Life", Icon = "shield" })

-- Botão para ativar God Mode
godModTab:AddButton({
    Title = "Ativar God Mode",
    Callback = function()
        activateGodMode()
    end
})

-- Botão para desativar God Mode
godModTab:AddButton({
    Title = "Desativar God Mode",
    Callback = function()
        deactivateGodMode()
    end
})


-- Adicionando uma aba para funções de teleporte
local teleportTab = Window:AddTab({ Title = "Teleport Functions", Icon = "teleport" })

-- Função para teletransportar para o terceiro item em "Criminals Spawn"
teleportTab:AddButton({
    Title = "Teleportar para Criminals Spawn (3º Item)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local target = workspace["Criminals Spawn"]:GetChildren()[3]
        
        if target then
            player.Character.HumanoidRootPart.CFrame = target.CFrame
            print("Teletransportado para o terceiro item do Criminals Spawn!")
        else
            print("Erro: Não foi possível encontrar o terceiro item.")
        end
    end
})

-- Função para teletransportar para AK-47
teleportTab:AddButton({
    Title = "Teleportar para AK-47",
    Callback = function()
        local player = game.Players.LocalPlayer
        local ak47 = workspace.Prison_ITEMS.giver:FindFirstChild("AK-47")

        if ak47 then
            player.Character.HumanoidRootPart.CFrame = ak47.CFrame
            print("Teletransportado para o AK-47!")
        else
            print("Erro: AK-47 não encontrado.")
        end
    end
})

-- Função para teletransportar para o spawn dos policiais (oitavo item)
teleportTab:AddButton({
    Title = "Teleportar para Guard Spawn (8º Item)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local guardSpawn = workspace.Prison_guardspawn:GetChildren()[8]

        if guardSpawn then
            player.Character.HumanoidRootPart.CFrame = guardSpawn.CFrame
            print("Teletransportado para o oitavo item do spawn dos guardas!")
        else
            print("Erro: Não foi possível encontrar o oitavo item no spawn dos guardas.")
        end
    end
})

-- Função para teletransportar para o topo de uma torre
teleportTab:AddButton({
    Title = "Teleportar para Torre",
    Callback = function()
        local player = game.Players.LocalPlayer
        local tower = workspace:FindFirstChild("Tower")

        if tower then
            player.Character.HumanoidRootPart.CFrame = tower.CFrame
            print("Teletransportado para o topo da torre!")
        else
            print("Erro: Torre não encontrada.")
        end
    end
})

-- Função para teletransportar até a munição de Shotgun
local function teleportToShotgunAmmo()
    local player = game.Players.LocalPlayer
    local shotgunAmmo = workspace.Prison_Guard_Outpost.furniture_armory:FindFirstChild("shotgun_ammo")

    if shotgunAmmo then
        player.Character.HumanoidRootPart.CFrame = shotgunAmmo.CFrame
        print("Teletransportado para a munição de Shotgun!")
    else
        print("Erro: Munição de Shotgun não encontrada.")
    end
end

-- Função para teletransportar até a munição de Rifle (Assault Rifle)
local function teleportToAssaultAmmo()
    local player = game.Players.LocalPlayer
    local assaultAmmo = workspace.Prison_Guard_Outpost.furniture_armory:FindFirstChild("assault_ammo")

    if assaultAmmo then
        player.Character.HumanoidRootPart.CFrame = assaultAmmo.CFrame
        print("Teletransportado para a munição de Assault Rifle!")
    else
        print("Erro: Munição de Assault Rifle não encontrada.")
    end
end

-- Adicionando a aba de teleporte para munição no menu de funções
local ammoTab = Window:AddTab({ Title = "Funções de Munição" })

-- Botão para teletransportar até a munição de Shotgun
ammoTab:AddButton({
    Title = "Teleportar para Munição de Shotgun",
    Callback = function()
        teleportToShotgunAmmo()
    end
})

-- Botão para teletransportar até a munição de Assault Rifle
ammoTab:AddButton({
    Title = "Teleportar para Munição de Assault Rifle",
    Callback = function()
        teleportToAssaultAmmo()
    end
})



-- Função para ativar invisibilidade (não visual)
local function ToggleInvisibility()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if character then
        -- Torna o personagem invisível de forma não visual
        character:FindFirstChild("Head").Transparency = 1 -- Torna a cabeça invisível
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = 1 -- Torna o corpo invisível
            elseif part:IsA("Accessory") then
                part.Handle.Transparency = 1 -- Torna os acessórios invisíveis
            end
        end
        
        character.HumanoidRootPart.CanCollide = false -- Desativa a colisão do corpo inteiro
        print("Invisibilidade ativada!")
    else
        print("Personagem não encontrado.")
    end
end

-- Função para carregar e executar o script do Infinite Yield
local function loadInfiniteYield()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end

-- Adicionando a nova aba "Infinity Admin"
local InfinityAdminTab = Window:AddTab({ Title = "Infinity Admin" })

-- Adicionando um botão para executar o script Infinite Yield
InfinityAdminTab:AddButton({
    Title = "Carregar Infinite Yield",
    Callback = function()
        loadInfiniteYield()
    end
})



-- Função para ativar God Mode
local function ToggleGodMode()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.MaxHealth = math.huge -- Define saúde máxima como infinita
            humanoid.Health = math.huge -- Define saúde atual como infinita
            print("God Mode ativado!")
        else
            print("Humanoid não encontrado.")
        end
    else
        print("Personagem não encontrado.")
    end
end

-- Adicionando a aba para invisibilidade e God Mode
local Tab = Window:AddTab({ Title = "Invisibilidade e God Mode", Icon = "shield" })

-- Botão para ativar invisibilidade
Tab:AddButton({
    Title = "Ativar Invisibilidade",
    Callback = ToggleInvisibility
})

-- Botão para ativar God Mode
Tab:AddButton({
    Title = "Ativar God Mode",
    Callback = ToggleGodMode
})


-- Função para Anti AFK
local function activateAntiAFK()
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Função para Anti Ban (Apenas um exemplo, isso não previne bans em todos os casos)
local function activateAntiBan()
    -- Exemplo básico, mas na prática banimentos são feitos pelo servidor e são difíceis de evitar.
    print("Anti Ban ativado")
end

-- Função para Anti Kick (Evita kick por inatividade)
local function activateAntiKick()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end

-- Função para Mensagens Automáticas
local function sendAutomaticMessages(message, delay)
    while true do
        wait(delay)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
    end
end

-- Adicionando a aba "Anti Proteções"
local AntiProtectionsTab = Window:AddTab({ Title = "Anti Proteções" })

-- Botão para ativar Anti AFK
AntiProtectionsTab:AddButton({
    Title = "Ativar Anti AFK",
    Callback = function()
        activateAntiAFK()
    end
})

-- Botão para ativar Anti Ban
AntiProtectionsTab:AddButton({
    Title = "Ativar Anti Ban",
    Callback = function()
        activateAntiBan()
    end
})

-- Botão para ativar Anti Kick
AntiProtectionsTab:AddButton({
    Title = "Ativar Anti Kick",
    Callback = function()
        activateAntiKick()
    end
})

-- Adicionando a aba "Mensagens Automáticas"
local AutoMessagesTab = Window:AddTab({ Title = "Mensagens Automáticas" })

-- Input para a mensagem e intervalo
AutoMessagesTab:AddInput("MessageInput", {
    Title = "Mensagem Automática",
    PlaceholderText = "Insira a mensagem",
    Callback = function(value)
        messageInput = value
    end
})

AutoMessagesTab:AddInput("DelayInput", {
    Title = "Intervalo (em segundos)",
    PlaceholderText = "Insira o intervalo",
    Callback = function(value)
        delayInput = tonumber(value)
    end
})

-- Botão para iniciar mensagens automáticas
AutoMessagesTab:AddButton({
    Title = "Iniciar Mensagens Automáticas",
    Callback = function()
        if messageInput and delayInput then
            sendAutomaticMessages(messageInput, delayInput)
        else
            warn("Insira uma mensagem e um intervalo válidos.")
        end
    end
})

-- Função para verificar se um item existe
local function itemExists(assetId)
    local success, response = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(assetId)
    end)
    return success and response and response.AssetTypeId ~= nil
end

-- Função aprimorada para aplicar roupas do Roblox
local function applyClothing(itemType, assetId)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        -- Verifica se o item existe antes de aplicar
        if itemExists(assetId) then
            if itemType == "Shirt" then
                local shirt = Instance.new("Shirt")
                shirt.ShirtTemplate = "rbxassetid://" .. assetId
                shirt.Parent = character
                print("Camiseta aplicada com sucesso.")
            elseif itemType == "Pants" then
                local pants = Instance.new("Pants")
                pants.PantsTemplate = "rbxassetid://" .. assetId
                pants.Parent = character
                print("Calça aplicada com sucesso.")
            elseif itemType == "Hat" then
                local hat = Instance.new("Hat")
                hat.AttachmentPoint = CFrame.new(0, 0, 0)
                hat.TextureId = "rbxassetid://" .. assetId
                hat.Parent = character
                print("Chapéu aplicado com sucesso.")
            elseif itemType == "Animation" then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://" .. assetId
                humanoid:LoadAnimation(animation)
                print("Animação aplicada com sucesso.")
            else
                warn("Tipo de item inválido.")
            end
        else
            warn("ID do item inválido ou item não encontrado.")
        end
    else
        warn("Personagem não encontrado.")
    end
end

-- Adicionando a aba de Troca de Roupas
local ClothingTab = Window:AddTab({ Title = "Troca de Roupas", Icon = "shirt" })

-- Input para ID da Camiseta
ClothingTab:AddInput("ShirtIDInput", {
    Title = "ID da Camiseta",
    PlaceholderText = "Insira o ID da camiseta",
    Callback = function(value)
        applyClothing("Shirt", value)
    end
})

-- Input para ID da Calça
ClothingTab:AddInput("PantsIDInput", {
    Title = "ID da Calça",
    PlaceholderText = "Insira o ID da calça",
    Callback = function(value)
        applyClothing("Pants", value)
    end
})

-- Input para ID do Chapéu (ou qualquer acessório)
ClothingTab:AddInput("HatIDInput", {
    Title = "ID do Chapéu",
    PlaceholderText = "Insira o ID do chapéu",
    Callback = function(value)
        applyClothing("Hat", value)
    end
})

-- Input para ID da Animação
ClothingTab:AddInput("AnimationIDInput", {
    Title = "ID da Animação",
    PlaceholderText = "Insira o ID da animação",
    Callback = function(value)
        applyClothing("Animation", value)
    end
})

-- Botão para aplicar todas as roupas
ClothingTab:AddButton({
    Title = "Aplicar Roupas",
    Callback = function()
        local shirtId = ClothingTab:GetInput("ShirtIDInput")
        local pantsId = ClothingTab:GetInput("PantsIDInput")
        local hatId = ClothingTab:GetInput("HatIDInput")
        local animationId = ClothingTab:GetInput("AnimationIDInput")

        if shirtId and shirtId ~= "" then
            applyClothing("Shirt", shirtId)
        end
        if pantsId and pantsId ~= "" then
            applyClothing("Pants", pantsId)
        end
        if hatId and hatId ~= "" then
            applyClothing("Hat", hatId)
        end
        if animationId and animationId ~= "" then
            applyClothing("Animation", animationId)
        end
    end
})

-- Tabela para armazenar todas as linhas e textos de ESP
local espLines = {}
local espText = {}
local espEnabled = false

-- Função para criar uma linha de ESP entre o jogador local e outros jogadores
local function createESP(player)
    -- Criar linha de ESP
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Transparency = 1
    
    -- Criar texto de nome e distância
    local text = Drawing.new("Text")
    text.Size = 18
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Center = true
    text.Outline = true

    -- Armazenar na tabela
    espLines[player] = line
    espText[player] = text

    -- Atualizar linha e texto
    local function updateESP()
        if not espEnabled then
            line.Visible = false
            text.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local localPlayer = game.Players.LocalPlayer
            local localCharacter = localPlayer.Character
            local humanoidRootPart = player.Character.HumanoidRootPart

            -- Verifica se o jogador local tem um personagem válido
            if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
                local localHRP = localCharacter.HumanoidRootPart
                
                -- Converter as posições do mundo para a tela
                local targetPos, onScreenTarget = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                local localPos, onScreenLocal = workspace.CurrentCamera:WorldToViewportPoint(localHRP.Position)
                
                -- Calcular distância entre o jogador local e o alvo
                local distance = (humanoidRootPart.Position - localHRP.Position).Magnitude
                
                if onScreenTarget and onScreenLocal then
                    -- Atualizar a linha de ESP
                    line.From = Vector2.new(localPos.X, localPos.Y)
                    line.To = Vector2.new(targetPos.X, targetPos.Y)
                    line.Visible = true
                    
                    -- Atualizar texto com nome e distância
                    text.Text = string.format("%s\n%.2f studs", player.Name, distance)
                    text.Position = Vector2.new(targetPos.X, targetPos.Y - 25) -- Exibir acima da cabeça do jogador
                    text.Visible = true
                else
                    line.Visible = false
                    text.Visible = false
                end
            else
                line.Visible = false
                text.Visible = false
            end
        else
            line.Visible = false
            text.Visible = false
        end
    end

    -- Atualizar a linha enquanto o jogador está no jogo
    game:GetService("RunService").RenderStepped:Connect(updateESP)
end

-- Função para ativar ESP para todos os jogadores no servidor
local function enableESPForPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end
    
    -- Adicionar ESP para novos jogadores que entrarem no servidor
    game.Players.PlayerAdded:Connect(function(player)
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end)
end

-- Função para desativar ESP
local function disableESP()
    for player, line in pairs(espLines) do
        if line then
            line.Visible = false
            line:Remove() -- Remove a linha da tela
            espLines[player] = nil -- Remove da tabela
        end
    end
    for player, text in pairs(espText) do
        if text then
            text.Visible = false
            text:Remove() -- Remove o texto da tela
            espText[player] = nil -- Remove da tabela
        end
    end
end

-- Aba de ESP Line na interface
local ESPTab = Window:AddTab({ Title = "ESP Line", Icon = "esp" })

-- Toggle para ativar/desativar ESP
ESPTab:AddToggle("ESPToggle", {
    Title = "Ativar ESP Line",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            enableESPForPlayers()
            print("ESP Line ativado.")
        else
            disableESP()
            print("ESP Line desativado.")
        end
    end
})

-- Aba para visualizar os jogadores
local PlayersTab = Window:AddTab({ Title = "Lista de Jogadores", Icon = "players" })

-- Campo de texto para mostrar os nomes dos jogadores
PlayersTab:AddParagraph({ 
    Title = "Jogadores Atuais", 
    Content = "Nenhum jogador encontrado."
})

-- Botão para atualizar a lista de jogadores
PlayersTab:AddButton({
    Title = "Atualizar Lista de Jogadores",
    Callback = function()
        local playerList = listPlayers()
        local playerText = table.concat(playerList, "\n")
        if #playerList == 0 then
            playerText = "Nenhum jogador encontrado."
        end
        -- Atualizando o parágrafo com os nomes dos jogadores
        PlayersTab:UpdateParagraph({ 
            Title = "Jogadores Atuais", 
            Content = playerText 
        })
        print("Lista de jogadores atualizada.")
    end
})



-- Função para ativar a aparência headless e a perna da Korblox
local function EquipKorbloxHeadless()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Verifica se a cabeça e as pernas da Korblox estão disponíveis
    local headless = game.ServerStorage:FindFirstChild("Headless") -- Certifique-se de que o modelo "Headless" esteja no ServerStorage
    local korbloxLegs = game.ServerStorage:FindFirstChild("KorbloxLegs") -- Certifique-se de que o modelo "KorbloxLegs" esteja no ServerStorage

    if headless and korbloxLegs then
        -- Remove a cabeça atual
        if character:FindFirstChild("Head") then
            character.Head:Destroy()
        end

        -- Clona a cabeça headless e a perna da Korblox para o personagem
        local newHead = headless:Clone()
        newHead.Parent = character
        newHead.Name = "Head" -- Renomeia para "Head" para funcionar corretamente

        local newLegs = korbloxLegs:Clone()
        newLegs.Parent = character
        newLegs.Name = "KorbloxLegs" -- Renomeia para "KorbloxLegs" para funcionar corretamente

        print("Aparência headless e perna da Korblox ativadas!")
    else
        print("Modelos não encontrados. Certifique-se de que eles estejam no ServerStorage.")
    end
end

-- Adicionando o botão na nova aba
local Tab = Window:AddTab({ Title = "Korblox", Icon = "face" })

Tab:AddButton({
    Title = "Ativar Headless e Korblox",
    Callback = EquipKorbloxHeadless
})



local spinEnabled = false
local spinSpeed = 50

-- Adicionando a aba de Spin na interface existente
local SpinTab = Window:AddTab({ Title = "Spin", Icon = "spin" })

-- Toggle para ativar/desativar o Spin
local SpinToggle = SpinTab:AddToggle("SpinToggle", {
    Title = "Ativar Spin",
    Default = false,
    Description = "Ative para começar a girar.",
    Callback = function(value)
        spinEnabled = value
        if spinEnabled then
            print("Spin ativado.")
            StartSpin() -- Chama a função de spin
        else
            print("Spin desativado.")
        end
    end
})

-- Slider para ajustar a velocidade do Spin
SpinTab:AddSlider("SpinSpeedSlider", {
    Title = "Velocidade do Spin",
    Description = "Ajuste a velocidade do giro.",
    Default = 50,
    Min = 1,
    Max = 500,  -- Aumentamos o valor máximo do slider para 500
    Rounding = 1,
    Callback = function(Value)
        spinSpeed = Value
        print("Velocidade de spin ajustada para:", Value)
    end
})

-- Função para iniciar o Spin
function StartSpin()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Loop contínuo enquanto o Spin estiver ativado
    while spinEnabled do
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        wait(0.01) -- Reduzimos o tempo de espera para 0.01 para acelerar o giro
    end
end

-- Botão para ativar/desativar manualmente o Spin
SpinTab:AddButton({
    Title = "Ativar/Desativar Spin",
    Callback = function()
        spinEnabled = not spinEnabled
        if spinEnabled then
            print("Spin manualmente ativado.")
            StartSpin()
        else
            print("Spin manualmente desativado.")
        end
    end
})


-- Função de Kill
Tabs.Main:AddInput("KillUserInput", {
    Title = "Matar Usuário",
    Placeholder = "Nome do jogador",
    Callback = function(Value)
        local targetPlayer = game.Players:FindFirstChild(Value)
        if targetPlayer and targetPlayer.Character then
            -- Clonando o ônibus do Brookhaven
            local bus = game.Workspace:WaitForChild("Bus"):Clone()
            bus.Parent = game.Workspace

            -- Teleportando o ônibus para o jogador
            bus:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)

            -- Jogando o ônibus no void
            bus.PrimaryPart.Velocity = Vector3.new(0, -500, 0) -- Ajuste a força se necessário

            print("Jogador " .. Value .. " foi eliminado com sucesso!")
        else
            print("Jogador não encontrado.")
        end
    end
})



-- Função para criar ESP nos carros
local function createESP(object)
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Size = object.Size
    espBox.Color3 = Color3.new(1, 0, 0) -- Cor vermelha
    espBox.Transparency = 0.5 -- Um pouco transparente
    espBox.AlwaysOnTop = true
    espBox.Parent = object
end

local espEnabled = false
Tabs.Main:AddToggle("EspCarrosToggle", {
    Title = "ESP Carros",
    Default = false,
    Description = "Ativar/Desativar ESP nos carros."
})

-- Função para atualizar ESP nos carros
local function updateESP()
    while espEnabled do
        for _, object in pairs(workspace:GetChildren()) do
            if object:IsA("Model") and object:FindFirstChild("PrimaryPart") then
                if object.Name:match("Car") then -- Verifique se o modelo é um carro
                    if not object:FindFirstChild("ESP") then
                        createESP(object)
                        object.Name = object.Name .. "ESP" -- Renomeia para evitar duplicatas
                    end
                end
            end
        end
        wait(1) -- Atualiza a cada segundo
    end
end

-- Variáveis para o modo Rainbow
local isRainbowEnabled = false
local rainbowSpeed = 1
local rainbowCoroutine -- Para gerenciar a execução do efeito Rainbow

-- Função para ativar o modo Rainbow
local function enableRainbow()
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Inicia uma nova coroutine para o efeito Rainbow
        rainbowCoroutine = coroutine.create(function()
            while isRainbowEnabled do
                local time = tick() * rainbowSpeed
                -- Gerando cores do arco-íris usando seno para os componentes RGB
                local r = math.sin(time) * 0.5 + 0.5
                local g = math.sin(time + (math.pi / 3)) * 0.5 + 0.5
                local b = math.sin(time + (math.pi * 2 / 3)) * 0.5 + 0.5

                -- Aplicando as cores ao HumanoidRootPart
                humanoidRootPart.Color = Color3.new(r, g, b)
                wait(0.1) -- Ajuste a velocidade do efeito, quanto menor o valor, mais rápido o efeito
            end
        end)

        coroutine.resume(rainbowCoroutine)
    end
end

-- Função para desativar o modo Rainbow
local function disableRainbow()
    isRainbowEnabled = false
end

-- Adicionando a aba Rainbow
local RainbowTab = Window:AddTab({ Title = "Rainbow", Icon = "rainbow" })

-- Adicionando toggle para ativar/desativar Rainbow
RainbowTab:AddToggle("RainbowToggle", {
    Title = "Ativar Rainbow",
    Default = false,
    Description = "Ativar modo Rainbow para o seu personagem.",
    Callback = function(Value)
        isRainbowEnabled = Value
        if Value then
            enableRainbow()
        else
            disableRainbow() -- Desativa o efeito se o toggle for desligado
            if rainbowCoroutine then
                coroutine.close(rainbowCoroutine) -- Encerra a coroutine quando desativa
            end
        end
    end
})




-- Função para ativar o Highlight
local function enableHighlight()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name ~= game.Players.LocalPlayer.Name and player.Character then
            -- Verifica se o personagem já possui um Highlight e o remove
            for _, highlight in pairs(player.Character:GetChildren()) do
                if highlight:IsA("Highlight") then
                    highlight:Destroy()
                end
            end

            -- Cria um novo Highlight
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.OutlineColor = Color3.new(1, 0, 0) -- Cor da borda (vermelho)
            highlight.FillColor = Color3.new(1, 0, 0) -- Cor de preenchimento (vermelho)
            highlight.Adornee = player.Character
        end
    end
end

-- Função para desativar o Highlight
local function disableHighlight()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            for _, highlight in pairs(player.Character:GetChildren()) do
                if highlight:IsA("Highlight") then
                    highlight:Destroy() -- Remove o Highlight
                end
            end
        end
    end
end

-- Adicionando a aba "Highlight"
local HighlightTab = Window:AddTab({ Title = "Highlight", Icon = "highlight" })

-- Botão para ativar o Highlight
HighlightTab:AddButton({
    Title = "Ativar Highlight",
    Callback = function()
        enableHighlight()
        print("Highlight ativado.")
    end
})

-- Botão para desativar o Highlight
HighlightTab:AddButton({
    Title = "Desativar Highlight",
    Callback = function()
        disableHighlight()
        print("Highlight desativado.")
    end
})

-- Função para ativar/desativar o Anti-Aim
local function toggleAntiAim()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.PlatformStand = not humanoid.PlatformStand -- Alterna o estado de PlatformStand
        if humanoid.PlatformStand then
            -- Ativa o Anti-Aim
            while humanoid.PlatformStand do
                wait(0.1) -- Intervalo de tempo
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.random(-5, 5) * math.pi / 180, 0)
            end
        end
    end
end

-- Função para ativar/desativar o Anti-Aim
local function toggleAntiAim()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.PlatformStand = not humanoid.PlatformStand -- Alterna o estado de PlatformStand
        if humanoid.PlatformStand then
            -- Ativa o Anti-Aim
            while humanoid.PlatformStand do
                wait(0.1) -- Intervalo de tempo
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.random(-5, 5) * math.pi / 180, 0)
            end
        end
    end
end

-- Adicionando a aba de Anti-Aim
local antiAimTab = Window:AddTab({ Title = "Anti-Aim", Icon = "shield" })

-- Botão para ativar/desativar o Anti-Aim
antiAimTab:AddButton({
    Title = "Ativar/Desativar Anti-Aim",
    Callback = function()
        toggleAntiAim()
    end
})


-- Função para ativar o FPS Booster
local function activateFPSBooster()
    loadstring(game:HttpGet("https://pastebin.com/raw/8YZ2cc6V"))()
    print("FPS Booster ativado.")
end

-- Função para desativar o FPS Booster (opcional, dependendo do script)
local function deactivateFPSBooster()
    -- Aqui você pode adicionar a lógica para desativar o FPS Booster, se necessário
    print("FPS Booster desativado (se aplicável).")
end

-- Adicionar aba "FPS Booster"
local FPSBoosterTab = Window:AddTab({ Title = "FPS Booster", Icon = "fps" })

-- Adicionar botão de alternância para ativar/desativar o FPS Booster
FPSBoosterTab:AddToggle("FPSBoosterToggle", {
    Title = "Ativar FPS Booster",
    Default = false,
    Description = "Ative para aumentar o FPS do jogo.",
    Callback = function(Value)
        if Value then
            activateFPSBooster()
        else
            deactivateFPSBooster() -- Caso queira implementar uma lógica de desativação
        end
    end
})


-- Função para tocar música no jogo
local function playMusic(assetId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. assetId
    sound.Looped = true -- Toca em loop
    sound.Parent = game.Workspace
    sound:Play()

    -- Para garantir que o som seja ouvido por todos
    game.Players.PlayerAdded:Connect(function(player)
        local clone = sound:Clone()
        clone.Parent = player:WaitForChild("PlayerGui") -- Adiciona ao PlayerGui de cada jogador
        clone:Play()
    end)

    print("Música tocando com ID:", assetId)
end

-- Adicionando a aba de Música
local musicTab = Window:AddTab({ Title = "Música", Icon = "music" })

-- Input para ID da Música
musicTab:AddInput("MusicIDInput", {
    Title = "ID da Música",
    PlaceholderText = "Insira o ID da música",
    Callback = function(value)
        playMusic(value)
    end
})

-- Botão para parar a música
musicTab:AddButton({
    Title = "Parar Música",
    Callback = function()
        for _, sound in ipairs(workspace:GetChildren()) do
            if sound:IsA("Sound") then
                sound:Stop()
                sound:Destroy() -- Remove o som do workspace
            end
        end
        print("Música parada.")
    end
})

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local hopping = false

-- Função que ativa o Bunny Hop
local function enableBunnyHop()
    hopping = true
    while hopping do
        wait(0.1) -- Ajuste a velocidade do pulo
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

-- Função que desativa o Bunny Hop
local function disableBunnyHop()
    hopping = false
end

-- Adicionando a aba de Bunny Hop
local BunnyHopTab = Window:AddTab({ Title = "Bunny Hop", Icon = "jump" })

-- Botão para ativar Bunny Hop
BunnyHopTab:AddButton({
    Title = "Ativar Bunny Hop",
    Callback = function()
        if not hopping then
            enableBunnyHop()
        end
    end
})

-- Botão para desativar Bunny Hop
BunnyHopTab:AddButton({
    Title = "Desativar Bunny Hop",
    Callback = function()
        disableBunnyHop()
    end
})

-- Função para aplicar animações personalizadas
local function applyAnimation(animationId)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. animationId
        humanoid:LoadAnimation(animation):Play()
    else
        warn("Humanoide não encontrado.")
    end
end

-- Adicionando a aba de Animações
local AnimationTab = Window:AddTab({ Title = "Animações", Icon = "animation" })

-- Input para ID da Animação
AnimationTab:AddInput("AnimationIDInput", {
    Title = "ID da Animação",
    PlaceholderText = "Insira o ID da animação",
    Callback = function(value)
        applyAnimation(value)
    end
})

-- Botão para aplicar a animação
AnimationTab:AddButton({
    Title = "Aplicar Animação",
    Callback = function()
        local animationId = AnimationTab:GetInput("AnimationIDInput")
        if animationId and animationId ~= "" then
            applyAnimation(animationId)
        else
            warn("ID da animação inválido.")
        end
    end
})

-- Exemplo de animações padrão
local defaultAnimations = {
    { Name = "Dançar", ID = "507771019" }, -- ID de animação para dançar
    { Name = "Correr", ID = "180435571" }, -- ID de animação para correr
    { Name = "Agachar", ID = "507771019" } -- ID de animação para agachar
}

-- Adicionando botões para animações padrão
for _, anim in pairs(defaultAnimations) do
    AnimationTab:AddButton({
        Title = "Animar: " .. anim.Name,
        Callback = function()
            applyAnimation(anim.ID)
        end
    })
end

-- Função para criar uma espada mágica com efeitos visuais
local function createMagicSword()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Criar a espada
    local sword = Instance.new("Tool")
    sword.Name = "Espada Mágica"
    sword.RequiresHandle = true

    -- Criar a parte da lâmina da espada
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 5, 1)
    handle.BrickColor = BrickColor.new("Bright blue") -- Cor da espada
    handle.Material = Enum.Material.Neon -- Material brilhante
    handle.Anchored = false
    handle.CanCollide = false
    handle.Parent = sword

    -- Efeito visual da espada
    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Range = 10
    light.Color = Color3.new(0, 0, 1) -- Azul
    light.Parent = handle

    -- Adicionando animação ao segurar a espada
    sword.Equipped:Connect(function()
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://507771019" -- ID da animação de ataque
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:LoadAnimation(animation):Play()
        end
    end)

    sword.Parent = player.Backpack -- Coloca a espada no inventário do jogador
end

-- Adicionando a aba de Espada Mágica
local SwordTab = Window:AddTab({ Title = "Espada Mágica", Icon = "sword" })

-- Botão para criar a espada mágica
SwordTab:AddButton({
    Title = "Criar Espada Mágica",
    Callback = function()
        createMagicSword()
    end
})

-- Função para adicionar poderes especiais à espada
local function applySwordPowers()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local sword = character:FindFirstChild("Espada Mágica")

    if sword then
        -- Adicionando efeitos ao atacar
        sword.Activated:Connect(function()
            local explosion = Instance.new("Explosion")
            explosion.Position = character.HumanoidRootPart.Position + Vector3.new(0, -2, 0) -- Posição do impacto
            explosion.BlastRadius = 5
            explosion.BlastPressure = 0 -- Para evitar danos a outros jogadores
            explosion.Parent = game.Workspace
        end)
    else
        warn("Espada Mágica não encontrada.")
    end
end

-- Botão para aplicar poderes à espada
SwordTab:AddButton({
    Title = "Aplicar Poderes à Espada",
    Callback = function()
        applySwordPowers()
    end
})

-- Adicionando uma aba para a música global no hub
local MusicTab = Window:AddTab({ Title = "Música Global", Icon = "music" })

-- Função para tocar a música globalmente
local function playGlobalMusic(musicID)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local character = player.Character
            local sound = Instance.new("Sound", character:FindFirstChild("Head") or character.PrimaryPart)
            sound.SoundId = "rbxassetid://" .. musicID
            sound.Looped = false -- Defina como true se quiser que a música fique em loop
            sound.Volume = 5 -- Ajuste o volume conforme necessário
            sound:Play()
        end
    end
end

-- Input para o ID da música
MusicTab:AddInput("MusicIDInput", {
    Title = "ID da Música",
    PlaceholderText = "Insira o ID da música",
    Callback = function(value)
        playGlobalMusic(value)
    end
})

-- Botão para iniciar a música
MusicTab:AddButton({
    Title = "Tocar Música",
    Callback = function()
        local musicId = MusicTab:GetInput("MusicIDInput")
        if musicId and musicId ~= "" then
            playGlobalMusic(musicId)
        else
            warn("ID da música inválido.")
        end
    end
})

-- Botão para parar a música
MusicTab:AddButton({
    Title = "Parar Música",
    Callback = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                for _, sound in pairs(player.Character:GetChildren()) do
                    if sound:IsA("Sound") then
                        sound:Stop()
                        sound:Destroy()
                    end
                end
            end
        end
    end
})

-- Função para calcular a data de criação da conta
local function getAccountCreationDate(player)
    local daysOld = player.AccountAge
    local currentTime = os.time()
    local accountCreationTime = currentTime - (daysOld * 86400) -- 86400 segundos em um dia
    return os.date("%d/%m/%Y", accountCreationTime) -- Formato de data: DD/MM/AAAA
end

-- Adicionando uma aba para visualizar a data de criação da conta
local AccountTab = Window:AddTab({ Title = "Data de Criação da Conta", Icon = "calendar" })

-- Input para selecionar o usuário
AccountTab:AddInput("PlayerNameInput", {
    Title = "Nome do Jogador",
    PlaceholderText = "Insira o nome do jogador",
    Callback = function(playerName)
        local player = game.Players:FindFirstChild(playerName)
        if player then
            local creationDate = getAccountCreationDate(player)
            AccountTab:AddLabel({ Title = "Data de Criação: " .. creationDate })
        else
            warn("Jogador não encontrado.")
        end
    end
})

-- Função para girar e jogar o jogador no void
local function bringAndSpin(targetPlayerName)
    local localPlayer = game.Players.LocalPlayer
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)

    if targetPlayer and targetPlayer.Character and localPlayer.Character then
        -- Pegando as partes importantes dos personagens
        local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHumanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        -- Verifica se ambos os jogadores têm a HumanoidRootPart
        if targetHumanoidRootPart and localHumanoidRootPart then
            -- Começa a girar e mover o jogador alvo ao redor do jogador local
            local spinning = true
            local spinSpeed = 5 -- Velocidade da rotação
            local heightDecreaseRate = 1 -- Taxa de queda no void
            
            -- Cria um loop para girar o jogador em torno de você
            while spinning do
                -- Calcula a posição ao redor do jogador local
                local newPosition = localHumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0) * CFrame.new(10, 0, 0)
                -- Aplica a nova posição ao jogador alvo
                targetHumanoidRootPart.CFrame = newPosition
                
                -- Reduz a altura do jogador alvo, movendo-o gradualmente para o void
                targetHumanoidRootPart.Position = targetHumanoidRootPart.Position - Vector3.new(0, heightDecreaseRate, 0)

                -- Verifica se o jogador alvo caiu no void
                if targetHumanoidRootPart.Position.Y < -500 then
                    spinning = false -- Para o loop quando o jogador cair no void
                    print(targetPlayerName .. " foi jogado no void.")
                end

                wait(0.1) -- Intervalo de tempo para controlar a velocidade de rotação
            end
        else
            warn("HumanoidRootPart não encontrada no jogador alvo ou no jogador local.")
        end
    else
        warn("Jogador alvo não encontrado ou sem personagem.")
    end
end

-- Adicionando uma aba para o Bring com giro
local BringTab = Window:AddTab({ Title = "Bring e Girar", Icon = "rotate" })

-- Input para selecionar o jogador alvo
BringTab:AddInput("PlayerNameInput", {
    Title = "Nome do Jogador",
    PlaceholderText = "Insira o nome do jogador",
    Callback = function(playerName)
        bringAndSpin(playerName)
    end
})

-- Função de Stealth Mode
local function stealthMode()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Esconde o nome do jogador da lista
    playerGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

    -- Tira o nome da cabeça do personagem
    if player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        for _, part in pairs(head:GetChildren()) do
            if part:IsA("BillboardGui") then
                part:Destroy()
            end
        end
    end
end

-- Aba para Stealth Mode
local StealthModeTab = Window:AddTab({ Title = "Stealth Mode", Icon = "user-secret" })

StealthModeTab:AddButton({
    Title = "Ativar Modo Furtivo",
    Callback = function()
        stealthMode()
    end
})


-- Função para dar kick em um jogador
local function kickPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)  -- Procura o jogador pelo nome

    if player then
        player:Kick("Você foi expulso do jogo!")  -- Executa o kick
        print(playerName .. " foi expulso.")  -- Log de confirmação
    else
        warn("Jogador " .. playerName .. " não encontrado.")  -- Log de erro se o jogador não foi encontrado
    end
end

-- Adicionando a aba de Kick no seu hub
local kickTab = Window:AddTab({ Title = "Kick", Icon = "kick" })

-- Input para o nome do jogador
kickTab:AddInput("PlayerNameInput", {
    Title = "Nome do Jogador",
    PlaceholderText = "Insira o nome do jogador a ser expulso",
    Callback = function(value)
        kickPlayer(value)  -- Chama a função de kick quando o nome for fornecido
    end
})

-- Botão para executar o kick
kickTab:AddButton({
    Title = "Expelir Jogador",
    Callback = function()
        local playerName = kickTab:GetInput("PlayerNameInput")  -- Obtém o nome do jogador do input
        kickPlayer(playerName)  -- Chama a função de kick
    end
})

-- Função para focar a câmera em outro jogador
local function viewUser(targetPlayerName)
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        -- Define a câmera para seguir o Humanoid do jogador alvo
        camera.CameraSubject = targetPlayer.Character.Humanoid
        camera.CameraType = Enum.CameraType.Custom
        print("Agora você está visualizando:", targetPlayerName)
    else
        print("Jogador não encontrado ou sem personagem!")
    end
end

-- Função para retornar a câmera ao jogador original
local function resetView()
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    -- Define a câmera para voltar a seguir o próprio jogador
    camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
    camera.CameraType = Enum.CameraType.Custom
    print("Visualização retornada para o seu personagem.")
end

-- Adicionando uma aba para "View User"
local viewUserTab = Window:AddTab({ Title = "View User", Icon = "camera" })

-- Input para inserir o nome do jogador que deseja visualizar
viewUserTab:AddInput("PlayerNameInput", {
    Title = "Nome do Jogador",
    PlaceholderText = "Insira o nome do jogador",
    Callback = function(value)
        viewUser(value)  -- Chama a função para visualizar o jogador inserido
    end
})

-- Botão para retornar a visualização para o jogador
viewUserTab:AddButton({
    Title = "Retornar Visualização",
    Callback = function()
        resetView()  -- Chama a função para retornar ao personagem original
    end
})

-- Função para teleporte no clique
local function teleportToClick()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()

    -- Detecta quando o jogador clica
    mouse.Button1Down:Connect(function()
        if mouse.Target then
            -- Teleporta o jogador para o ponto clicado
            local targetPosition = mouse.Hit.p
            local character = player.Character or player.CharacterAdded:Wait()

            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                print("Teleportado para:", targetPosition)
            end
        end
    end)
end

-- Variável para armazenar a conexão do teleporte
local teleportConnection

-- Função para teleporte por clique
local function teleportToClick()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()

    -- Verifica se já existe uma conexão ativa, para evitar múltiplas conexões
    if teleportConnection then
        teleportConnection:Disconnect()
    end

    -- Conecta o evento do clique do mouse para o teleporte
    teleportConnection = mouse.Button1Down:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p)  -- Teleporta para a posição clicada
        end
    end)

    print("Teleporte por clique ativado.")
end

-- Função para desativar o teleporte por clique
local function disableTeleport()
    -- Verifica se a conexão existe, e então desconecta
    if teleportConnection then
        teleportConnection:Disconnect()
        teleportConnection = nil  -- Limpa a variável para evitar problemas futuros
        print("Teleporte por clique desativado.")
    else
        print("Nenhuma conexão de teleporte ativa para desativar.")
    end
end

-- Adicionando uma aba para o "TP Click"
local tpClickTab = Window:AddTab({ Title = "TP Click", Icon = "teleport" })

-- Botão para ativar o teleporte por clique
tpClickTab:AddButton({
    Title = "Ativar TP por Clique",
    Callback = function()
        teleportToClick()  -- Ativa o teleporte por clique
    end
})

-- Botão para desativar o teleporte por clique
tpClickTab:AddButton({
    Title = "Desativar TP por Clique",
    Callback = function()
        disableTeleport()  -- Desativa o teleporte por clique
    end
})


-- Função para ativar o Carro Fly
local function enableCarFly()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Verifica se o jogador está dentro de um veículo
    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart

        -- Verifica o veículo do jogador
        local vehicle = player.Character.Parent:FindFirstChildWhichIsA("VehicleSeat")

        if vehicle then
            print("Carro detectado! Ativando voo...")

            -- Conecta a tecla de movimentação (W, A, S, D)
            local userInput = game:GetService("UserInputService")
            local flying = true
            local speed = 50

            -- Movimentação do carro voador
            local function fly(direction)
                while flying do
                    wait(0.1)
                    if direction == "forward" then
                        vehicle.Velocity = humanoidRootPart.CFrame.lookVector * speed
                    elseif direction == "backward" then
                        vehicle.Velocity = -humanoidRootPart.CFrame.lookVector * speed
                    elseif direction == "up" then
                        vehicle.Velocity = Vector3.new(0, speed, 0)
                    elseif direction == "down" then
                        vehicle.Velocity = Vector3.new(0, -speed, 0)
                    end
                end
            end

            -- Detecta as teclas pressionadas
            userInput.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W then
                    fly("forward")
                elseif input.KeyCode == Enum.KeyCode.S then
                    fly("backward")
                elseif input.KeyCode == Enum.KeyCode.Space then
                    fly("up")
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    fly("down")
                end
            end)

            -- Detecta quando as teclas são soltas
            userInput.InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
                    flying = false
                    vehicle.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        else
            warn("Você não está em um veículo!")
        end
    end
end

-- Função para desativar o Carro Fly
local function disableCarFly()
    print("Carro Fly desativado.")
end

-- Adicionando uma aba para o "Carro Fly"
local carFlyTab = Window:AddTab({ Title = "Carro Fly", Icon = "car" })

-- Botão para ativar o Carro Fly
carFlyTab:AddButton({
    Title = "Ativar Carro Fly",
    Callback = function()
        enableCarFly()
    end
})

-- Botão para desativar o Carro Fly (opcional)
carFlyTab:AddButton({
    Title = "Desativar Carro Fly",
    Callback = function()
        disableCarFly()
    end
})



-- Adicionando uma nova aba chamada "Teleport"
local TeleportTab = Window:AddTab({ Title = "Teleport", Icon = "map" })

-- Função para teletransportar para um jogador
local function teleportToPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = player.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0)) -- Teleporta um pouco acima do jogador
        print("Teletransportado para:", playerName)
    else
        print("Jogador não encontrado ou não está no jogo.")
    end
end

-- Adicionando um campo de entrada para inserir o nome do jogador
TeleportTab:AddInput("TeleportPlayerInput", {
    Title = "Nome do Jogador",
    Placeholder = "Insira o nome do jogador",
    Callback = function(Value)
        teleportToPlayer(Value)
    end
})

-- Adicionando um botão para teleportar
TeleportTab:AddButton({
    Title = "Teletransportar",
    Callback = function()
        local playerName = TeleportTab:GetInputValue("TeleportPlayerInput")
        teleportToPlayer(playerName)
    end
})

-- Função para teleportar para um local pré-definido (exemplo: Spawn)
local function teleportToLocation(location)
    if location == "Spawn" then
        local spawnLocation = workspace:FindFirstChild("SpawnLocation") -- Certifique-se de que haja um SpawnLocation no seu mapa
        if spawnLocation then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawnLocation.CFrame
            print("Teletransportado para o Spawn.")
        else
            print("SpawnLocation não encontrado.")
        end
    end
end

-- Adicionando um botão para teleportar para o Spawn
TeleportTab:AddButton({
    Title = "Teletransportar para o Spawn",
    Callback = function()
        teleportToLocation("Spawn")
    end
})




-- Função de Fly
local flyEnabled = false
local flySpeed = 50
Tabs.Main:AddToggle("FlyToggle", {
    Title = "Fly",
    Default = false,
    Description = "Ativar/Desativar Fly."
})

Tabs.Main:AddSlider("FlySpeedSlider", {
    Title = "Velocidade de Voo",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        flySpeed = Value
        print("Velocidade de voo ajustada para:", Value)
    end
})

Tabs.Main:AddButton({
    Title = "Ativar Fly",
    Callback = function()
        flyEnabled = not flyEnabled
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = character.HumanoidRootPart

        while flyEnabled do
            bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
            wait()
        end
        bodyVelocity:Destroy()
        print("Fly desativado.")
    end
})


-- Função de View
Tabs.Main:AddInput("ViewPlayerInput", {
    Title = "Ver Jogador",
    Placeholder = "Nome do jogador",
    Callback = function(Value)
        local player = game.Players:FindFirstChild(Value)
        if player and player.Character then
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            workspace.CurrentCamera.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 10) -- Ajuste a posição da câmera
            print("Visualizando:", Value)
        else
            print("Jogador não encontrado.")
        end
    end
    
})

Fluent:Notify({
    Title = "Bem-vindo",
    Content = "criador surf.exe"
})



-- Finalizando o código
Window:SelectTab(1)
Fluent:Notify({
    Title = "Fluent",
    Content = "O script foi carregado.",
    Duration = 8
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
