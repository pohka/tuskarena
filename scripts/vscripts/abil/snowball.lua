snowball = class({})
LinkLuaModifier( "snowball_modifier", "abil/snowball_modifier", LUA_MODIFIER_MOTION_NONE )

--custom snowball which is travels towards a point target
function snowball:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	
	local speed = self:GetSpecialValueFor("speed")
	local dist = self:GetSpecialValueFor("distance")
	local direction = target - caster:GetAbsOrigin()
	
	Physics:MoveWithContantVelocity(caster, self, true, direction, dist, speed)
	
	--add modifier to mute and make the caster invulnerable
	caster:AddNewModifier( caster, self, "snowball_modifier", { duration = dist/speed } )
end