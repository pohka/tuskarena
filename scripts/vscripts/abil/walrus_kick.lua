walrus_kick = class({})
LinkLuaModifier( "walrus_kick_modifier", "abil/walrus_kick_modifier", LUA_MODIFIER_MOTION_NONE )


function walrus_kick:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("speed")
	local dist = self:GetSpecialValueFor("distance")
	local travelTime = dist/speed
	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	local dest = target:GetAbsOrigin() + direction * 200
	
	local height = 250
	
	target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	target:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, 1.5)
	target:SetForwardVector(direction)
	Physics:MoveToWithArc(target, self, dest, height, travelTime, function() self:OnMoveEnd(target) end)
	
	caster:AddNewModifier( target, self, "walrus_kick_modifier", { duration = travelTime } )
end

function walrus_kick:OnMoveEnd(target)
	target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	target:RemoveGesture(ACT_DOTA_FLAIL)
end