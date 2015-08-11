local _holyNova = function()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
		local object = NeP.ObjectManager.unitFriendlyCache[i]
		local healthMissing = max(0, object.maxHealth - object.actualHealth)
			if healthMissing > minHeal and UnitIsFriend("player", object.key) then
				if object.distance <= 12 then
				total = total + 1
				end
			end
		end
	return total > 3
end

local _PoH = function()
	local minHeal = GetSpellBonusDamage(2) * 2.21664
	local GetRaidRosterInfo, min, subgroups, member = GetRaidRosterInfo, math.min, {}, {}
	local lowest, lowestHP, _, subgroup = false, 0
	local start, groupMembers = 0, GetNumGroupMembers()
		if IsInRaid() then
			start = 1
		elseif groupMembers > 0 then
			groupMembers = groupMembers - 1
		end
		for i = start, groupMembers do
			local _, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
			if not subgroups[subgroup] then
				subgroups[subgroup] = 0
				member[subgroup] = ProbablyEngine.raid.roster[i].unit
			end
				subgroups[subgroup] = subgroups[subgroup] + min(minHeal, ProbablyEngine.raid.roster[i].healthMissing)
		end
			for i = 1, #subgroups do
				if subgroups[i] > minHeal * 4 and subgroups[i] > lowestHP then
				lowest = i
				lowestHP = subgroups[i]
				end
			end
			if lowest then
				ProbablyEngine.dsl.parsedTarget = member[lowest]
			return true
		end
	return false
end

local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things! (SOLO)', 
		'Click here to dot all the things while in Solo mode!\nSome Spells require Multitarget enabled also.\nOnly Works if using FireHack.')
end

local _Tank = {
	{ "47540", "tank.health <= 85", "tank" }, -- Penance
	{ "17", {  --Power Word: Shield
		"tank.health < 100",
		"!tank.debuff(6788).any", 
		"!tank.buff(17).any",
	}, "tank" },
	{ "2060", "tank.health < 100", "tank" }, -- Heal
}

local _Player = {
	{ "19236", "player.health <= 20", "player" }, --Desperate Prayer
	{ "#5512", "player.health <= 35" }, -- Health Stone
	{ "586", "target.threat >= 80" }, -- Fade
	
	-- Heals
	{ "47540", "player.health <= 85", "player" }, -- Penance
	{ "17", {  --Power Word: Shield
		"player.health < 100",
		"!player.debuff(6788).any", 
		"!player.buff(17).any",
	}, "player" },
	{ "2061", "player.health <= 50", "player" }, --Flash Heal
	{ "2060", "player.health < 100", "player" }, -- Heal
}

local _Raid = {
	{ "47540", "lowest.health <= 85", "lowest" }, -- Penance
	{ "17", {  --Power Word: Shield
		"lowest.health <= 60",
		"!lowest.debuff(6788).any", 
		"!lowest.buff(17).any",
	}, "lowest" },
	{ "2061", "lowest.health <= 50", "lowest" }, --Flash Heal
	{ "2060", {-- Heal
		"lowest.health < 100",
		"!player.moving"
	}, "lowest" }, 
}

local _Attonement = {
	{ "14914", { --Holy Fire
		"player.mana > 20",
		"target.spell(14914).range",
	}, "target" },
	{{-- not moving
		{ "47540", "target.spell(47540).range", "target" } ,-- Penance
		{ "585", "target.spell(585).range", "target" }, --Smite
	}, "!player.moving" },

}

local _Fast = {
	{ "!47540", "lowest.health <= 30", "lowest" }, -- Penance
	{ "!17", {  -- Power Word: Shield
		"lowest.health <= 30",
		"!lowest.debuff(6788).any", 
		"!lowest.buff(17).any",
	}, "lowest" },
	{ "!2061", "lowest.health <= 30", "lowest" }, --Flash Heal
}

local AoE = {
	{ "121135", "@coreHealing.needsHealing(95, 3)", "lowest"}, -- Cascade
 	{ "596", (function() return _PoH() end) },-- Prayer of Healing
   	{ "132157", (function() return _holyNova() end), nil }, -- Holy Nova
}

local _All = {
	-- Buffs
	{ "21562", "!player.buffs.stamina" }, -- Fortitude
	
	-- LoOk aT It GOoZ!!!
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
}

local _Solo = {

	{{-- Auto Dotting
		{ "32379", (function() return NeP.Lib.AutoDots('32379', 20) end) }, -- SW:D
		{ "589", (function() return NeP.Lib.AutoDots('589', 100) end) }, -- SW:P 
	}, "toggle.dotEverything" },

  	-- CD's
		{ "10060", "modifier.cooldowns" }, --Power Infusion 
}

ProbablyEngine.rotation.register_custom(256, NeP.Core.GetCrInfo('Priest - Discipline'), 
	{ -- In-Combat
		{{ -- Party/Raid
			{{-- Dispell ALl // Dont interrumpt if castbar more then 50%
				{ "!527", (function() return NeP.Lib.Dispell(
					function() return dispelType == 'Magic' or dispelType == 'Disease' end
				) end) },
			}},
			{ "81700", "player.buff(81661).count = 5" }, -- Archangel
			{_All},
			{_Fast, {"!player.casting.percent >= 50", "lowest.health <= 30"} },
			{{ -- Conditions
				{_Attonement, {"!lowest.health < 90", "!player.buff(81661).count = 5", "!player.mana <= 20"} },
				{_AoE, "modifier.multitarget"},
				{_Tank},
				{_Player},
				{_Raid}
			}, "!player.moving" },
		}, "modifier.party" },
		{{ -- Solo
			{_All},
			{_Player},
			{_Solo}
		}, "!modifier.party" },
	},  
	{ -- Out-Combat
		{_All},
	}, exeOnLoad)