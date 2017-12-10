walrus_kick_modifier = class({})

function walrus_kick_modifier:OnCreated()
	
end

function walrus_kick_modifier:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	return states
 end