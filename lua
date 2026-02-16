-- LocalScript:  Client Mobile - Quick Interaction Fix
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CORRECT_KEY = "X_CXZ1"

-- 1. Contenedor Seguro
local ParentContainer = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

local function RandomName()
    local s = ""
    for i = 1, 12 do s = s .. string.char(math.random(65, 90)) end
    return s
end

local sgui = Instance.new("ScreenGui")
sgui.Name = RandomName()
sgui.DisplayOrder = 999
sgui.ResetOnSpawn = false
sgui.IgnoreGuiInset = true
sgui.Parent = ParentContainer

-- 2. VENTANA DE KEY
local KeyFrame = Instance.new("Frame", sgui)
KeyFrame.Size = UDim2.new(0, 280, 0, 160); KeyFrame.Position = UDim2.new(0.5, -140, 0.4, 0); KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); KeyFrame.BorderSizePixel = 0; Instance.new("UICorner", KeyFrame)
local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 35); KeyTitle.Text = "X_CXZ1 | MOBILE"; KeyTitle.TextColor3 = Color3.new(1, 1, 1); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 12; KeyTitle.BackgroundTransparency = 1
local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 35); KeyInput.Position = UDim2.new(0.5, -120, 0, 50); KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35); KeyInput.PlaceholderText = "Insert key..."; KeyInput.Text = ""; KeyInput.TextColor3 = Color3.new(1, 1, 1); KeyInput.Font = Enum.Font.Gotham; Instance.new("UICorner", KeyInput)
local AccessBtn = Instance.new("TextButton", KeyFrame)
AccessBtn.Size = UDim2.new(0, 240, 0, 35); AccessBtn.Position = UDim2.new(0.5, -120, 0, 100); AccessBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 180); AccessBtn.Text = "Access"; AccessBtn.TextColor3 = Color3.new(1, 1, 1); AccessBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", AccessBtn)

-- 3. BARRA Y MENÚ ORIGINAL
local MainBar = Instance.new("Frame", sgui)
MainBar.Size = UDim2.new(0, 280, 0, 35); MainBar.Position = UDim2.new(0.5, -140, 0.2, 0); MainBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); MainBar.BorderSizePixel = 0; MainBar.Active = true; MainBar.Visible = false
local PinkLine = Instance.new("Frame", MainBar)
PinkLine.Size = UDim2.new(1, 0, 0, 2); PinkLine.Position = UDim2.new(0, 0, 1, 0); PinkLine.BackgroundColor3 = Color3.fromRGB(180, 0, 180)
local Title = Instance.new("TextLabel", MainBar)
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "X_CXZ1 | MOBILE"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 12
local MenuFrame = Instance.new("Frame", MainBar)
MenuFrame.Size = UDim2.new(1, 0, 0, 240); MenuFrame.Position = UDim2.new(0, 0, 1, 2); MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); MenuFrame.Visible = false

-- CONFIGURACIÓN
local Settings = { Aimbot = false, Aimbot_Visible = false, TargetPart = "Head", QuickInteraction = false, LegitSpeed = false, ESP_Names = false, BringPlayer = false, Optimize = false }

-- 4. PESTAÑAS
local TabBar = Instance.new("Frame", MenuFrame); TabBar.Size = UDim2.new(1, 0, 0, 30); TabBar.Position = UDim2.new(0, 0, 0, 5); TabBar.BackgroundTransparency = 1
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal; TabBar.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar); btn.Text = name; btn.Size = UDim2.new(0, 60, 1, 0); btn.BackgroundTransparency = 1; btn.TextColor3 = Color3.new(0.5, 0.5, 0.5); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    local page = Instance.new("ScrollingFrame", MenuFrame); page.Size = UDim2.new(1, -10, 1, -45); page.Position = UDim2.new(0, 5, 0, 40); page.BackgroundTransparency = 1; page.Visible = false; page.ScrollBarThickness = 0; page.CanvasSize = UDim2.new(0,0,0,350)
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    return btn, page
end

local aimBtn, aimPage = CreateTab("Aimbot"); local playBtn, playPage = CreateTab("Player"); local drawBtn, drawPage = CreateTab("Draw")

local function ShowPage(p, b) 
    aimPage.Visible = false; playPage.Visible = false; drawPage.Visible = false
    aimBtn.TextColor3 = Color3.new(0.5, 0.5, 0.5); playBtn.TextColor3 = Color3.new(0.5, 0.5, 0.5); drawBtn.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    p.Visible = true; b.TextColor3 = Color3.new(1, 1, 1) 
end
aimBtn.MouseButton1Click:Connect(function() ShowPage(aimPage, aimBtn) end); playBtn.MouseButton1Click:Connect(function() ShowPage(playPage, playBtn) end); drawBtn.MouseButton1Click:Connect(function() ShowPage(drawPage, drawBtn) end); ShowPage(aimPage, aimBtn)

local function AddOption(parent, text, settingKey, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
    local box = Instance.new("TextButton", f); box.Size = UDim2.new(0, 18, 0, 18); box.Position = UDim2.new(0, 12, 0.5, -9); box.BackgroundColor3 = Color3.fromRGB(45, 45, 45); box.Text = ""; Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local check = Instance.new("TextLabel", box); check.Text = "✓"; check.Size = UDim2.new(1, 0, 1, 0); check.TextColor3 = Color3.new(1, 1, 1); check.BackgroundTransparency = 1; check.Visible = false
    local label = Instance.new("TextLabel", f); label.Text = text; label.Position = UDim2.new(0, 40, 0, 0); label.Size = UDim2.new(1, -45, 1, 0); label.TextColor3 = Color3.new(0.8, 0.8, 0.8); label.Font = Enum.Font.Gotham; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1
    box.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        check.Visible = Settings[settingKey]
        box.BackgroundColor3 = Settings[settingKey] and Color3.fromRGB(180, 0, 180) or Color3.fromRGB(45, 45, 45)
        if callback then callback(Settings[settingKey]) end
    end)
end

-- 5. OPCIONES E INYECCIONES
AddOption(aimPage, "Aimbot", "Aimbot")
AddOption(aimPage, "Aimbot Visible", "Aimbot_Visible")

-- Selector Visual (Aimbot Part)
local SelectorContainer = Instance.new("Frame", aimPage); SelectorContainer.Size = UDim2.new(1, 0, 0, 140); SelectorContainer.BackgroundTransparency = 1
local SelectorFrame = Instance.new("Frame", SelectorContainer); SelectorFrame.Size = UDim2.new(0, 80, 0, 110); SelectorFrame.Position = UDim2.new(0.5, -40, 0, 10); SelectorFrame.BackgroundColor3 = Color3.fromRGB(30,30,30); Instance.new("UICorner", SelectorFrame)

local function AddBodyBtn(name, size, pos, target)
    local p = Instance.new("TextButton", SelectorFrame); p.Size = size; p.Position = pos; p.BackgroundColor3 = (Settings.TargetPart == target and Color3.fromRGB(180, 0, 180) or Color3.fromRGB(45, 45, 45)); p.Text = ""; Instance.new("UICorner", p).CornerRadius = UDim.new(0,2)
    p.MouseButton1Click:Connect(function() 
        Settings.TargetPart = target 
        for _, v in pairs(SelectorFrame:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end end 
        p.BackgroundColor3 = Color3.fromRGB(180, 0, 180) 
    end)
end
AddBodyBtn("H", UDim2.new(0, 20, 0, 20), UDim2.new(0.5, -10, 0, 5), "Head")
AddBodyBtn("T", UDim2.new(0, 35, 0, 40), UDim2.new(0.5, -17.5, 0, 28), "HumanoidRootPart")
AddBodyBtn("LL", UDim2.new(0, 15, 0, 30), UDim2.new(0.5, -17.5, 0, 72), "LeftUpperLeg")
AddBodyBtn("RL", UDim2.new(0, 15, 0, 30), UDim2.new(0.5, 2.5, 0, 72), "RightUpperLeg")

-- FIJADO: Interacción rápida
AddOption(playPage, "Quick Interaction", "QuickInteraction")
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if Settings.QuickInteraction then
        fireproximityprompt(prompt) -- Simula el click instantáneo
        prompt.HoldDuration = 0
    end
end)

AddOption(playPage, "Legit Speed", "LegitSpeed")
AddOption(playPage, "Bring Player", "BringPlayer")
AddOption(playPage, "Optimizar Juego", "Optimize", function(s)
    if s then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end if v:IsA("Decal") then v.Transparency = 1 end end end
end)
AddOption(drawPage, "Name ESP", "ESP_Names")

-- 6. Lógica de Funciones y Render
AccessBtn.MouseButton1Click:Connect(function() if KeyInput.Text == CORRECT_KEY then KeyFrame:Destroy(); MainBar.Visible = true end end)
local DrawContainer = Instance.new("Folder", sgui); DrawContainer.Name = RandomName()

RunService.RenderStepped:Connect(function()
    DrawContainer:ClearAllChildren()
    if not MainBar.Visible then return end
    
    if Settings.LegitSpeed and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character:TranslateBy(hum.MoveDirection * 0.18)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            if head and Settings.ESP_Names then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                if onScreen then
                    local dist = math.floor((Camera.CFrame.Position - head.Position).Magnitude)
                    local n = Instance.new("TextLabel", DrawContainer); n.Text = p.Name .. " [" .. dist .. "m]"; n.Size = UDim2.new(0, 200, 0, 20); n.Position = UDim2.new(0, pos.X - 100, 0, pos.Y); n.BackgroundTransparency = 1; n.TextColor3 = Color3.new(1, 1, 1); n.Font = Enum.Font.GothamBold; n.TextSize = 11; n.TextStrokeTransparency = 0.5
                end
            end
        end
    end

    if Settings.BringPlayer and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local eRoot = p.Character.HumanoidRootPart
                    if (root.Position - eRoot.Position).Magnitude < 50 then eRoot.CFrame = root.CFrame * CFrame.new(0, 0, -6) end
                end
            end
        end
    end

    if Settings.Aimbot then
        local target, closest = nil, 400
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local part = p.Character:FindFirstChild(Settings.TargetPart) or p.Character.PrimaryPart
                if part then
                    local isVis = true
                    if Settings.Aimbot_Visible then
                        local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                        isVis = hit and hit:IsDescendantOf(p.Character)
                    end
                    if isVis then
                        local pos, vis = Camera:WorldToViewportPoint(part.Position)
                        if vis then
                            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                            if mag < closest then closest = mag; target = part end
                        end
                    end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

local drag, dStart, sPos, lTime = false, nil, nil, 0
MainBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag, dStart, sPos, lTime = true, input.Position, MainBar.Position, tick() end end)
UserInputService.InputChanged:Connect(function(input) if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dStart; MainBar.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y) end end)
MainBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false; if tick() - lTime < 0.2 then MenuFrame.Visible = not MenuFrame.Visible end end end)
