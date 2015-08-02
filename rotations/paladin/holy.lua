-- ///////////////////-----------------------------------------INFO-----------------------------------//////////////////////////////
--														 //Paladin Holy//
--												  Thank Your For Your My ProFiles
--													  I Hope Your Enjoy Them
--															    MTS

local lib = function()
	NeP.Splash()
end

local inCombat = {
	
	{{ -- Dispell all?
		{ "4987", (function() return NeP.Lib.Dispell(function() return dispelType == 'Magic' or dispelType == 'Posion' or dispelType == 'Disease' end) end) },-- Dispel Everything
	}, (function() return NeP.Core.PeFetch('npconfPalaHoly','Dispels') end) },

	-- Hand of Freedom
		{ "1044", "player.state.root" },

	-- Buffs
		{ "20217", { -- Blessing of Kings
			"!player.buffs.stats",
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "Buff") == 'Kings' end),
		}, nil },
		{ "19740", { -- Blessing of Might
			"!player.buffs.mastery",
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "Buff") == 'Might' end),
		}, nil }, 
	
	-- Seals
		{ "20165", { -- seal of Insigh
			"player.seal != 2", 
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "seal") == 'Insight' end),
		}, nil }, 
		{ "105361", { -- seal of Command
			"player.seal != 1",
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "seal") == 'Command' end),
		}, nil },

	-- keybinds
		{ "114158", "modifier.shift", "target.ground"}, -- Light´s Hammer
		{ "!/focus [target=mouseover]", "modifier.alt" }, -- Mouseover Focus

	-- Items
		{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'Healthstone')) end), nil }, -- Healthstone
		{ "#trinket1", (function() return NeP.Core.dynamicEval("player.mana <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'Trinket1')) end), nil }, -- Trinket 1
		{ "#trinket2", (function() return NeP.Core.dynamicEval("player.mana <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'Trinket2')) end), nil }, -- Trinket 2

	{{-- Beacon of Faith
		{ "156910", {
			"!player.buff(53563)", -- Beacon of light
			"!player.buff(156910)" -- Beacon of Faith
		}, "player" },
	}, "talent(7,1)" },

	-- Beacon of light
		{ "53563", {
			"!tank.buff(53563)", -- Beacon of light
			"!tank.buff(156910)", -- Beacon of Faith
			"tank.spell(53563).range" 
		}, "tank" },

	{{-- Interrupts
		{ "96231", "target.range <= 6", "target" },-- Rebuke
	}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
		
	-- Hands
		{ "6940", { -- Hand of Sacrifice
			"tank.spell(6940).range",
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HandofSacrifice')) end)
		}, "tank" },
		{ "6940", { -- Hand of Sacrifice
			"focus.spell(6940).range",
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HandofSacrifice')) end)
		}, "focus" },

	-- Survival     
		{ "498", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'DivineProtection')) end), nil }, -- Divine Protection
		{ "642", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'DivineShield')) end), nil }, -- Divine Shield

	-- Lay on Hands
		{ "!633", {
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'LayonHandsTank')) end),
			"focus.spell(633).range"
		}, "focus" }, 
		{ "!633", {
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'LayonHandsTank')) end),
			"tank.spell(633).range"
		}, "tank" }, 
		{ "!633", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'LayonHands')) end), "lowest" }, 
		
	-- Infusion of Light // proc
		{{-- AoE
			{ "82327", { -- Holy Radiance - Party
				"@coreHealing.needsHealing(80, 3)", 
				"player.buff(54149)",
				"!player.moving"
			}, "lowest" }, 
		}, "modifier.multitarget" }, 
		{ "82326", { -- Holy Light
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightIL')) end),
			"player.buff(54149)",
			"!player.moving" 
		}, "lowest" },

	-- Holy Shock
		{ "20473", {
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyShockTank')) end),
			"focus.spell(20473).range"
		}, "focus" },
		{ "20473", {
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyShockTank')) end),
			"tank.spell(20473).range"
		}, "tank" }, 
		{ "20473", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyShock')) end), "lowest" }, 

	{{-- AoE
	-- Light of Dawn
		{ "85222", { -- party
			"@coreHealing.needsHealing(90, 3)", 
			"player.holypower >= 3",
			"modifier.party" 
		}, "lowest" },
		{ "85222", { -- raid
			"@coreHealing.needsHealing(90, 5)", 
			"player.holypower >= 3", 
			"modifier.raid", 
			"!modifier.members > 10" 
		}, "lowest" }, 
		{ "85222", { -- raid 25
			"@coreHealing.needsHealing(90, 8)", 
			"player.holypower >= 3", 
			"modifier.members > 10" 
		}, "lowest" },
	-- Holy Radiance 
		{ "82327", { -- Holy Radiance - Party
			"@coreHealing.needsHealing(80, 3)", 
			"!lastcast",
			"!player.moving", 
			"modifier.party" 
		}, "lowest" }, 
		{ "82327", { -- Holy Radiance - Raid 10
			"@coreHealing.needsHealing(90, 5)", 
			"!lastcast", 
			"!player.moving", 
			"modifier.raid", 
			"!modifier.members > 10" 
		}, "lowest" }, 
		{ "82327", { -- Holy Radiance 10+
			"@coreHealing.needsHealing(90, 8)", 
			"!lastcast", 
			"!player.moving", 
			"modifier.members > 10" 
		}, "lowest" }, 
	}, "modifier.multitarget" },

	{{-- Beacon of Insight
		{ "157007", nil, "lowest" },
		{ "19750", { -- flash of light
			"lowest.health <= 40", 
			"!player.moving" 
		}, "lowest" },
		{ "82326", { -- Holy Light
			"lowest.health < 80",
			"!player.moving" 
		}, "lowest" },
	}, "talent(7,2)" },

	-- Flash of Light
		{ "!19750", { -- focus
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLightTank')) end), 
			"!player.moving",
			"focus.spell(19750).range"
		}, "focus" },
		{ "!19750", { -- tank
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLightTank')) end), 
			"!player.moving",
			"tank.spell(19750).range"
		}, "tank" },
		{ "!19750", { -- lowest
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLight')) end), 
			"!player.moving" 
		}, "lowest" },

	{{-- Cooldowns
		{ "#gloves" }, -- gloves
		{ "31821", "@coreHealing.needsHealing(40, 5)", nil }, -- Devotion Aura	
		{ "31884", "@coreHealing.needsHealing(95, 4)", nil }, -- Avenging Wrath
		{ "86669", "@coreHealing.needsHealing(85, 4)", nil }, -- Guardian of Ancient Kings
		{ "31842", "@coreHealing.needsHealing(90, 4)", nil }, -- Divine Favor
		{ "105809", "talent(5, 1)", nil }, -- Holy Avenger
	}, "modifier.cooldowns" },
	
	-- Execution Sentence // Talent
		{ "114157", {
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'ExecutionSentenceTank')) end),
			"focus.spell(114157).range"
		}, "focus" },
		{ "114157", {
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'ExecutionSentenceTank')) end),
			"tank.spell(114157).range"
		}, "tank" },
		{ "114157", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'ExecutionSentence')) end), "lowest" },

	{{-- Divine Purpose
		{ "85222", { -- Light of Dawn
			"@coreHealing.needsHealing(90, 3)", 
			"player.holypower >= 1",
			"modifier.party" 
			}, "lowest" },
		{ "85673", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGloryDP')) end), "lowest"  }, -- Word of Glory
		{ "114163", { -- Eternal Flame
			"!lowest.buff(114163)", 
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlameDP')) end) 
			}, "lowest" },
	}, "player.buff(86172)" },
	
	{{-- Selfless Healer
		{ "20271", "target.spell(20271).range", "target" }, -- Judgment
		{{ -- If got buff
			{ "19750", { -- Flash of light
				(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLightSH')) end),  
				"!player.moving" 
				}, "lowest" }, 
		}, "player.buff(114250).count = 3" }
	}, "talent(3, 1)" },

	{{-- Sacred Shield // Talent
		{ "148039", { 
			"player.spell(148039).charges >= 1", 
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShieldTank')) end), 
			"!tank.buff(148039)", -- SS
			"tank.range < 40" 
		}, "tank" },
		{ "148039", { 
			"player.spell(148039).charges >= 1", 
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShieldTank')) end), 
			"!focus.buff(148039)", 
			"focus.range < 40" 
		}, "focus" },
		{ "148039", { -- Sacred Shield
			"player.spell(148039).charges >= 2", 
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShield')) end), 
			"!player.buff(148039)" 
		}, "player" },
		{ "148039", { -- Sacred Shield
			"player.spell(148039).charges >= 2", 
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShield')) end), 
			"!lowest.buff(148039)" 
		}, "lowest" },
	}, "talent(3,3)" },

	{{-- Eternal Flame // talent
		{ "114163", { 
			"player.holypower >= 3", 
			"!focus.buff(114163)",
			"focus.spell(114163).range",
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlameTank')) end)
		}, "focus" },
		{ "114163", { 
			"player.holypower >= 3", 
			"!tank.buff(114163)",
			"focus.spell(114163).range",
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlameTank')) end)
		}, "tank" },
		{ "114163", { 
			"player.holypower >= 1", 
			"!lowest.buff(114163)", 
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlame')) end)
		}, "lowest" },
	}, "talent(3,2)" },

	-- Word of Glory
		{ "85673", {
			"player.holypower >= 3",
			"focus.spell(85673).range",
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGloryTank')) end) 
		}, "focus" },
		{ "85673", {
			"player.holypower >= 3",
			"focus.spell(85673).range",
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGloryTank')) end)
		}, "tank"  },
		{ "85673", {
			"player.holypower >= 3", 
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGlory')) end)
		}, "lowest"  },
		
	-- Crusader Strike
		{ "35395", {
			"target.range <= 6", 
			(function() return NeP.Core.PeFetch('npconfPalaHoly', 'CrusaderStrike') end) 
		}, "target" },

	-- Holy Prism // Talent
		{ "114165", { -- Holy Prism
			"player.holypower >= 3",
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyPrismTank')) end), 
			"!player.moving",
			"focus.spell(114165).range" 
		}, "focus"},
		{ "114165", { -- Holy Prism
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyPrismTank')) end), 
			"!player.moving",
			"tank.spell(114165).range" 
		}, "tank"},
		{ "114165", { -- Holy Prism
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyPrism')) end), 
			"!player.moving" 
		}, "lowest"},

	-- Holy Light
		{ "82326", { 
			(function() return NeP.Core.dynamicEval("focus.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightTank')) end),
			"!player.moving",
			"focus.spell(82326).range" 
		}, "focus" },
		{ "82326", { 
			(function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightTank')) end),
			"!player.moving",
			"focus.spell(82326).range" 
		}, "tank" },
		{ "82326", { 
			(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLight')) end),
			"!player.moving" 
		}, "lowest" },

} 

local outCombat = {
	
	-- keybinds
		{ "114158", "modifier.shift", "mouseover.ground"}, -- Light´s Hammer
		{ "!/focus [target=mouseover]", "modifier.alt" }, -- Mouseover Focus

	-- Buffs
		{ "20217", { -- Blessing of Kings
			"!player.buffs.stats",
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "Buff") == 'Kings' end),
		}, nil },
		{ "19740", { -- Blessing of Might
			"!player.buffs.mastery",
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "Buff") == 'Might' end),
		}, nil }, 
	
	-- Seals
		{ "20165", { -- seal of Insigh
			"player.seal != 2", 
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "seal") == 'Insight' end),
		}, nil }, 
		{ "105361", { -- seal of Command
			"player.seal != 1",
			(function() return NeP.Core.PeFetch("npconfPalaHoly", "seal") == 'Command' end),
		}, nil },

	{{-- Beacon of Faith
		{ "156910", {
			"!player.buff(53563)", -- Beacon of light
			"!player.buff(156910)" -- Beacon of Faith
		}, "player" },
	}, "talent(7,1)" },

	-- Beacon of light
		{ "53563", {
			"!tank.buff(53563)", -- Beacon of light
			"!tank.buff(156910)", -- Beacon of Faith
			"tank.spell(53563).range" 
		}, "tank" },

	-- hands
		{ "1044", "player.state.root" }, -- Hand of Freedom

	-- Start
		{ "20473", "lowest.health < 100", "lowest" }, -- Holy Shock

	{{-- AoE
	-- Light of Dawn
		{ "85222", { -- party
			"@coreHealing.needsHealing(90, 3)", 
			"player.holypower >= 3",
			"modifier.party" 
		}, "lowest" },
		{ "85222", { -- raid
			"@coreHealing.needsHealing(90, 5)", 
			"player.holypower >= 3", 
			"modifier.raid", 
			"!modifier.members > 10" 
		}, "lowest" }, 
		{ "85222", { -- raid 25
			"@coreHealing.needsHealing(90, 8)", 
			"player.holypower >= 3", 
			"modifier.members > 10" 
		}, "lowest" },
	-- Holy Radiance 
		{ "82327", { -- Holy Radiance - Party
			"@coreHealing.needsHealing(80, 3)", 
			"!lastcast",
			"!player.moving", 
			"modifier.party" 
		}, "lowest" }, 
		{ "82327", { -- Holy Radiance - Raid 10
			"@coreHealing.needsHealing(90, 5)", 
			"!lastcast", 
			"!player.moving", 
			"modifier.raid", 
			"!modifier.members > 10" 
		}, "lowest" }, 
		{ "82327", { -- Holy Radiance 10+
			"@coreHealing.needsHealing(90, 8)", 
			"!lastcast", 
			"!player.moving", 
			"modifier.members > 10" 
		}, "lowest" }, 
	}, "modifier.multitarget" },

	-- Holy Light
		{ "82326", { 
			(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightOCC')) end),
			"!player.moving" 
		}, "lowest" },

}

ProbablyEngine.rotation.register_custom(65,NeP.Core.CrInfo(), 
	inCombat, outCombat, lib)