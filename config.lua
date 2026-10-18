UserInputService = game:GetService("UserInputService")
SendInputService = game:GetService("VirtualInputManager")

camera = workspace.CurrentCamera

Players = game:GetService("Players")
player = Players.LocalPlayer

character = workspace.WORKSPACE_Entities.Players:WaitForChild(player.Name)
humanoid = character:WaitForChild("Humanoid")
rootPart = character:WaitForChild("HumanoidRootPart")

pickaxeSlot = Enum.KeyCode.Four

interruptionKeys = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D
}

interupted = false

ores = {
    copper = game.Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Copper,
    coal = game.Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Coal,
    limestone = game.Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Limestone
}