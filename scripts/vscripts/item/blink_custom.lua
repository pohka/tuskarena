if item_blink_custom == nil then
    item_blink_custom = class({})
end

--custom blink dagger which purges all negative debuffs
function item_blink_custom:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	
	local vDiff = target - caster:GetAbsOrigin()
	local direction = vDiff:Normalized()
	local dist = vDiff:Length2D()
	
	local maxRange = self:GetSpecialValueFor("max_range")
	local penalty = self:GetSpecialValueFor("penalty_range")
	local newPos = target
	if dist > maxRange then
		newPos = caster:GetAbsOrigin() + (direction * Vector(penalty, penalty, penalty))
	end
	
	ProjectileManager:ProjectileDodge(caster)
	caster:Purge(false, true, false, true, true)
	FindClearSpaceForUnit(caster, newPos, true)
end