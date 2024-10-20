local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

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
game.Workspace.FallenPartsDestroyHeight = AfterFPDH - 100000

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
    und = true
end

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
    GameTab = Window:MakeTab({
        Name = gameId == 911750776 and "GAMEGAME" or "Unknown Game",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
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

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
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
            local success, data = pcall(function()
                if success ~= nil then
                    print(success, " ", data)
                end
                character.Humanoid.Sit = true
                Collision(false)
                if character.HumanoidRootPart.CFrame.Y <= AfterFPDH then
                    character.LowerTorso.CFrame = CFrame.new(0,100,0)
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
                    print(humanoidRootPart.CFrame.Y <= AfterFPDH)
                    if humanoidRootPart.CFrame.Y <= AfterFPDH then
                        print(321)
                        character.LowerTorso.CFrame = CFrame.new(0,100,0)
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

        game.Workspace.FallenPartsDestroyHeight = game.Workspace.FallenPartsDestroyHeight - 10000        
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,AfterFPDH-5000,0)
        wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        wait(2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = AfterCFrame
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
