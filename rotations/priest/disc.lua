local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things! (SOLO)', 
		'Click here to dot all the things while in Solo mode!\nSome Spells require Multitarget enabled also.\nOnly Works if using FireHack.')

end

local BorrowedTime = {
	
	{ "17", { 
		"!focus.debuff(6788).any",
		"!focus.buff(10).any",
		"focus.range <= 40",
	}, "focus" }, 
	{ "17", {
		"!tank.debuff(6788).any",
		"!tank.buff(10).any",
		"tank.range <= 40",
	}, "tank" },
	{ "17", {
		"!player.debuff(6788).any",
		"!player.buff(10).any",
	}, "player" },
	{ "17", {
		"lowest.health < 100",
		"!lowest.debuff(6788).any",
		"!lowest.buff(10).any",
	}, "lowest" }, 

}

local Attonement = {

	{ "14914", { --Holy Fire
		"player.mana > 20",
		"target.spell(14914).range",
	}, "target" },
	{{-- not moving
		{ "47540", "target.spell(47540).range", "target" } ,-- Penance
		{ "585", "target.spell(585).range", "target" }, --Smite
	}, "!player.moving" },

}

local SpiritShell = {

	-- Prayer of Healing
   	{ "596", (function() return NeP.Lib.Priest.PoH() end) },
	-- Flash Heal
	{ "!2061", {
		"lowest.health <= 40",
		"!player.moving"
	}, "lowest" },
	-- Heal
	{ "2060", {
		"lowest.health >= 40",
		"!player.moving"
	}, "lowest" }, 

}

local Cooldowns = {

	
	{ "10060", "player.mana < 80" },-- Power Infusion
	{ "109964", {-- Spirit Shell // Party
		"@coreHealing.needsHealing(50, 5)",
		"modifier.party"
	} },
	{ "109964", {-- Spirit Shell // Raid
		"@coreHealing.needsHealing(50, 3)",
		"modifier.raid"
	} }, 

	--Pain Suppression	
		-- ALL
			{ "33206", { 
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppression") == 'Focus' end),
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppressionTG") == 'Allways' end),
				(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PainSuppressionHP')) end)
			}, "focus" },
			{ "33206", {
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppression") == 'Tank' end),
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppressionTG") == 'Allways' end),
				(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PainSuppressionHP')) end)
			}, "tank" },
			{ "33206", {
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppression") == 'Lowest' end),
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppressionTG") == 'Allways' end),
				(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PainSuppressionHP')) end)
			}, "lowest" },

		-- Boss
			{ "33206", { 
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppression") == 'Focus' end),
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppressionTG") == 'Boss' end),
				(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PainSuppressionHP')) end),
				"target.boss"
			}, "focus" },
			{ "33206", {
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppression") == 'Tank' end),
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppressionTG") == 'Boss' end),
				(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PainSuppressionHP')) end),
				"target.boss"
			}, "tank" },
			{ "33206", {
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppression") == 'Lowest' end),
				(function() return NeP.Core.PeFetch("npconfPriestDisc", "PainSuppressionTG") == 'Boss' end),
				(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PainSuppressionHP')) end),
				"target.boss"
			}, "lowest" },

}

local AoE = {

	{ "62618", {  -- Power word Barrier // w/t CD's and on tank // PArty
		"@coreHealing.needsHealing(50, 3)", 
		"modifier.party", 
		"!player.moving", 
		"modifier.cooldowns",
		(function() return NeP.Core.PeFetch("npconfPriestDisc", "PowerWordBarrier") end)
	}, "tank.ground" },
	{ "62618", {  -- Power word Barrier // w/t CD's and on tank // raid
		"@coreHealing.needsHealing(50, 5)", 
		"modifier.raid", 
		"!player.moving", 
		"modifier.cooldowns",
		(function() return NeP.Core.PeFetch("npconfPriestDisc", "PowerWordBarrier") end)
	}, "tank.ground" },
	{ "121135", { -- cascade
		"@coreHealing.needsHealing(95, 3)", 
		"!player.moving"
	}, "lowest"},
	{ "33076", { --Prayer of Mending
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PrayerofMendingTank')) end),
		"@coreHealing.needsHealing(90, 3)",
		"!player.moving", 
		"tank.spell(33076).range" 
	}, "tank" },
 	{ "596", (function() return NeP.Lib.Priest.PoH() end) },-- Prayer of Healing
   	{ "132157", (function() return NeP.Lib.Priest.holyNova() end), nil }, -- Holy Nova

}

local FlashHeal = {
	
	{ "!2061", {
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'FlashHealTank')) end),
		"focus.spell(2061).range",
		"!player.moving"
	}, "focus" },
	{ "!2061", {
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'FlashHealTank')) end), 
		"tank.spell(2061).range",
		"!player.moving"
	}, "tank" },
	{ "!2061", {
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'FlashHealPlayer')) end),
			"!player.moving"
	}, "player" },
		{ "!2061", {
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'FlashHealRaid')) end),
			"!player.moving"
	}, "lowest" },

}

local Normal = {

	-- Penance	
		{ "!47540", {
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PenanceRaid')) end),
			"!player.casting(2061)",
			"!player.moving",
			"!player.casting.percent >= 50"
		}, "lowest" }, 
	
	{{-- WorkAround a ID issue
	--Power Word: Shield
		{ "17", { 
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'ShieldTank')) end),
			"!focus.debuff(6788).any", 
			"focus.spell(17).range",
			"!focus.buff(17).any", 
		}, "focus" }, 
		{ "17", {
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'ShieldTank')) end),
			"!tank.debuff(6788).any", 
			"tank.spell(17).range",
			"!focus.buff(17).any", 
		}, "tank" },
		{ "17", {  --Power Word: Shield
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'ShieldRaid')) end),
			"!lowest.debuff(6788).any", 
			"!lowest.buff(17).any", 
		}, "lowest" },
		{ "17", {
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'ShieldPlayer')) end),
			"!player.debuff(6788).any", 
			"!player.buff(17).any", 
		}, "player" },
	}, "!lastcast(17)" },

	-- heal
		{ "2060", { -- Heal
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'HealTank')) end),
			"focus.spell(2060).range",
			"!player.moving"
		}, "focus" },
		{ "2060", {
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'HealTank')) end),
			"tank.spell(2060).range",
			"!player.moving"
		}, "tank" }, -- Heal
		{ "2060", { -- Heal	
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'HealPlayer')) end),
			"!player.moving"
		}, "player" },
		{ "2060", {-- Heal
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'HealRaid')) end),
			"!player.moving"
		}, "lowest" }, 

}

local Solo = {

	{{-- Auto Dotting
		{ "32379", (function() return NeP.Lib.AutoDots(32379, 0, 20) end) }, -- SW:D
		{ "589", (function() return NeP.Lib.AutoDots(589, 2, 100) end) }, -- SW:P 
	}, "toggle.dotEverything" },

  	-- CD's
		{ "10060", "modifier.cooldowns" }, --Power Infusion 

	-- Flash Heal
		{ "2061", { --Flash Heal
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'FlashHealPlayer')) end),
			"!player.moving"
		}, "player" },
	
	-- shields
		{ "17", { --Power Word: Shield
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'ShieldPlayer')) end),
			"!player.debuff(6788).any", 
			"!player.buff(17).any" 
		}, "player" },

}

local outCombat = {
	
	-- Heals 
		{ "!47540", { --Penance
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'PenanceRaid')) end),
			"!player.casting(2061)",
			"!player.moving"
		}, "lowest" },
		{ "2060", {-- Heal
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'HealRaid')) end),
			"!player.moving"
		}, "lowest" }, 

}

local Clarity_of_Will = {
	
	{ "152118", { -- tank
		(function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('npconfPriestDisc', 'CoWTank_spin')) end),
		(function() return NeP.Core.PeFetch('npconfPriestDisc', 'CoWTank_check') end) 
		"!player.moving",
		"!tank.buff(152118).any" -- Should we go any higher? 		
	}, "tank" },
	{ "152118", { -- raid
		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('npconfPriestDisc', 'CoW_spin')) end),
		(function() return NeP.Core.PeFetch('npconfPriestDisc', 'CoW_check') end) 
		"!player.moving",
		"!lowest.buff(152118).any" -- Should we go any higher? 		
	}, "lowest" },

}

local SavingGrace = {
	
	{ "!152116", {
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'SavingGraceTank_spin')) end), 
		(function() return NeP.Core.PeFetch('npconfPriestDisc', 'SavingGraceTank_check') end),
		"!player.moving",
	}, "focus" },
	{ "!152116", {
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'SavingGraceTank_spin')) end), 
		(function() return NeP.Core.PeFetch('npconfPriestDisc', 'SavingGraceTank_check') end),
		"!player.moving",
	}, "tank" },
	{ "!152116", {
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestDisc', 'SavingGrace_spin')) end), 
		(function() return NeP.Core.PeFetch('npconfPriestDisc', 'SavingGrace_check') end),
		"!player.moving",
	}, "lowest" },

}

local All = {

	-- Key Binds
		{ "48045", "modifier.alt", "target" }, -- Mind Sear
	
	-- buffs
		{ "21562", "!player.buffs.stamina" }, -- Fortitude
		{ "81700", "player.buff(81661).count = 5" }, -- Archangel
	
	{{-- Dispell ALl // Dont interrumpt if castbar more then 50%
		{ "!527", (function() return NeP.Lib.Dispell(function() return dispelType == 'Magic' or dispelType == 'Disease' end) end) },-- Dispel Everything
	}, "!player.casting.percent >= 50", (function() return NeP.Core.PeFetch('npconfPriestDisc','Dispels') end) },

	-- Sulvival
		{ "19236", "player.health <= 20", "player" }, --Desperate Prayer
		{ "#5512", "player.health <= 35" }, -- Health Stone
		{ "586", "target.threat >= 80" }, -- Fade
			-- Surge of light
			{ "2061", {-- Flash Heal
				"lowest.health < 100",
				"player.buff(114255)",
				"!player.moving"
			}, "lowest" },

	{{-- LoOk aT It GOoZ!!!
		{ "121536", { 
			"player.movingfor > 2", 
			"!player.buff(121557)", 
			"player.spell(121536).charges >= 1" 
		}, "player.ground" },
		{ "17", {
			"talent(2, 1)", 
			"player.movingfor > 2", 
			"!player.buff(17)",
		}, "player" },
	}, -- We only want to run these on unlockers that can cast on unit.ground
		(function()
			if FireHack or oexecute then
				return NeP.Core.PeFetch('npconfPriestDisc', 'Feathers') 
			end
		end)  
	},

}
	
ProbablyEngine.rotation.register_custom(256, NeP.Core.CrInfo(), 
	{ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ In-Combat
		 	------------------------------------------------------------------------------------------------------------------------------------- All in combat
		 		{ All },																									-- Shared across all
		 	------------------------------------------------------------------------------------------------------------------ Mana
			 	{ "123040", { ----------------------------------------------------------- Mindbender
					"player.mana < 85",				-- Need mana
					"target.range <= 40"			-- Spell in range
				}, "target" },--------------------------------------------------
				{ "34433", { ----------------------------------------------------------- Shadowfiend
					"player.mana < 85",				-- Need mana
					"target.range <= 40"			-- Spell in range
				}, "target" },--------------------------------------------------
				{ "129250", { ----------------------------------------------------------- PW:Solance
					"target.spell(129250).range",	-- Spell in range
					"talent(3,3)",					-- Got talent
					"target.infront"
				}, "target" },------------------------------------------------------------------------------------------
		{{ ------------------------------------------------------------------------------------------------------------------------------------- Party/Raid CR
				{ "32375", "modifier.control", "player.ground" }, 															-- Mass Dispel
				{ "62618", "modifier.shift", "tank.ground" },																-- Power word Barrier // w/t CD's and on tank // PArty
				{ Cooldowns, "modifier.cooldowns" },																		-- Cooldowns
				{ SavingGrace, {---------------------------------------------------------------------------------------------- Saving Grace // Talent
					"talent(7,3)",
					(function() return NeP.Core.dynamicEval("!player.debuff(155274) >= " .. NeP.Core.PeFetch('npconfPriestDisc', 'SavingGraceStacks')) end),
				}}, 
				{ Clarity_of_Will, "talent(7,1)" },																			-- Clarity of Will // Talent
				{ FlashHeal, {------------------------------------------------------------------------------------------------ Flash Heal // dont interrumpt if castbar more then 50%
					"!player.casting.percent >= 50",
					"!talent(7,3)"
				}},	
		 		{ BorrowedTime, "player.buff(59889).duration <= 2" },														-- BorrowedTime // Passive Buff
		 		{ SpiritShell, "player.buff(109964)" },																		-- SpiritShell // Talent
			 	{ Attonement, {----------------------------------------------------------------------------------------------- Attonement
			 		(function() return NeP.Core.dynamicEval("lowest.health >= " .. NeP.Core.PeFetch('npconfPriestDisc', 'Attonement')) end),
					(function() return NeP.Lib.Infront('target') end),
					--"!player.buff(81661).count = 5",
					"!player.mana < 20",
					--"target.range <= 30",
					--"target.infront"
			 	}}, ----------------------------------------------------------------------------------------------------------
		 		{ AoE, "modifier.multitarget" },																			-- AoE Heals
				{ Normal}																									-- Normal Heals
		}, "modifier.party" },
		{{ ------------------------------------------------------------------------------------------------------------------------------------- Solo CR
			{ FlashHeal, "!player.casting.percent >= 50" },
			{ Solo },
			{ Attonement },
		}, "!modifier.party" },
	},  
	{ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ Out-Combat
		{ All },
		{ FlashHeal, "!player.casting.percent >= 50" },
		{outCombat}
	}, exeOnLoad)