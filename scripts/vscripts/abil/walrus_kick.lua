walrus_kick = class({})
LinkLuaModifier( "walrus_kick_modifier", "abil/walrus_kick_modifier", LUA_MODIFIER_MOTION_NONE )


function walrus_kick:OnSpellStart()
	Physics:ConstantVelocity()
	local caster = self:GetCaster()
	caster:AddNewModifier( caster, self, "walrus_kick_modifier", { duration = travelTime } )
end