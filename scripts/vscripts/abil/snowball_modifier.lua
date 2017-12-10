snowball_modifier = class({})

function snowball_modifier:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
 
	return states
end