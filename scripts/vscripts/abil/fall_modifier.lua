fall_modifier = class({})

function fall_modifier:IsDebuff()
	return true;
end

function fall_modifier:IsPurgable()
	return true;
end

--start the thinker once created
function fall_modifier:OnCreated()
	if IsServer() then
		self:StartIntervalThink( 0.03 )
		self:OnIntervalThink(2)
	end
end

--move the player under the ground
function fall_modifier:OnIntervalThink()
	if IsServer() then
		local interval = 0.03
		
		--once the unit fall this many units they die
		local distToFall = 600 
		
		--speed of falling
		local fallSpeed = 30
		
		local caster = self:GetParent()
		local origin = caster:GetOrigin()
		local pos = origin + Vector(0,0,-fallSpeed)
		caster:SetAbsOrigin(pos)
		
		local ground = GetGroundPosition(pos, caster)
		local diff = caster:GetOrigin() - ground
		local distBelowGround = diff:Length()
		
		--the unit has fallen too far, they must be killed
		if distBelowGround >= distToFall then
		
			--move the player to the death point, this prevents a visual bug with the death animation
			local entPt = Entities:FindByName(nil, "death_point")
			local point = entPt:GetAbsOrigin()
			caster:SetAbsOrigin(point)
			
			--reset the movement to normal
			caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
			caster:RemoveGesture(ACT_DOTA_FLAIL)
			
			caster:ForceKill(false)
		end
	end
end

--if the modifier is purged or destroyed then reset the movement
function fall_modifier:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		caster:RemoveGesture(ACT_DOTA_FLAIL)
	end
end