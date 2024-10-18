local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Test", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
local workspace
local player
local character
local humanoidRootPart
local AR
local Val
function Variables()
    workspace = game.Workspace
    player = game.Players.LocalPlayer
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local Success, Data = pcall(function()
        if character["Local Ragdoll"].Disabled then
            AR:Set(true)
        else
            AR:Set(false)
        end
    end)
    --print(Success,"abc ",Data)
end
Variables()
local TweenService = game:GetService("TweenService")

local DJP = character.Humanoid.JumpPower
local DWS = character.Humanoid.WalkSpeed

-- Глобальные переменные для сохранения значений
local playerName = ""
local playerName2 = ""
local und = false
local duration = 0

local function Find(Name)
    for i,v in pairs(character.Parent:GetDescendants()) do
        if v:IsA("Model") then
            if string.find(tostring(v), Name) and v:FindFirstChild("HumanoidRootPart") then
                OrionLib:MakeNotification({
                    Name = "Player Founded!",
                    Content = "Did you mean " .. tostring(v) .. "?",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                print(v)
                return tostring(v)
            end
        end
    end
end

if game.GameId == 2007050448 then
    local Game = Window:MakeTab({
        Name = "Ragdoll Engine",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    AR = Game:AddToggle({
        Name = "AntiRagdoll",
        Default = false,
        Callback = function(Value)
            if Value then
                character["Local Ragdoll"].Disabled = true
            else
                character["Local Ragdoll"].Disabled = false
            end 
        Variables()
        end    
    })


else

    local Null = Window:MakeTab({
        Name = "Unknown Game",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

end

local Character = Window:MakeTab({
	Name = "Character",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local WalkSpeed = Character:AddSlider({
	Name = "WalkSpeed",
	Min = 0,
	Max = 120,
	Default = DWS,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "WalkSpeed",
	Callback = function(Value)
		character.Humanoid.WalkSpeed = Value
	end    
})
local JumpPower = Character:AddSlider({
	Name = "JumpPower",
	Min = 0,
	Max = 680,
	Default = DJP,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "JumpPower",
	Callback = function(Value)
        character.Humanoid.UseJumpPower = true
		character.Humanoid.JumpPower = Value
	end    
})

Character:AddButton({
	Name = "Set default",
	Callback = function()
        Variables()
        WalkSpeed:Set(DWS)
        JumpPower:Set(DJP)
  	end    
})

local Section = Character:AddSection({
	Name = "Sit"
})

Character:AddButton({
	Name = "Sit",
	Callback = function()
        Variables()
        character.Humanoid.Sit = true
  	end    
})

local Teleporting = Window:MakeTab({
	Name = "Teleporting",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Teleporting:AddTextbox({

	Name = "Name of Player",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
        Variables()
        playerName = Find(Value) -- Сохраняем значение в глобальную переменную
	end	  
})

Teleporting:AddTextbox({
	Name = "Seconds",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
        duration = tonumber(Value) or 0 -- Сохраняем значение в глобальную переменную и конвертируем в число
	end	 
})




Teleporting:AddButton({
	Name = "Goto",
	Callback = function()
        Variables()
        local destination = game.Players[playerName].Character.HumanoidRootPart.Position -- Используем сохранённое имя игрока
        local function setGravity(value)
            workspace.Gravity = value
        end
        local tweenInfo = TweenInfo.new(
            duration, -- Используем сохранённое время
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            0,
            false,
            1
        )
        local goal = {
            CFrame = CFrame.new(destination)
        }
        humanoidRootPart.CanCollide = false
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween.Completed:Connect(function()
            setGravity(196.1)
        end)
        local function startMovement()
            setGravity(0)
            tween:Play()
        end
        startMovement()
  	end    
})

local Section = Teleporting:AddSection({
	Name = "Tool"
})

Teleporting:AddButton({
	Name = "Give tool",
	Callback = function()
            Variables()
            mouse = game.Players.LocalPlayer:GetMouse()
            local Charater = game.Players.LocalPlayer.Character
            tool = Instance.new("Tool")
            tool.RequiresHandle = false
            tool.Name = "Кликать чтоб улетать"
            tool.Parent = game:GetService("Players").LocalPlayer.Backpack
            tool.Activated:connect(function()
                local pos = mouse.Hit
                pos = CFrame.new(pos.X,pos.Y,pos.Z)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
            end)
  	end    
})

local Troll = Window:MakeTab({
	Name = "Troll",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Troll:AddTextbox({
	Name = "Player",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
        playerName2 = Find(Value)
	end	 
})




Troll:AddButton({
	Name = "Sit on",
	Callback = function()
        --Variables()
        while und ~= true do
            game.Workspace.Gravity = 0
            character.Humanoid.Sit = true
            character.HumanoidRootPart.CanCollide = false
            character.LowerTorso.CanCollide = false
            character.UpperTorso.CanCollide = false
            character.LowerTorso.CFrame = game.Players[playerName2].Character.Head.CFrame
            wait()
        end
        if und then
            character.Humanoid.Sit = false
            game.Workspace.Gravity = 192.1
        end
  	end    
})
Troll:AddButton({
	Name = "Bang",
	Callback = function()
        --Variables()
        print(playerName2)
        bangAnim = Instance.new("Animation")
        bangAnim.AnimationId = "rbxassetid://5918726674"
        bang = character.Humanoid:LoadAnimation(bangAnim)
        bang:Play(0.1, 1, 1)
        bang:AdjustSpeed(1)
        while und ~= true do
            game.Workspace.Gravity = 0
            humanoidRootPart.CFrame = game.Players[playerName2].Character.HumanoidRootPart.CFrame
            wait()
        end
        if und then
            game.Workspace.Gravity = 192.1
            bang:Stop()
        end
  	end    
})

Troll:AddButton({
	Name = "Cancel",
	Callback = function()
        Variables()
        game.Workspace.Gravity = 192.1
        und = true
        wait(2)
        und = false
  	end    
})


local Other = Window:MakeTab({
	Name = "Other",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Other:AddButton({
	Name = "Refresh variables",
	Callback = function()
        Variables()
  	end    
})
