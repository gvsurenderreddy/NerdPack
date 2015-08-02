--[[
	This is a Lib containing shared conditions
	Across all Scripts.
]]
NeP.Lib = {}

--[[-----------------------------------------------
** Infront **
DESC: Checks if unit is infront.
Replaces PE build in one beacuse PE's is over sensitive.

Build By: Mirakuru
Modified by: MTS
---------------------------------------------------]]
function NeP.Lib.Infront(unit)
	if UnitExists(unit) and UnitIsVisible(unit) then
		-- FireHack
		if FireHack then
			local aX, aY, aZ = ObjectPosition(unit)
			local bX, bY, bZ = ObjectPosition('player')
			local playerFacing = GetPlayerFacing()
			local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
			return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
		-- Fallback to PE's
		else
			return ProbablyEngine.condition["infront"](unit)
		end
	end
end

--[[-----------------------------------------------
** Smart AoE **
DESC: PE's way to handle smart AoE does not provide
support for generic unlockers, using this + my OM makes it work
across all unlockers.

Build By: MTS
---------------------------------------------------]]
function NeP.Lib.SAoE(units, distance)
	local UnitsTotal = 0
	if NeP.ObjectManager.unitCacheTotal >= units 
	and NeP.Core.PeConfig.read('button_states', 'multitarget', false) then
		for i=1,#NeP.ObjectManager.unitCache do
			local object = NeP.ObjectManager.unitCache[i]
			if object.distance <= distance then
				UnitsTotal = UnitsTotal + 1
			end
		end
	end
	return UnitsTotal
end

--[[-----------------------------------------------
** NeP.Lib.Distance **
DESC: Sometimes PE's behaves badly,
So here we go...

Build By: MTS
---------------------------------------------------]]
local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function NeP.Lib.Distance(a, b)
	-- FireHack
	if FireHack then
		local ax, ay, az = ObjectPosition(a)
		local bx, by, bz = ObjectPosition(b)
		return round(math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)))
	else
		return ProbablyEngine.condition["distance"](b)
	end
	return 0
end

function NeP.Lib.canTaunt()
	if NeP.Core.PeFetch('npconf', 'Taunts') then
		for i=1,#NeP.ObjectManager.unitCache do
			local object = NeP.ObjectManager.unitCache[i].key
			if UnitIsTappedByPlayer(object) and object.distance <= 40 then
				if UnitThreatSituation(object) and UnitThreatSituation(object) >= 2 then
					if NeP.Lib.Infront(object) then
						ProbablyEngine.dsl.parsedTarget = object
						return true 
					end
				end
			end
		end
	end
	return false
end

function NeP.Lib.Dispell(dispelTypes)
	local blacklistedDebuffs = {
		'Mark of Arrogance',
		'Displaced Energy'
	}
	if NeP.Core.PeFetch('npconf', 'Dispells') then
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
			local object = NeP.ObjectManager.unitCache[i].key
			if object.distance <= 40 then
				for j = 1, 40 do
					local debuffName, _,_,_, dispelType, duration, expires,_,_,_,_,_,_,_,_,_ = UnitDebuff(object, j)
					if dispelType and dispelTypes then
						local ignore = false
						for k = 1, #blacklistedDebuffs do
							if debuffName == blacklistedDebuffs[k] then
								ignore = true
								break
							end
						end
						if not ignore then
							ProbablyEngine.dsl.parsedTarget = object
							return true
						end
					end
					if not debuffName then
						break
					end
				end
			end
		end
	end
	return false
end

--[[
Usage:
NeP.Lib.AutoDots(spell, remaning, health, Classification)

Classifications:
	elite - Elite
	minus - Minion of another NPC; does not give experience or reputation.
	normal - Normal
	rare - Rare
	rareelite - Rare-Elite
	worldboss - World Boss
]]
function NeP.Lib.AutoDots(spell, remaning, health, Classification)
	if Classification == nil then Classification = 'normal' end
	for i=1,#NeP.ObjectManager.unitCache do
		local object = NeP.ObjectManager.unitCache[i]
		if UnitClassification(object) == Classification then
			if object.health <= health then
				local _,_,_,_,_,_,debuff = UnitDebuff(object.key, GetSpellInfo(spell), nil, "PLAYER")
				if not debuff or debuff - GetTime() < remaning then
					if UnitCanAttack("player", object.key)
					and IsSpellInRange(GetSpellInfo(spell), object.key) then
						if NeP.Lib.Infront(object.key) then
							ProbablyEngine.dsl.parsedTarget = object.key
							return true
						end					 
					end
				end
			end
		end
	end
end