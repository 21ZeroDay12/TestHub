local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")


print("GOOGODFSOGOS")
local Window = OrionLib:MakeWindow({
    Name = "Test",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local workspace = game.Workspace
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local AR
local playerName = ""
local playerName2 = ""
local und = false
local duration = 0
local bang
local AfterFPDH = game.Workspace.FallenPartsDestroyHeight
local speed
local toggle

local function updateCharacterVariables()
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local success, data = pcall(function()
        AR:Set(character["Local Ragdoll"].Disabled == false)
    end)
end
local function Collision(turn)
    if character == nil and humanoidRootPart == nil then
        updateCharacterVariables()
    end
    for i,v in pairs(character:GetDescendants()) do
        if v:FindFirstChild("CanCollide") then
            v.CanCollide = turn
        end
    end
end
local function Cancel()
    updateCharacterVariables()
    if bang then bang:Stop() end
    Collision(true)
    workspace.Gravity = 192.1
    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
    print(AfterFPDH)
    game.Workspace.FallenPartsDestroyHeight = AfterFPDH
    und = true
end
Cancel()

updateCharacterVariables()

local DJP = character.Humanoid.JumpPower
local DWS = character.Humanoid.WalkSpeed

local function findPlayer(Name)
    updateCharacterVariables()
    for _, v in pairs(character.Parent:GetDescendants()) do
        if v:IsA("Model") and string.find(tostring(v), Name) and v:FindFirstChild("HumanoidRootPart") then
            OrionLib:MakeNotification({
                Name = "Player Found!",
                Content = "Did you mean " .. tostring(v) .. "?",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            print(v)
            return tostring(v)
        end
    end
end

local function updateVelocity(direction)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        humanoidRootPart.Velocity = humanoidRootPart.Velocity + direction * speed
    end
end

local function WhenKeyHold(keyCode, callback)
    local isKeyPressed = false

    local function onKeyHold()
        while isKeyPressed do
            callback()
            wait(0.1) -- Задержка для предотвращения слишком быстрого выполнения
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyCode then
            isKeyPressed = true
            onKeyHold()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyCode then
            isKeyPressed = false
        end
    end)
end


local gameId = game.GameId
local GameTab

if gameId == 2007050448 then
    GameTab = Window:MakeTab({
        Name = "Ragdoll Engine",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    AR = GameTab:AddToggle({
        Name = "CanRagdoll",
        Default = false,
        Callback = function(value)
            game.Players.LocalPlayer.Character["Local Ragdoll"].Disabled = not value
            updateCharacterVariables()
        end
    })
else

    if gameId == 1016936714 then
        GameTab = Window:MakeTab({
            Name = "Your Blizzare Adventure",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

        GameTab:AddToggle({
            Name = "Toggle WalkSpeed",
            Default = false,
            Callback = function(value)
                toggle = value
            end
        })

        local WalkSpeedSlider = GameTab:AddSlider({
            Name = "WalkSpeed (Only W)",
            Min = 0,
            Max = 120,
            Default = DWS,
            Color = Color3.fromRGB(255, 255, 255),
            Increment = 1,
            ValueName = "WalkSpeed",
            Callback = function(value)
                speed = value
            end
        })
        WhenKeyHold(Enum.KeyCode.W, function()
            if toggle then
                local lookDirection = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
                updateVelocity(lookDirection)
            end
        end)

        local SBRSection = GameTab:AddSection({ Name = "SBR" })

        GameTab:AddButton({
            Name = "Destroy All Barriers",
            Callback = function()
                updateCharacterVariables()
                workspace.Barriers:Destroy()
            end
        })   
        GameTab:AddDropdown({
            Name = "Destroy Barriers",
            Default = "Default",
            Options = {"Default", "StartBarrier", "1", "2", "3", "EndBarrier"},
            Callback = function(Value)
                updateCharacterVariables()
                if Value == "1" then
                    workspace:FindFirstChild("Barriers"):FindFirstChild("1"):Destroy()
                end
                if Value == "2" then
                    workspace:FindFirstChild("Barriers"):FindFirstChild("2"):Destroy()
                end
                if Value == "3" then
                    workspace:FindFirstChild("Barriers"):FindFirstChild("3"):Destroy()
                end
                if Value == "EndBarrier" then
                    workspace:FindFirstChild("Barriers"):FindFirstChild("4"):Destroy()
                end
                if Value == "StartBarrier" then
                    workspace:FindFirstChild("Barriers"):FindFirstChild("StartBarrier"):Destroy()
                end
            end    
        })

    else
        if gameId == 210851291 then
            GameTab = Window:MakeTab({
                Name = "Build A Boat",
                Icon = "rbxassetid://4483345998",
                PremiumOnly = false
            })
            GameTab:AddButton({
                Name = "FarmDoors",
                Callback = function()
                    updateCharacterVariables()
                    local doorslooted = 0

                    for i,v in pairs(game.Workspace.Houses:GetDescendants()) do
                        if v.Name == "DoorInnerTouch" then
                            doorslooted+=1
                            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            wait()
                            v.Parent.Parent:Destroy()
                        end
                    end
                    --game.Players.LocalPlayer.Character.Humanoid.Health = 0
                    if doorslooted ~= 0 then
                        OrionLib:MakeNotification({
                            Name = "Doors Found!",
                            Content = "Doors Looted: " .. tostring(doorslooted),
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    else
                        OrionLib:MakeNotification({
                            Name = "              Doors Foundn't!",
                            Content = "                                              😥",
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    end
                end
            })
            
        else
            GameTab = Window:MakeTab({
                Name = gameId == 911750776 and "GAMEGAME" or "Unknown Game",
                Icon = "rbxassetid://4483345998",
                PremiumOnly = false
            })
        end
    end
end

-- Character Controls
local CharacterTab = Window:MakeTab({
    Name = "Character",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local HumanoidSection = CharacterTab:AddSection({ Name = "Humanoid" })

local WalkSpeedSlider = CharacterTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 120,
    Default = DWS,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "WalkSpeed",
    Callback = function(value)
        if character ~= nil then
            character.Humanoid.WalkSpeed = value
        else
            updateCharacterVariables()
        end
    end
})

local JumpPowerSlider = CharacterTab:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 680,
    Default = DJP,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "JumpPower",
    Callback = function(value)
        if character ~= nil then
            character.Humanoid.UseJumpPower = true
            character.Humanoid.JumpPower = value
        else
            updateCharacterVariables()
        end
    end
})

CharacterTab:AddButton({
    Name = "Set Default",
    Callback = function()
        updateCharacterVariables()
        WalkSpeedSlider:Set(DWS)
        JumpPowerSlider:Set(DJP)
    end
})

local SitSection = CharacterTab:AddSection({ Name = "Sit" })

CharacterTab:AddButton({
    Name = "Sit",
    Callback = function()
        updateCharacterVariables()
        character.Humanoid.Sit = true
    end
})

-- Teleporting Tab
local TeleportingTab = Window:MakeTab({
    Name = "Teleporting",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportSection = TeleportingTab:AddSection({ Name = "Teleporting" })

TeleportingTab:AddTextbox({
    Name = "Name of Player",
    Default = "",
    TextDisappear = false,
    Callback = function(value)
        playerName = findPlayer(value)
    end
})

TeleportingTab:AddTextbox({
    Name = "Seconds",
    Default = "",
    TextDisappear = false,
    Callback = function(value)
        duration = tonumber(value) or 0
    end
})

TeleportingTab:AddButton({
    Name = "Goto",
    Callback = function()
        updateCharacterVariables()
        local destination = game.Players[playerName].Character.HumanoidRootPart.Position

        local function setGravity(value)
            workspace.Gravity = value
        end

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 1)
        local goal = { CFrame = CFrame.new(destination) }
        humanoidRootPart.CanCollide = false

        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween.Completed:Connect(function()
            setGravity(196.1)
        end)

        setGravity(0)
        tween:Play()
    end
})

local ToolSection = TeleportingTab:AddSection({ Name = "Tool" })

TeleportingTab:AddButton({
    Name = "Give Tool",
    Callback = function()
        updateCharacterVariables()
        local mouse = player:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click to Teleport"
        tool.Parent = player.Backpack

        tool.Activated:Connect(function()
            local pos = mouse.Hit
            character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
        end)
    end
})

-- Troll Tab
local TrollTab = Window:MakeTab({
    Name = "Troll",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerSection = TrollTab:AddSection({ Name = "Player" })

TrollTab:AddTextbox({
    Name = "Player",
    Default = "",
    TextDisappear = false,
    Callback = function(value)
        playerName2 = findPlayer(value)
    end
})

local ActionsSection = TrollTab:AddSection({ Name = "Actions" })

TrollTab:AddButton({
    Name = "Sit On",
    Callback = function()
        und = false
        updateCharacterVariables()
        while not und do
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            if game.Players:FindFirstChild(playerName2) == nil then
                print("сдох")
                Cancel()
            end
            if character == nil and humanoidRootPart == nil then
                updateCharacterVariables()
            end
            workspace.Gravity = 0
            game.Workspace.FallenPartsDestroyHeight = AfterFPDH - 5000
            local success, data = pcall(function()
                if success ~= nil then
                    print(success, " ", data)
                end
                character.Humanoid.Sit = true
                Collision(false)
                if character.HumanoidRootPart.CFrame.Y <= AfterFPDH then
                    local destination = 10

                    local function setGravity(value)
                        workspace.Gravity = value
                    end

                    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                    local goal = { CFrame = CFrame.new(0, destination, 0) }
                    humanoidRootPart.CanCollide = false

                    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
                    tween.Completed:Connect(function()
                        setGravity(196.1)
                    end)

                    setGravity(0)
                    tween:Play()
                    OrionLib:MakeNotification({
                        Name = "Sit on",
                        Content = "Player tried to AntiSit you!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                else
                    print("123")
                    character.LowerTorso.CFrame = game.Players[playerName2].Character.Head.CFrame
                end
            end)
            wait()
        end
        if und then
            character.Humanoid.Sit = false
            workspace.Gravity = 192.1
        end
    end
})

TrollTab:AddButton({
    Name = "Bang",
    Callback = function()
        und = false
        if character == nil and humanoidRootPart == nil then
            updateCharacterVariables()
        end
        updateCharacterVariables()

        local bangAnim = Instance.new("Animation")
        bangAnim.AnimationId = "rbxassetid://5918726674"
        bang = character.Humanoid:LoadAnimation(bangAnim)
        bang:AdjustSpeed(1)
        workspace.Gravity = 0
        if bang ~= nil then
            bang:Stop()
        end
        bang:Play(0.1, 1, 1)
        Collision(false)
        game.Workspace.FallenPartsDestroyHeight = AfterFPDH - 5000
        while not und do
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            if game.Players:FindFirstChild(playerName2) == nil then
                print("сдох")
                Cancel()
            end
            if character == nil and humanoidRootPart == nil then
                updateCharacterVariables()
            end
            wait()
            local success, data = pcall(function()
                if success ~= nil then
                    print(success, " ", data)
                end
                local targetCharacter = game.Players[playerName2].Character
                if targetCharacter then
                    if humanoidRootPart.CFrame.Y <= AfterFPDH + 500 then
                            local destination = 10

                            local function setGravity(value)
                                workspace.Gravity = value
                            end

                            local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                            local goal = { CFrame = CFrame.new(0, destination, 0) }
                            humanoidRootPart.CanCollide = false

                            local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
                            tween.Completed:Connect(function()
                                setGravity(196.1)
                            end)

                            setGravity(0)
                            tween:Play()
                        OrionLib:MakeNotification({
                            Name = "Bang",
                            Content = "Player tried to AntiBang you!",
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    else
                        print("123")
                        local behindOffset = targetCharacter.HumanoidRootPart.CFrame.LookVector * -1
                        humanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame + behindOffset
                    end
                end
            end)
        end
    end
})

local CancelSection = TrollTab:AddSection({ Name = "Cancel" })

TrollTab:AddButton({
    Name = "Cancel",
    Callback = function()
        Cancel()
    end
})

local UnTrollSection = TrollTab:AddSection({ Name = "AntiTroll" })

TrollTab:AddButton({
    Name = "AntiBang, AntiSitOn",
    Callback = function()
        AfterFPDH = game.Workspace.FallenPartsDestroyHeight
        local AfterCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        humanoidRootPart.Anchored = false
        game.Workspace.FallenPartsDestroyHeight = game.Workspace.FallenPartsDestroyHeight - 10000        
        
        local destination = AfterFPDH - 100
        print(game.Workspace.FallenPartsDestroyHeight)
        print(destination)
        local function setGravity(value)
            workspace.Gravity = value
        end

        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local goal = { CFrame = CFrame.new(0, destination, 0) }
        humanoidRootPart.CanCollide = false

        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween.Completed:Connect(function()
            setGravity(196.1)
        end)

        setGravity(0)
        tween:Play()
        humanoidRootPart.Anchored = true
        wait(3)
        humanoidRootPart.Anchored = false

        local destination = 10

        local function setGravity(value)
            workspace.Gravity = value
        end

        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local goal = { CFrame = CFrame.new(0, destination, 0) }
        humanoidRootPart.CanCollide = false

        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween.Completed:Connect(function()
            setGravity(196.1)
        end)

        setGravity(0)
        tween:Play()
        game.Workspace.FallenPartsDestroyHeight = AfterFPDH
    end
})

-- Other Tab
local OtherTab = Window:MakeTab({
    Name = "Other",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local OthersSection = OtherTab:AddSection({ Name = "Others" })

OtherTab:AddButton({
    Name = "Refresh Variables",
    Callback = function()
        updateCharacterVariables()
    end
})

OtherTab:AddButton({
    Name = "RejoinServer",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game["PlaceId"], game["JobId"])
    end
})

local HubsSection = OtherTab:AddSection({ Name = "Hubs" })

OtherTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
    end
})

OtherTab:AddButton({
    Name = "Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
})
