loadstring(game:HttpGet("https://raw.githubusercontent.com/ExistingRn/tww-auto-farm-main/refs/heads/main/config.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ExistingRn/tww-auto-farm-main/refs/heads/main/functions.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ExistingRn/tww-auto-farm-main/refs/heads/main/data.lua"))()

clickKey(Enum.KeyCode.C)

while true do
	
    startMine(copperMine)

    startMine(limestoneMine)
end