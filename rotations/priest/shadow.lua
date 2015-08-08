local lib = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'autoDots', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things! (Elites)', 
		'Click here to dot all the things!')
	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things! (All)', 
		'Click here to dot all the things!')
end

local General = {
	-- Buffs
	{ "215262", "!player.buffs.stamina" }, -- Power Word: Fortitude
	{ "15473", "player.stance = 0" }, -- Shadowform
	--{ "1706", "player.falling" } -- Levitate
}

local Cooldowns = {
	{ "123040" }, -- Mindbender
	{ "Halo" },
	{ "Shadowfiend " },
	{ "15286", "@coreHealing.needsHealing(65, 3)" } -- Vampiric Embrace
}

local Survival = {
	{{ -- Solo
		{ "17", { -- Power Word: Shield
			"player.health < 100",
			"!player.buff(17)"
		}, "player" },
		{ "2061", "player.health < 60", "player" }, -- Flash Heal
	}, "!modifier.party" },
	{{ -- Party/Raid
		{ "17", { -- Power Word: Shield
			"player.health < 30",
			"!player.buff(17)"
		}, "player" },
		{ "2061", "player.health < 30", "player" }, -- Flash Heal
	}, "modifier.party" },
}

local Dotting = {
	{{ -- Toggle ALL
		{ "32379", (function() return NeP.Lib.AutoDots("32379", 20) end) }, -- SW:D
		{ "589", (function() return NeP.Lib.AutoDots("589", 100, 5) end) }, -- SW:P
		{ "34914", (function() return NeP.Lib.AutoDots("34914", 100, 4) end) }, -- Vampiric Touch
	}, "toggle.dotEverything" },
	{{ -- Toggle Elites
		{ "32379", (function() return NeP.Lib.AutoDots("32379", 20, nil, nil, "elite") end) }, -- SW:D
		{ "589", (function() return NeP.Lib.AutoDots("589", 100, 5, nil, "elite") end) }, -- SW:P
		{ "34914", (function() return NeP.Lib.AutoDots("34914", 100, 4, nil, "elite") end) } -- Vampiric Touch
	}, "toggle.autoDots"},
	{{ -- Toggle off
		{ "32379", "target.health < 20", "target" }, -- SW:D
		{ "589", "!target.debuff(589)", "target" }, -- SW:P
		{ "34914", "!target.debuff(34914)", "target" } -- Vampiric Touch
	}, {"!toggle.autoDots", "toggle.dotEverything" } },
}

local AoE = {
	{ "32379", "target.health <= 20" }, -- SW:D
	{ "2944", "player.shadoworbs >= 3" }, -- Devouring Plague
	{ "8092" }, -- Mind Blast
	{ "15407", "player.buff(Insanity)" }, -- Mind Flay
	{ "73510", "player.buff(Surge of Darkness)" }, -- Mind Spike
	{ "48045" }, -- Mind Sear
}

local ST = {
	{ "32379", "target.health <= 20" }, -- SW:D
	{ "2944", "player.shadoworbs >= 3" }, -- Devouring Plague
	{ "8092" }, -- Mind Blast
	{ "15407", "player.buff(Insanity)" }, -- Mind Flay
	{ "73510", "player.buff(Surge of Darkness)" }, -- Mind Spike
	{ "15407" },  -- Mind Flay
} 

ProbablyEngine.rotation.register_custom(258, NeP.Core.GetCrInfo('Priest - Shadow'), 
	{ -- In-Combat
		{ General },
		{ Survival },
		{{-- Interrupts
			{ "!15487" }, -- Silece
		}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
		{ Cooldowns, "modifier.cooldowns" },
		{ Dotting },
		{{ -- Sanity Checks
			{ AoE, "modifier.multitarget" },
			{ ST, "!modifier.multitarget" }
		}, { "target.range <= 40", "!player.moving" } }
	}, General, lib)