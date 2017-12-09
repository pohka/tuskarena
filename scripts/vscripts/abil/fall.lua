fall_lua = class ({})

local timeSinceFall = 0;

--activate the falling
function fall_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, 1.5)
	self:SetContextThink("Tick", function() return self:Tick() end, 0.03)
end

--falling thinker function
function fall_lua:Tick()
	local interval = 0.03
	local distToFall = 600
	local fallSpeed = 30
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local pos = origin + Vector(0,0,-fallSpeed)
	caster:SetAbsOrigin(pos)
	
	local ground = GetGroundPosition(pos, caster)
	local diff = caster:GetOrigin() - ground
	local distBelowGround = diff:Length()
	timeSinceFall = timeSinceFall + interval;
	
	if distBelowGround < distToFall and timeSinceFall < 2 then
		timeSinceFall = timeSinceFall + interval
		return interval
	else
		local entPt = Entities:FindByName(nil, "death_point")
		local point = entPt:GetAbsOrigin()
		caster:SetAbsOrigin(point)
		timeSinceFall = 0
		caster:ForceKill(false)
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		caster:RemoveGesture(ACT_DOTA_FLAIL)
	end
end