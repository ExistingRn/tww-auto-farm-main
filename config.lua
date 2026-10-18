local UserInputService = game:GetService("UserInputService")
local SendInputService = game:GetService("VirtualInputManager")

local camera = workspace.CurrentCamera

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local character = workspace.WORKSPACE_Entities.Players:WaitForChild(player.Name)
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local pickaxeSlot = Enum.KeyCode.Four

local interruptionKeys = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D
}

local interupted = false

local ores = {
    copper = game.Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Copper,
    coal = game.Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Coal,
    limestone = game.Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Limestone
}