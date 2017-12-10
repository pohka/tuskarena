walrus_kick = class({})
LinkLuaModifier( "walrus_kick_modifier", "abil/walrus_kick_modifier", LUA_MODIFIER_MOTION_NONE )


function walrus_kick:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("speed")
	local dist = self:GetSpecialValueFor("distance")
	local travelTime = dist/speed
	
	Physics:MoveWithArc(unit, ability, disableMovement, direction, distance, speed)
	
	caster:AddNewModifier( target, self, "walrus_kick_modifier", { duration = travelTime } )
end