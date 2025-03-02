# WitherStormV2                -- Carregar a biblioteca ArceusLib
local ArceusLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArceusX/ArceusX/main/ArceusLib.lua"))()

-- Função para criar o Wither Storm no servidor
local function createWitherStorm()
    -- Criando o modelo do Wither Storm
    local witherStorm = Instance.new("Model")
    witherStorm.Name = "WitherStorm"
    witherStorm.Parent = workspace

    -- Criando o núcleo do Wither Storm
    local core = Instance.new("Part")
    core.Size = Vector3.new(10, 10, 10)
    core.Position = Vector3.new(0, 50, 0)  -- Ajuste a posição conforme necessário
    core.Anchored = true
    core.CanCollide = false
    core.Color = Color3.fromRGB(0, 0, 0)
    core.Parent = witherStorm

    -- Função para criar as cabeças do Wither Storm
    local function createWitherHeads()
        local heads = {}
        for i = 1, 3 do
            local head = Instance.new("Part")
            head.Size = Vector3.new(6, 6, 6)
            head.Shape = Enum.PartType.Ball
            head.Color = Color3.fromRGB(255, 0, 0)  -- Cor vermelha
            head.Anchored = false
            head.CanCollide = false
            head.Parent = witherStorm
            head.Position = core.Position + Vector3.new((i - 2) * 6, 6, 0)
            table.insert(heads, head)
        end
        return heads
    end

    local heads = createWitherHeads()

    -- Função para mover as cabeças do Wither Storm em direção ao núcleo
    local function moveHeads()
        for _, head in pairs(heads) do
            local direction = (core.Position - head.Position).unit
            local newPosition = head.Position + direction * 1 * game:GetService("RunService").Heartbeat:Wait()
            head.CFrame = CFrame.new(newPosition)
        end
    end

    -- Função para caçar e destruir blocos móveis próximos
    local function attractBlocks()
        local blocks = workspace:FindPartsInRegion3(core.Position - Vector3.new(50, 50, 50), 
                                                    core.Position + Vector3.new(50, 50, 50), 
                                                    nil)
        for _, block in pairs(blocks) do
            if block:IsA("BasePart") and block.Velocity.Magnitude > 0 then
                block:Destroy()  -- Absorve o bloco
            end
        end
    end

    -- Função para replicar o Wither Storm para todos os jogadores
    local function replicateWitherStorm()
        -- Criar um evento RemoteEvent para enviar o modelo para todos os jogadores
        local remoteEvent = Instance.new("RemoteEvent")
        remoteEvent.Name = "WitherStormEvent"
        remoteEvent.Parent = game.ReplicatedStorage

        -- Enviar a criação do Wither Storm para todos
        remoteEvent:FireAllClients(witherStorm)
    end

    -- Replicar o Wither Storm para todos os jogadores
    replicateWitherStorm()

    -- Loop principal para ativar o Wither Storm
    while true do
        moveHeads()  -- Move as cabeças
        attractBlocks()  -- Caça blocos móveis
        wait(0.1)  -- Aguarda para o próximo ciclo
    end
end

-- Criando a interface gráfica com ArceusLib
local window = ArceusLib:CreateWindow("Wither Storm Control")

-- Adicionando um botão para spawnar o Wither Storm
window:Button("Spawnar Wither Storm", function()
    createWitherStorm()  -- Chama a função para criar o Wither Storm
    ArceusLib:CreateNotification("Wither Storm Spawnado", "O Wither Storm foi spawnado com sucesso!", 5)
end)

window:Show()
