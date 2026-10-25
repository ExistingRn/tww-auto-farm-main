-- Background loop that runs while travelling
running = true

task.spawn(function()
    while true do
        humanoid.WalkSpeed = 32
        if running == false then
        	break
        end
        -- Put other repeating code here

        task.wait(0.1)
    end
end)

inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if table.find(interruptionKeys, input.KeyCode) then
        print("Interrupted")
        running = false

        inputConnection:Disconnect()
    end
end)

function clickKey(key, delay)
	if delay == nil or delay < 0 then
		delay = 0.05
	end
    SendInputService:SendKeyEvent(true, key, false, game)
    task.wait(delay)
    SendInputService:SendKeyEvent(false, key, false, game)
end

function getClosestModel(folder)
    local closestModel = nil
    local shortestDistance = math.huge

    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local part = model.PrimaryPart
                or model:FindFirstChildWhichIsA("RockBase", true)

            if part then
                local distance = (rootPart.Position - part.Position).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    closestModel = model
                end
            end
        end
    end

    return closestModel, shortestDistance
end


-- Function to travel to a point
function goToPoint(target)

    -- face target position
    local targetPosition = Vector3.new(target.X, rootPart.Position.Y, target.Z)
    rootPart.CFrame = CFrame.lookAt(
        rootPart.Position, 
        targetPosition
    )

    while true do
        humanoid:MoveTo(target)

        local reached = humanoid.MoveToFinished:Wait()

        if not running then
            return false
        end

        if reached then
            return true
        end

        print("Couldn't reach point, retrying...")
        task.wait(0.2)
    end
end

function faceOre(ore_position)
	
    local target = Vector3.new(
        ore_position.X,
        rootPart.Position.Y,
        ore_position.Z
    )

	rootPart.CFrame = CFrame.lookAt(
        rootPart.Position,
        target
    )

    local lookDirection = (target - rootPart.Position).Unit
    local downwardAngle = math.rad(30)
    local leftAngle = math.rad(-10)

    local horizontalDirection = Vector3.new(
        lookDirection.X,
        0,
        lookDirection.Z
    ).Unit

    local angledDirection =
    CFrame.lookAt(Vector3.zero, horizontalDirection)
    * CFrame.Angles(-downwardAngle, -leftAngle, 0)


    camera.CFrame = CFrame.lookAt(
        camera.CFrame.Position,
        camera.CFrame.Position + angledDirection.LookVector
    )

end

function mineOre(ore)
    local rockBase = ore:FindFirstChild("RockBase") or ore:FindFirstChild("RockBaseL") or ore:FindFirstChild("LimestoneOre")
    local pos = rockBase and rockBase.Position

	faceOre(pos)
    task.wait(0.2)

	clickKey(pickaxeSlot)

    task.wait(0.2)
    
	SendInputService:SendMouseButtonEvent(
        100, 100, 0, true, game, 0
    )

    while ore.DepositInfo and ore.DepositInfo.OreRemaining.Value > 0 do
    	task.wait(0.2)
    end

    SendInputService:SendMouseButtonEvent(
        100, 100, 0, false, game, 0
    )

	clickKey(pickaxeSlot)
end

function pickUpDroppedOres()
	clickKey(Enum.KeyCode.E, 1)
end

function performActions(actions)
	for _, obj in ipairs(actions) do
		if obj.p then
            goToPoint(obj.p)
		end

        if obj.o then
        	local closestOre = getClosestModel(ores[string.lower(obj.o)])
        	mineOre(closestOre)
            pickUpDroppedOres()
            task.wait(0.2)
            pickUpDroppedOres()
        end

        if obj.crouch then
        	clickKey(Enum.KeyCode.C)
        end

        if obj.sell then
        	clickKey(Enum.KeyCode.F, 2)
        end
    end
end



function reset()
    clickKey(Enum.KeyCode.Escape)
    task.wait(0.1)
    clickKey(Enum.KeyCode.R)
    task.wait(0.1)
    clickKey(Enum.KeyCode.Return)
end

function selectSpawnLocation(down)
	clickKey(Enum.KeyCode.BackSlash)
    task.wait(0.4)
    for i = 1, down do
    	clickKey(Enum.KeyCode.Down)
        task.wait(0.2)
    end

    task.wait(0.2)

    clickKey(Enum.KeyCode.Return)
    task.wait(0.2)

    clickKey(Enum.KeyCode.Right)
    task.wait(0.1)
    clickKey(Enum.KeyCode.Return)

    task.wait(0.2)

	clickKey(Enum.KeyCode.BackSlash)

end

function resetAndWaitForRespawn(spawnLocation)
    local playerFolder = workspace.WORKSPACE_Entities.Players

    reset()

    task.wait(0.5)

    selectSpawnLocation(spawnLocation)

    task.wait(1)

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local newCharacter = workspace.WORKSPACE_Entities.Players:WaitForChild(player.Name)

    if not newCharacter or not running then
        return false
    end

    -- Refresh references to the new character
    character = playerFolder:WaitForChild(player.Name)
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")

    return true
end

function goToStart(startPos, betweenPoints)
    if not running then
        return false
    end

    -- Find the closest between point to the player
    local closestIndex = nil
    local shortestDistance = math.huge

    for i, obj in ipairs(betweenPoints) do
        local distance = (rootPart.Position - obj.p).Magnitude

        if distance < shortestDistance then
            shortestDistance = distance
            closestIndex = i
        end
    end

    if not closestIndex then
        return goToPoint(startPos)
    end

    -- Go to the closest point first
    if not goToPoint(betweenPoints[closestIndex].p) then
        return false
    end

    -- Follow the remaining points in order toward the start
    for i = closestIndex + 1, #betweenPoints do
        if not running then
            return false
        end

        if not goToPoint(betweenPoints[i].p) then
            return false
        end
    end

    -- Finally, travel to the mine's start position
    if not running then
        return false
    end

    return goToPoint(startPos)
end

function startMine(mine)
	resetAndWaitForRespawn(mine.spawnButtonIndex)
    task.wait(1)
	goToStart(mine.startPos, mine.betweenPoints)
    performActions(mine.mine)
    task.wait(1)
end