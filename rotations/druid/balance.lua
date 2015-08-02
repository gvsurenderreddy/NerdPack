local exeOnLoad = function()
	NeP.Splash()

  	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things!', 
		'Click here to dot all the things!\nSome Spells require Multitarget enabled also.\nOnly Works if using FireHack.')
end

local BoomkinForm = {
			
	{{-- Interrupts
		{ "78675" }, -- Solar Beam
	}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
	
	-- Items
		{ "#5512", "player.health < 50" }, --Healthstone
	
	-- Cooldowns
		{ "112071", "modifier.cooldowns" }, --Celestial Alignment
		{ "#trinket1", "modifier.cooldowns" }, --trinket 1
		{ "#trinket2", "modifier.cooldowns" }, --trinket 2
		{ "#57723", "player.hashero" }, --  Int Pot on lust
 
	--Defensive
		{ "Barkskin", "player.health <= 50", "player" },
		{ "#5512", "player.health < 40"}, --Healthstone when less than 40% health
		{ "108238", "player.health < 60", "player"}, --Instant renewal when less than 40% health
	
	{{ -- Auto Dotting	
		{ "164812", (function() return NeP.Lib.AutoDots(164812, 2, 100) end) }, -- moonfire
		{ "164815", (function() return NeP.Lib.AutoDots(164815, 2, 100) end) }, --SunFire
	}, "toggle.dotEverything" },

	-- AoE
		{ "48505", "modifier.multitarget", "target" }, -- Starfall
		{ "48505", "player.area(8).enemies >= 4", "target" }, -- Starfall  // FH SMART AoE
	
	-- Proc's
		{ "78674", "player.buff(Shooting Stars)", "target" }, --Starsurge with Shooting Stars Proc
		{ "164815", "player.buff(Solar Peak)", "target" }, --SunFire on proc
		{ "164812", "player.buff(Lunar Peak)", "target" }, --MoonFire on proc
	
	-- Rotation
		{ "78674", "player.spell(78674).charges >= 2" }, --StarSurge with more then 2 charges
		{ "78674", "player.buff(112071}" }, --StarSurge with Celestial Alignment buff
		{ "164812", "target.debuff(Moonfire).duration <= 2"}, --MoonFire
		{ "164815", "target.debuff(Sunfire).duration <= 2"}, --SunFire
		{ "2912", "player.buff(Lunar Empowerment).count >= 1" }, --Starfire with Lunar Empowerment
		{ "5176", "player.buff(Solar Empowerment).count >= 1" }, --Wrath with Solar Empowerment
		{ "2912", "player.lunar"}, --StarFire
		{ "5176", "player.solar"},  --Wrath
		--{ "2912" }, --StarFire Filler
  
}

ProbablyEngine.rotation.register_custom(102, NeP.Core.CrInfo(), 
	{ ------------------------------------------------------------------------------------------------------------------ In Combat
		{ "1126", {  -- Mark of the Wild
			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
			"!player.buff(5215)",-- Not in Stealth
			"player.form = 0", -- Player not in form
			(function() return NeP.Core.PeFetch('npconfDruidBalance','Buffs') end),
		}},
		{ "20484", { -- Rebirth
			"modifier.lshift", 
			"!mouseover.alive" 
		}, "mouseover" },
	  	{ "/run CancelShapeshiftForm();", (function() 
	  		if NeP.Core.dynamicEval("player.form = 0") or NeP.Core.PeFetch('npconfDruidBalance', 'Form') == 'MANUAL' then
	  			return false
	  		elseif NeP.Core.dynamicEval("player.form != 0") and NeP.Core.PeFetch('npconfDruidBalance', 'Form') == '0' then
	  			return true
	  		else
	  			return NeP.Core.dynamicEval("player.form != " .. NeP.Core.PeFetch('npconfDruidBalance', 'Form'))
	  		end
	  	end) },
		{ "768", { -- catform
	  		"player.form != 2", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','Form') == '2' end),
	  	}},
	  	{ "783", { -- Travel
	  		"player.form != 3", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','Form') == '3' end),
	  	}},
	  	{ "5487", { -- catform
	  		"player.form != 1", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','Form') == '1' end),
	  	}},
	  	{ "24858", { -- boomkin
	  		"player.form != 4", -- Stop if boomkin
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','Form') == '4' end),
	  	}},
	  	{{ --------------------------------------------------------------------------------- Boomkin Form
	  		{ BoomkinForm },
		}, "player.form = 4" },
	}, 
	{ ------------------------------------------------------------------------------------------------------------------ Out Combat
		{ "1126", {  -- Mark of the Wild
			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
			"!player.buff(5215)",-- Not in Stealth
			"player.form = 0", -- Player not in form
			(function() return NeP.Core.PeFetch('npconfDruidBalance','Buffs') end),
		}},
		{ "20484", { -- Rebirth
			"modifier.lshift", 
			"!mouseover.alive" 
		}, "mouseover" },
	  	{ "/run CancelShapeshiftForm();", (function() 
	  		if NeP.Core.dynamicEval("player.form = 0") or NeP.Core.PeFetch('npconfDruidBalance', 'FormOCC') == 'MANUAL' then
	  			return false
	  		elseif NeP.Core.dynamicEval("player.form != 0") and NeP.Core.PeFetch('npconfDruidBalance', 'FormOCC') == '0' then
	  			return true
	  		else
	  			return NeP.Core.dynamicEval("player.form != " .. NeP.Core.PeFetch('npconfDruidBalance', 'FormOCC'))
	  		end
	  	end) },
		{ "768", { -- catform
	  		"player.form != 2", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','FormOCC') == '2' end),
	  	}},
	  	{ "783", { -- Travel
	  		"player.form != 3", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','FormOCC') == '3' end),
	  	}},
	  	{ "5487", { -- catform
	  		"player.form != 1", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','FormOCC') == '1' end),
	  	}},
		{ "24858", { -- boomkin
	  		"player.form != 4", -- Stop if boomkin
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidBalance','FormOCC') == '4' end),
	  	}},
	}, exeOnLoad)