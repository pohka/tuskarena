-- Generated from template

if TuskArena == nil then
	TuskArena = class({})
end

require('util/physics')

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	
	PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf", context )
			
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = TuskArena()
	GameRules.AddonTemplate:InitGameMode()
end

function TuskArena:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity();
	GameMode:SetThink( "OnThink", self, "GlobalThink", 2 )
	
	GameRules:SetPreGameTime( 45 ) --warm up
	
	if IsInToolsMode() then
		GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay( 60 )
	end
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 4 )
	GameRules:SetPostGameTime(30)
	GameRules:SetHeroSelectionTime(30)
	GameRules:SetStartingGold(0)
	GameRules:SetStrategyTime(0)
	GameRules:SetShowcaseTime(0)
	GameRules:SetGoldPerTick(0)
	GameMode:SetDaynightCycleDisabled(true)
	--GameRules:SetHeroRespawnEnabled(false)
	
	ListenToGameEvent("npc_spawned", TuskArena.EquipUnit, self)
	ListenToGameEvent("game_rules_state_change", TuskArena.OnGameStateChange, self)
	ListenToGameEvent("entity_killed", TuskArena.OnEntityKilled, self)
end

-- Evaluate the state of the game
function TuskArena:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

--equips the unit with their starting items and abilities
function TuskArena:EquipUnit(event)
	local spawnedUnit = EntIndexToHScript( event.entindex )
	AddAbilityIfNotExist(spawnedUnit, "fall_lua")
	AddItemIfNotExist(spawnedUnit, "item_blink_custom")
	AddItemIfNotExist(spawnedUnit, "item_refresher_custom")
	TuskArena:LevelAllAbilities(spawnedUnit)
end

--adds an ability if the unit doesn't alreary have it
function AddAbilityIfNotExist(unit, abilityName)
	if unit:HasAbility(abilityName) == false then
		unit:AddAbility(abilityName)
	end
end

--adds an item if the unit doesn't alreary have it
function AddItemIfNotExist(unit, itemName)
	if unit:HasItemInInventory(itemName) == false then
		unit:AddItemByName(itemName)
	end
end

--called when the game state changes
function TuskArena:OnGameStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		RandomHeroes()
	end
end

--levels up all abilities on this unit to level 1
function TuskArena:LevelAllAbilities(unit)
	for i=0, unit:GetAbilityCount()-1 do
		local abil = unit:GetAbilityByIndex(i)
		if abil ~= nil then
			abil:SetLevel(1)
		end
	end
end

function TuskArena:OnEntityKilled(event)
	local ent = EntIndexToHScript(event.entindex_killed)
	--SetRespawnPosition(vector)
	--SetRespawnsDisabled()
	if ent:IsHero() then
		ent:SetTimeUntilRespawn(2)
	end
end

--randoms the heroes for every player who hasn't picked
function RandomHeroes()
	local minTeam = DOTA_TEAM_GOODGUYS
	local maxTeam = DOTA_TEAM_BADGUYS
	local maxPayersPerTeam = 5
	for teamNum = minTeam, maxTeam do
		for i=1, maxPayersPerTeam do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
			if playerID ~= nil then
				if PlayerResource:HasSelectedHero(playerID) == false then
					local hPlayer = PlayerResource:GetPlayer(playerID)
					if hPlayer ~= nil then
						hPlayer:MakeRandomHeroSelection()
					end
				end
			end
		end
	end
end