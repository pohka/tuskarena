fall_lua = class ({})
LinkLuaModifier( "fall_modifier", "abil/fall_modifier", LUA_MODIFIER_MOTION_NONE )

local timeSinceFall = 0;

--this ability is casted by the unit when it enters a trigger
function fall_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, 1.5)
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "fall_modifier", nil )
end