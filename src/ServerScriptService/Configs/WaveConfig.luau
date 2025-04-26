local WaveConfig = {}

-- Global settings applicable to all waves unless overridden
WaveConfig.GlobalSettings = {
	TimeBetweenWaves = 3, -- Default time in seconds after a wave is cleared
	TimeBetweenMobs = 0.5, -- Default time between mobs in seconds
	DefaultScripts = { "ZombieMovement" }, -- Default scripts to attach if not specified per wave
	-- Add other global settings if needed (e.g., default spawn location tag)
}

-- Define each wave as an entry in this array
WaveConfig.Waves = {
	-- Wave 1
	{
		-- Spawn 3 zombies
		SpawnSequence = {
			{ Zombie = 3 },
		},
		-- Scripts = { "ZombieMovement" } -- Optional: Overrides DefaultScripts if needed
		-- TimeBonus = 5, -- Optional: Example of wave-specific data (e.g., time added on clear)
		Message = "Wave 1: Just Zombies!", -- Optional: Message to display
	},

	-- Wave 2
	{
		-- Spawns 4 Zombies and 2 Noobs
		SpawnSequence = {
			{ Zombie = 4 },
			{ Noob = 2 },
		},
	},

	-- Wave 3
	{
		-- Spawns 5 Zombies, 3 Noobs, and 1 MechCannon
		SpawnSequence = {
			{ MechCannon = 1 },
			{ Noob = 3 },
			{ Zombie = 5 },
		},
	},

	-- Wave 4
	{
		SpawnSequence = {
			{ Noob = 5 },
			{ MechCannon = 3 },
			{ Dracula = 1 },
		},
		Scripts = { "ZombieMovement" }, -- Example: Explicitly setting scripts (same as default here)
	},

	-- Wave 5
	{
		SpawnSequence = {
			Zombie = 5,
			Noob = 3,
			MechCannon = 2,
			Dracula = 1,
		},
	},
}

return WaveConfig
