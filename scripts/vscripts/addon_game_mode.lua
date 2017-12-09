-- Generated from template

if TuskArena == nil then
	TuskArena = class({})
end

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
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetPreGameTime( 4 )
	
	if IsInToolsMode() then
		GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay( 60 )
	end
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 4 )
	GameRules:SetPostGameTime(30)
	GameRules:SetHeroSelectionTime(45)
	GameRules:SetStartingGold(0)
	GameRules:SetStrategyTime(0)
	GameRules:SetShowcaseTime(0)
	GameRules:SetGoldPerTick(0)
	
	ListenToGameEvent("npc_spawned", TuskArena.EquipUnit, self)
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
	AddItemIfNotExist(spawnedUnit, "item_blink")
	AddItemIfNotExist(spawnedUnit, "item_refresher")
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