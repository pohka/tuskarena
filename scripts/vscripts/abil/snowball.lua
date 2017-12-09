snowball = class({})
LinkLuaModifier( "snowball_modifier", "abil/snowball_modifier", LUA_MODIFIER_MOTION_NONE )

--custom snowball which is travels towards a point target
function snowball:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	
	local speed = self:GetSpecialValueFor("speed")
	local dist = self:GetSpecialValueFor("distance")
	
	local tickTime = 0.03
	local vDiff = (target - caster:GetAbsOrigin()):Normalized() * dist
	
	
	local timeInSnowball = dist/speed
	
	local tickCount = timeInSnowball/tickTime
	local vTickDiff = vDiff/tickCount
	
	--add modifier to mute and make the caster invulnerable
	caster:AddNewModifier( caster, self, "snowball_modifier", { duration = timeInSnowball } )
	
	--move the caster in the direction each tick
	self:SetContextThink("Tick", 
		function() 
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin() + vTickDiff, false)
			timeInSnowball = timeInSnowball - tickTime
			if timeInSnowball > 0 then
				return tickTime
			end
		end, 
		tickTime)
	
	--find clear space for caster
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end