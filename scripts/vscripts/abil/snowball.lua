snowball = class({})
LinkLuaModifier( "snowball_modifier", "abil/snowball_modifier", LUA_MODIFIER_MOTION_NONE )

--custom snowball which is travels towards a point target
function snowball:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local dist = self:GetSpecialValueFor("distance")
	local direction = target - caster:GetAbsOrigin()
	
	ProjectileManager:ProjectileDodge(caster)
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1.5)
	
	--add modifier to mute and make the caster invulnerable
	caster:AddNewModifier( caster, self, "snowball_modifier", { duration = dist/speed } )
	
	self:move(direction, dist, speed, function() self:OnMoveEnd() end)
end

function snowball:move(direction, dist, speed)
	local TICK_RATE = 0.03
	local travelTime = dist/speed
	local caster = self:GetCaster()
	local startingAngle = caster:GetAnglesAsVector()
	caster:SetModel("models/particle/snowball.vmdl")
	caster:SetModelScale(0.4)
	
	
	if IsServer() then
		caster:SetOrigin(caster:GetOrigin()+ Vector(0,0,30))
		self:SetContextThink("Tick", 
		function() 
			travelTime = travelTime - TICK_RATE
			if travelTime > 0 then
				caster:SetModelScale(caster:GetModelScale() + TICK_RATE)
				local nextOrigin = caster:GetOrigin() + Physics:ConstantVelocity(direction, dist, speed) + Vector(0,0,1*TICK_RATE)
				caster:SetOrigin(nextOrigin)
				local angles = caster:GetAnglesAsVector()
				caster:SetAngles(angles.x+(700*TICK_RATE), angles.y, angles.z)
			end
			if travelTime > -0.05 then
				return TICK_RATE
				
			--end of thinker
			else
				caster:SetModelScale(1)
				caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
				caster:SetAngles(startingAngle.x, startingAngle.y, startingAngle.z)
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
				
				if callback ~= nil then
					callback()
				end
			end
		end, TICK_RATE)
	end
end

--callback function for the end of movement
function snowball:OnMoveEnd()
	local caster = self:GetCaster()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	caster:SetModelScale(1)
	caster:SetModel("models/heroes/tuskarr/tuskarr.vmdl")
end